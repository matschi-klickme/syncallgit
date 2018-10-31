#!/bin/bash

#check for configfile
if [ -f ~/.config/git_dirs ]
then
LOOK_DIRS=$( while read line; do echo  $line ;done  <  ~/.config/git_dirs )
else
LOOK_DIRS=${1:-$PWD}
fi

#check ob Ordner GIT Repo

for ELEMENT in $LOOK_DIRS
do
 echo "Checking folder:" $ELEMENT
 for FOLDER in $(find $ELEMENT -maxdepth 1 -type d ); do
  if [ -d $FOLDER/.git ]; then
   echo "Git folder found in:" $FOLDER
   ( cd $FOLDER; git pull; if [ !  $(git diff-index --quiet HEAD --) ]; then git commit -a; git push; fi  )
  fi
 done
done
