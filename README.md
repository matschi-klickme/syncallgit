# syncallgit
Never forget to pull/push/commit again. The perfect start into your day!
Simple script to sync (pull, commit, push )  git repos.

If "~/.config/git_dirs" file exists,it will be used. Otherwise $PWD folder. 

## git_dirs file: 
One file containing path to one folder containing git repos per line pls.
Suggestion: put in the loction of the "syncallgit" -file first

## Avoid annoying stuff: 

@untracked files: The ".gitignore" file is your friend!

@github: Switch to ssh-based pull/push and ssh-key auth to avoid annoying "please enter your account/pw" 

@using script as root over localhost ssh 

 * create folder /git_root. In that folder:
     * git clone https://github.com/matschi-klickme/syncallgit.git
        * {{{ echo "/git_root" >> /root/.config/git_dirs }}}
        * clone additional repos
        * symlink relevant files to desired locations
 * auto pull/push of all git folders in /git/root as from a regular user shell via {{{ ssh -A root@localhost /git_root/syncallgit.sh  }}}
    * ssh stuff needs to be setup
    * you probably need to set your root's git editor: git config --global core.editor "EDITOR"   (replace with desired editor, eg "vim", "nano", etc )
