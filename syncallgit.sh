#!/bin/bash
echo "Checking for configfiles"

if [ -f ~/.config/syncallgit_editor_cmd ]
then
	SYNCALLGIT_EDITOR_CMD="$(cat ~/.config/syncallgit_editor_cmd)" 
else
	echo "no .config/syncallgit_editor_cmd file found. Using xterm -e vim as a default"
	SYNCALLGIT_EDITOR_CMD="xterm -e vim"
fi

if [ -f ~/.config/git_dirs ]
then
	CONF_LOOK_DIRS=$( while read -r line; do echo "$line" ;done  <  ~/.config/git_dirs )
	echo ".config/git_dirs Config file found."
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
	(
	   echo "Git folder found in:" "$FOLDER"
	   	cd "$FOLDER" || return 
		git pull 
		if [ "$(git diff --stat)" != '' ]
		then
			echo "Uncommitted local changes found. Starting commit and push "
			#THIS IS A WORKAROUND TO THE FOLLOWING ISSUE WITH "git commit -a" WHEN USING SIGNED COMMITS

			#hint: Waiting for your editor to close the file... Vim: Warning: Input is not from a terminal
			#Vim: Error reading input, exiting.

			git commit -a --dry-run > .git/COMMIT_EDITMSG; sed -i -e 's/^/#/' .git/COMMIT_EDITMSG
			$SYNCALLGIT_EDITOR_CMD .git/COMMIT_EDITMSG  
			git commit -a -F .git/COMMIT_EDITMSG; git push; echo "" 
		fi
		if [ "$(git diff origin/master master)" != ''  ]
		then 
				echo "Unpushed local commits to master branch found. Starting push."
				(git push origin master)
	  	fi
	)
	fi
	done
done
