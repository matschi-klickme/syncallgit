# syncallgit
Simple script to sync (pull, commit, push) git repos listed in ~/.config/git_dirs - file.

The perfect start into your day!

The script looks for:
* remote changes in currently checkend out banches 
* local, uncommited or unpushed changes in currently checked out branches
* unpushed commits to the local master branch


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

## Updating root-owned directories from user shell per ssh -A
Setup /root/git folder and /root/.config/git_dirs file:

 * create folder `mkdir /root/git`. In that folder:
     * `git clone https://github.com/matschi-klickme/syncallgit.git`
        * Create git_dirs file for root: `echo "/root/git" >> /root/.config/git_dirs`
        * clone additional repos
        * symlink relevant files to desired locations

### option #1: via ssh -A root@localhost 
SSH-key based authentication needs to be set up for this

 * you might need to set your root's git editor: `git config --global core.editor "EDITOR"`   (replace with desired editor, eg "vim", "nano", etc )
 * use `ssh -A root@localhost /root/git/syncallgit.sh` to auto sync repos in /root/git and all additional entries in /root/.conf/git_dirs from a regular user shell 
  
