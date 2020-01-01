#!/bin/bash

git filter-branch --env-filter '
OLD_EMAIL="old_email"
CORRECT_NAME="keaising"
CORRECT_EMAIL="keaising@gmail.com"
if [ "$GIT_COMMITTER_EMAIL" = "$taiga.wang@curiositychina.com" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags