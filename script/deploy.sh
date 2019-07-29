#!/bin/bash

# bach to root
cd `dirname "$0"`
cd ..

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.

git checkout master
git add -A

# Commit changes.
msg="rebuilding site at `date +%FT%H:%M:%S`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.

echo -e "\033[0;32mpush repo keaising/keaising.github.io...\033[0m"

git push origin master

# Come Back up to the Project Root
cd ..

git add -A

msg="rebuilding site at `date +%FT%H:%M:%S`"
git commit -m "$msg"

echo -e "\033[0;32mpush repo keaising/blog ...\033[0m"
git pull origin master -r
git push origin master

echo -e "\033[0;32mDone!\033[0m"