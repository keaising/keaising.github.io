#!/bin/bash

echo -e "\033[0;32mCommit updates to GitHub...\033[0m"

# Go To src/gen folder
cd src/gen

git checkout origin master

# Add changes to git.
git add .

# Commit changes.
msg="commit gen at `date +%F`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ../..

git add .

msg="commit site at `date +%F`"
git commit -m "$msg"

git push origin master

echo -e "\033[0;32mDone!\033[0m"