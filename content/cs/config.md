---
title: Configuration
date: 2014-01-01
layout: post
no: 0
---

## Shell

### export

``` bash
export GO111MODULE=on
export GOPROXY='https://goproxy.io'
```

### alias

``` bash
alias ll='ls -al'

alias goproxy='export http_proxy=http://127.0.0.1:7777 https_proxy=http://127.0.0.1:7777'
alias disproxy='unset http_proxy https_proxy'
```

## .gitconfig

``` conf
[user]
	name = keaising
	email = keaising@gmail.com
[core]
	editor = vi
[color]
	ui = true
[alias]
	co = checkout
	st = status
	br = branch
	ci = commit -m 
	cod = checkout develop
	cor = checkout release
	com = checkout master
	pushm = push origin master
	pullm = pull -r origin master
    pulld = pull -r origin develop
	pushd = push origin develop
	pullr = pull -r origin release
	pushr = push origin release
	unstage = reset HEAD--
	last = log-1 HEAD
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

[pull]
	rebase = true
```

## ssh key

### create ssh key

``` bash
# generating key
ssh-keygen -t rsa -b 4096 -C "email@yours.com"

# start the ssh-agent in the background
eval $(ssh-agent -s)

# add to agent
ssh-add ~/.ssh/id_rsa
```

### permanently add ssh key

来源：[是否必须每次添加ssh-add](https://segmentfault.com/q/1010000000835302)

``` bash
vi ~/.ssh/config

# 1. 永久添加 public key 到本地 ssh agent
IdentityFile ~/.ssh/id_rsa

# 2. 根据不同 host 进行配置
Host github.com
    User keaising
    IdentityFile ~/.ssh/githubKey
    PreferredAuthentications publickey

# 3. 每次登录 shell 时自动添加 (Not recommend)
ssh-add ~/.ssh/id_rsa &>/dev/null

# 如果没有权限
chmod 600 ~/.ssh/config
```

## Systemd Service

### cow.service

``` bash
# sudo vi /usr/lib/systemd/system/cow.service
# sudo systemctl daemon-reload
# sudo systemctl start cow
# sudo systemctl enable cow

[Unit]
Description=cow
After=network.target

[Service]
Type=simple
# Warning: cow文件不可以在/home/account目录下，会导致没有权限运行的问题
ExecStart=/usr/local/bin/cow -rc=/home/user/.cow/rc

[Install]
WantedBy=multi-user.target
```
