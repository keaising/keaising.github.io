---
title: Script
layout: post
date: 2015-01-01
no: 1
---

## modify latest commit author

``` bash
git commit --amend --author="keaising <keaising@gmail.com>"
```

## batch-modify-git-committer.sh

``` bash
git filter-branch --env-filter '
OLD_EMAIL="old_email"
CORRECT_NAME="keaising"
CORRECT_EMAIL="keaising@gmail.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
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
```

## add key of keaising@gmail.com

``` bash
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEzQ42VEOqjtxbQ4LdArly5dDEz1tBMSaraCGuBfyGQRO5Yk6rivlbx4iIiuM0CsuAWZ/esRZKYl6hwOj3H/PanCrxOTW+mqowUHJIp9+c9FGc7ngneHytB05MaI9S49Iw51xYjRBHWrqvCGxDuggUWYHZNX5j5zy+FJxEUVZ8UQcX0lbKkJWCcMTyjkYHP4VAZygJA65TUW+rLGbA6Slh5dfZXlh7GxdjPG2WJxzJ+vcSPolDoNpoVKslTfLVgW+WFNMxE9AO6zF3K0+9k938PBp7iaDqachfyh6Wb3pz5beuBkAD9nBM0GiJD50d+SAUEpRs5DA79U0+8Jb1vkuH7ylIvXI+rcOwylfnVhUgFuPJS1bPxBrt0bKBqK2EwpFPxeKMylq8/9m+y4GE5/6uMMc0j6SYiN0f0qob1Wb5HgVl11gB9VI75L5NzuRfIiSWP5bJ9yTxjz4TL1lYGASV/WAk4KkmrpkE9HrEqVsJBxCacFZzE3rXAS11lotbEczPIgBNrRf/YN5ZQKDJne9KWBTkhzJ8ej8rlf1hm3EoKGESVByleW0elJDPAN2k+E3Bd10DL395ficJ2TXqlwxtLrp3s1xzj05Coo0tZQpnYfntqs3kPh3Lx9DNRS0JxUP4N8dGF3oSwA8d06VU9e2hG4LzQKZZ+dOief/jLUu9MQ== keaising@gmail.com' >> ~/.ssh/authorized_keys
```
