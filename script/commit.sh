#!/bin/bash

echo -e "\033[0;32mCommit updates to GitHub...\033[0m"

git add -A

msg="commit source at `date +%FT%H:%M:%S`"
if [ $# -eq 1 ]
  then msg="$1"
fi

git commit -m "$msg"
git pull origin source -r
git push origin source

# Come Back up to the Project Root
echo -e "\033[0;32mCommit keaising/kitto...\033[0m"
cd ../themes/kitto

git add -A

msg="commit kitto at `date +%FT%H:%M:%S`"
git commit -m "$msg"
git pull origin master -r
git push origin master

echo -e "\033[0;32mDone!\033[0m"
