#!/bin/bash
echo "Checking for configfiles"


GIT_DIRS_FILE="$HOME/.config/git_dirs"

if [ -f "$GIT_DIRS_FILE" ]
then
	CONF_LOOK_DIRS=''
	echo ".config/git_dirs config file found."
	CONF_LOOK_DIRS=$( while read -r line; do echo "$line" ;done  <  ~/.config/git_dirs )


	GIT_LINKS_DIR="$HOME/.config/git_links.d"

	if [ -d "$GIT_LINKS_DIR" ]
	then
	echo ".config/git_links.d folder found"
		(find "$GIT_LINKS_DIR" -maxdepth 1 -type d ) | while read -r FOLDER
		do
			(
			(find "$FOLDER" -maxdepth 1 -type f ) | while read -r FILE
			do
				while read -r PUTPLACE LINK
				do
					(
					if [ ! -d "$PUTPLACE" ]
					then
						echo ""; echo "Creating new directory:" "$PUTPLACE"
						mkdir -p "$PUTPLACE"; cd "$PUTPLACE" || return
						git clone "$LINK" .
					fi
					)
					
					PARENTDIR="$(dirname -- "$(readlink -f -- "$PUTPLACE")")"
					if [ "$(grep -Fxq "$PARENTDIR" "$GIT_DIRS_FILE")" ]
					then 
						echo "Parent directory $PARENTDIR is not in $GIT_DIRS_FILE. Entry is added"
						echo "$PARENTDIR" >> "$GIT_DIRS_FILE"
					fi
				done < "$FILE"
				
			done
			)
		done
	fi

fi

GIT_EDITOR_FILE="$HOME/.config/syncallgit_editor_cmd"

if [ -f "$GIT_EDITOR_FILE" ]
then
	SYNCALLGIT_EDITOR_CMD="$(cat "$GIT_EDITOR_FILE")" 
else
	echo "no .config/syncallgit_editor_cmd file found. Using xterm -e vim as a default"
	SYNCALLGIT_EDITOR_CMD="xterm -e vim"
fi




LOOK_DIRS=${1:-$CONF_LOOK_DIRS}

echo ""; echo "Looking for git folders in:"
echo "$LOOK_DIRS"

for ELEMENT in $LOOK_DIRS
do
 	echo ""; echo "Checking folder:" "$ELEMENT"
#	for FOLDER in $(find "$ELEMENT" -maxdepth 1 -type d ); do
	(find "$ELEMENT" -maxdepth 1 -type d ) | while read -r FOLDER
	do
	if [ -d "$FOLDER"/.git ]; then
		echo "Git folder found in:" "$FOLDER"
	   	cd "$FOLDER" || return 
		git pull 
		if [ "$(git diff --stat)" != '' ]
		then
			echo "Uncommitted local changes found. Starting commit and push "
			#THIS IS A WORKAROUND TO THE FOLLOWING ISSUE WITH "git commit -a" WHEN USING SIGNED COMMITS

			#hint: Waiting for your editor to close the file... Vim: Warning: Input is not from a terminal
			#Vim: Error reading input, exiting.

			git commit -a --dry-run > .git/COMMIT_EDITMSG; sed -i -e 's/^/#/' .git/COMMIT_EDITMSG; sed -i -e '1i\INSERT YOUR COMMIT MESSAGE HERE\' .git/COMMIT_EDITMSG
			$SYNCALLGIT_EDITOR_CMD .git/COMMIT_EDITMSG; 
			#EDITORPID=$!
			#wait "$EDITORPID"
			sed -i -e '/^[[:blank:]]*#/d;s/#.*//' .git/COMMIT_EDITMSG  
			git commit -a -F .git/COMMIT_EDITMSG; git push; echo "" 
		fi
		if [ "$(git diff origin/master master)" != ''  ]
		then 
				echo "Unpushed local commits to master branch found. Starting push."
				(git push origin master)
	  	fi
	fi
	done
done
