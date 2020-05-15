---
title: 2000块搭建家庭网络——国际流量转发
layout: post
guid: 540985D1-E3CE-4564-A014-2BA008C5133C
date: 2020-05-16
tags:
  - family network
---

目前用得最多的科学上网方法都是在国外找一个服务器搭建特定隧道服务，国内的机器连接到该服务器，所有或者部分流量通过该隧道传输，达到科学上网的目的。从所访问的服务来看，好像就是从国外服务器访问的一样

这样就存在一个问题，如果你所在的地区访问国外这个搭建隧道的服务器的时候也出现了问题，那你同样难以获得流畅的上网体验，而国内有一大批用户有这个痛点，他们的共同特点是：移动宽带用户。因为移动的出口带宽很小，非常拥挤。这时候如果我们找一台有较大出口带宽且靠近骨干网的机器来中转一下我们的流量，那不就解决了我们访问国外服务器慢的问题了

这种中转服务器由于几乎不需要什么计算资源，只是单纯转发流量，所以找一台性能低下、但是带宽充足、能一直开机提供服务、有公网ip地址方便全国范围访问的服务器即可，现在的各种云服务器厂商都有这种机器卖，我选的是福报云的t5 1核500MB 的机器，一次性买4年只要不到500块，带宽100Mbps，使用弹性付费按量收费，0.8元/GB

在机器上做流量中转有多种方案，一是iptables forward，特别适合国外代理服务器由自己控制、有固定ip地址的场景，二是nginx、haproxy中转，nginx和haproxy都提供根据ip和域名进行流量转发的功能，nginx更偏向web 服务器，haproxy更简单且更偏向转发和路由，从设置便捷性和配置文件的简洁程度上说haproxy要简单些，于是我选择了haproxy

总结一下，接下来我们要实现的方案如下：在一台国内的Linux服务器上安装haproxy，利用haproxy的流量转发功能将我们的流量转发到国外的服务器上，haproxy不关心流量内容是什么，只单纯做转发出去和转发回来

举个例子的话，就是

1. 有一台提供Shadowsocks的国外服务器A，域名：a.ss.server，ip: 10.10.10.1，端口：8989
2. 买了一台做国内中转的国内某云服务器B，域名：b.forward.server, ip: 196.168.1.1，端口：5000
3. 之前是直接将本地的Shadowsocks客户端配置为指向 a.ss.server:8989
4. 搭建好从A到B的中转服务之后，本地的Shadowsocks客户端配置为指向 b.forward.server:5000


## 准备工作

### 购买和安装系统

服务器你爱买哪家买哪家，本文没有恰饭于任何供应商，也没有任何利益相关

操作系统推荐安装Ubuntu 18.04或者CentOS 7，有多好用谈不上，重点在于遇到奇奇怪怪问题的时候多半能搜到其他人的解决方案

后续操作系统限定的命令都以 Ubuntu 为准

### 登录服务器

购买好服务器之后我们通过ssh key登录上去，ssh key登录相对与通过服务器供应商网页上登录更加方便，相对于ssh密码登录更加安全且不需要记住密码，如果没有相关知识可以去[《SSH原理与运用（一）：远程登录》](https://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html)和[\<Connecting to GitHub with SSH\>](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)学习，此处认为你已经配置好自己本机的 ssh 和 `~/.ssh/config` 里的配置信息并能顺利登录到服务器了

### 编辑配置文件

登录到服务器之后是个纯文本的终端环境，编辑配置只能使用vim或者nano等文本编辑器，需要读者掌握基本用法，vim掌握[《简明 Vim 练级攻略》](https://coolshell.cn/articles/5426.html)这些内容即可

### 更换国内软件源

搜索：{你的操作系统版本}+更换国内源，有更换方法，可以大幅提升安装软件和更新的速度

比如清华源甚至主动提供了更换方法：[Ubuntu 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)，不过清华源默认注释了源码镜像以提高 apt update 速度，遇到问题可以删掉 `deb-src` 前面的 `#`

## 安装和配置

### 安装软件

```bash
# install vim
$ sudo apt install vim -y

# install haproxy
$ sudo apt install haproxy -y
```

### 配置

haproxy 配置非常简单，如果没有用过的话可以参考haproxy教程：[《HAProxy从零开始到掌握》](https://www.jianshu.com/p/c9f6d55288c0)

对这里的使用场景来说就是配置一个前端和一个后端，前端绑定特定端口接收流量，后端对应国外服务器转发出去，编辑haproxy配置：

```bash
$ sudo vim /etc/haproxy/haproxy.cfg
```

我使用的配置示例如下：

```cfg
# /etc/haproxy/haproxy.cfg

global
    ulimit-n  51200

defaults
    log     global
    mode    tcp
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
  
frontend ft-ss
    bind *:50000
    default_backend bd-ss

backend bd-ss
    server ${bd_name} ${ss.server.domain_or_ip}:${ss.server.port} maxconn 20480
```

+ `bind *:50000` 是绑定的中转服务器的端口，可以随便写你需要的端口
+ `${bd_name}` 是服务器名字，随便写个字符串就行
+ `${ss.server.name_or_ip}` 是提供代理的目的服务器，可以写ip，也可以写域名
+ `${ss.server.port}` 是代理服务器的端口

这里的前端和后端都可以定义多组，也可以自由对应，也就是说可以多个前端对应一个后端，玩法很多

如果你也用Ubuntu18.04以上的系统的话，在安装haproxy时haproxy的systemctl配置已经生成好了，可以直接运行：

```bash
$ sudo systemctl start haproxy
```

`systemctl`归属于`systemd`，是一个用于管理启动项和服务的服务，如果不了解的话可以阅读[《Systemd 入门教程：命令篇》](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)和官方文档入门，后面我们还会用到

启动后如果一切非常顺利，那么你把你的科学上网的服务器地址和端口改为国内服务器的地址和端口，你就可以正常上网了

## debug

事情往往都是不顺利的，尤其是当你刚开始探索的时候，似乎一切都在和你作对，所以我们讲一下可能遇到的问题

### 1. haproxy 相关

当你使用 `sudo systemctl start haproxy` 启动haproxy的时候可能会遇到报错，这时候根据启动提示你可以使用下面这个命令去查看 `systemctl` 的日志，日志里一般都有原因

```bash
$ sudo journalctl -xe
```

我经常遇到的问题是配置文件格式不对(写错内容、前后端名字不匹配之类的)、haproxy已经启动(请使用 `sudo systemctl restart haproxy`进行重启)之类的，稍微处理一下就好，一般错误都很明显

### 2. iptables

`iptables`功能复杂而强大，新手上路一般都不太搞得懂自己在干嘛，所以你完全可以暂时先把iptables卸载掉，反正一个破机器都还没有用起来，根本不怕被人搞，等之后熟悉了再慢慢把防火墙和过滤等功能加回来即可。当前卸载的主要目的是不要让iptables把自己的流量过滤掉了，卸载方法自行搜索

### 3. 供应商网关

比如福报云的机器前是有一个网络过滤的，在弹性网卡对应的网络安全组规则里，这里规定了开放哪些端口的访问，一定要在这里放开自己使用的端口和协议，比较极端是的全部放开，一般在排查问题的时候我会这么干，查完了一般还是用哪些开哪些。我把安全组规则当一个比较简单的防火墙在使用

经过简单的配置和测试，应该就可以享受到正常高速的网络服务了
