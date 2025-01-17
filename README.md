# syncallgit
Simple script to sync ( clone, pull, commit, push) git repos. 

The perfect way to start&end your day!

# Usage

`syncallgit.sh {optional directory}`

The script 
* creates directories and clones repositories according to git_links.d
* takes a look at all directories and their subfolders in the git_dirs file
* executes desired versions of `git pull` 
* and checks for
    * remote changes in currently checkend out banches 
    * local, uncommited or unpushed changes in currently checked out branches
    * unpushed commits to the local master branch

Use the {optional directory} to check a single directory - otherwise the script will use it's config files. 

# Config
The script uses the following configuration files if they exist: 

## $HOME/.config/git_links.d directory:
For folders that contain files telling where to put which repo if it doesn't yet exist in filesystem

git_links.d/
        FOLDERNAME/
            filename.conf

Syntax for files: 
"full targetpath"  "link for cloning"     

* If necessary the directories and parents are created and added to the git_dirs file automatically.
* .git folders in this directory are ignored, so you're safe to use a git repo for this directory ( for replication etc )

## $HOME/.config/git_dirs file: 
List of (parent-) directories containing git folders to be synced.

* one full path per line,
* eighter to folder containing /.git or
* parent-folders containing folders 

( Suggestion: put in the loction of the "syncallgit" -git dir first )

## $HOME/.config/syncallgit_editor_cmd file:
The command to edit git comments - as a workaround to issues with gpg signed commits, when git's default `core.editor config` might cause input problems. 

Default: `xterm -e vim`
Suggested Alternatives: `gedit -s`

## config file options for git directories: 
Additionally, you can add the following files to your git-repositories to change the behaviour of the "git pull"  

### .pull_submodules
To use `git pull --recurse-submodules` instead of simple `git pull`

### .submodule_update_recursive
To use `git submodule update --recursive --remote` instead of simple `git pull`

# Example: Updating root-owned directories from user shell
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
  
# Avoid annoying stuff:

## untracked files: 
The ".gitignore" file is your friend!

## Authentication: 
Switch to ssh-key based auth to avoid annoying "please enter your account/pw" messages 
