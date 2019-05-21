#!/bin/bash

echo -e "\033[0;32mCommit updates to GitHub...\033[0m"

# src/gen 

echo -e "\033[0;32mCommit src/gen...\033[0m"
cd src/gen
git checkout master
git add -A

msg="commit gen at `date +%FT%H:%M:%S`"
if [ $# -eq 1 ]
  then msg="$1"
fi

git commit -m "$msg"
git pull origin master -r
git push origin master

# Come Back up to the Project Root
echo -e "\033[0;32mCommit root...\033[0m"
cd ../..

git add -A

msg="commit blog at `date +%FT%H:%M:%S`"
git commit -m "$msg"

git pull origin master -r
git push origin master

echo -e "\033[0;32mDone!\033[0m"