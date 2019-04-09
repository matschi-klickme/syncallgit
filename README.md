# syncallgit
Simple script to sync (pull, commit, push) git repos listed in ~/.config/git_dirs - file.

The perfect start into your day!

The script looks for:
* remote changes in currently checkend out banches 
* local, uncommited or unpushed changes in currently checked out branches
* unpushed commits to the local master branch of repos


# Config
If "~/.config/git_dirs" file exists, it will be used. Otherwise $PWD 

## git_dirs file: 
one full path per line,
* eighter to git-repo
* or folders containing git-repos

( Suggestion: put in the loction of the "syncallgit" -git dir first )

# Avoid annoying stuff:

## untracked files: 
The ".gitignore" file is your friend!

## Authentication: 
Switch to ssh-key based auth to avoid annoying "please enter your account/pw" messages 

## running as root 

### option #1: via ssh -A root@localhost 
 * create folder /git_root. In that folder:
     * git clone https://github.com/matschi-klickme/syncallgit.git
        * echo "/git_root" >> /root/.config/git_dirs
        * clone additional repos
        * symlink relevant files to desired locations
 * auto pull/push of all git folders in /git/root as from a regular user shell via {{{ ssh -A root@localhost /git_root/syncallgit.sh  }}}
    * ssh stuff needs to be setup
    * you probably need to set your root's git editor: git config --global core.editor "EDITOR"   (replace with desired editor, eg "vim", "nano", etc )
