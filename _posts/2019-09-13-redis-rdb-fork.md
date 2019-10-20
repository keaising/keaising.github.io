---
title: "Redis 复制时的 fork 的子进程"
date: 2019-09-13
layout: post
tags: ["redis"]
categories: ["interview question"]
---

## 背景

+ 问：Redis 主从节点同步知道吗？

+ 答：知道一点，不太熟

+ 问：从节点申请同步的时候主节点做了什么？

+ 答：fork 一个子线程做同步

+ 问：是子进程，为什么 fork 出来的子进程能读到父进程的数据？

+ （胡乱答了一堆容器里的同一个 namespace 下资源共享的内容。。。因为没看过操作系统的内容）

## 学习的结果

回来之后在多抓鱼上买了3本操作系统的书，粗略得过了一遍，至少现在不会把进程（process）和线程（thread）搞混了。

至于 Redis 主从同步，完整的过程可以在 [Redis 使用手册](http://redisguide.com/replication.html#id8) 的数据同步一节读到，分为完整同步、在线更新和部分同步 3 类，完整同步就是面试时被问到的主从同步主节点做了什么。主节点做了如下这些事（摘自《Redis 使用手册》）：

1. 主服务器执行 BGSAVE 命令， 生成一个 RDB 文件， 并使用缓冲区储存起在 BGSAVE 命令之后执行的所有写命令。
2. 在 RDB 文件创建完毕之后，主服务器会通过socket，将 RDB 文件传送给从服务器。
3. 从服务器在接收完主服务器传送过来的 RDB 文件之后，就会载入这个 RDB 文件，从而获得主服务器在执行 BGSAVE 命令时的所有数据。
4. 当从服务器完成 RDB 文件载入操作， 并开始上线接受命令请求时，主服务器就会把之前储存在缓存区里面的所有写命令发送给从服务器执行。

BGSAVE 跟 SAVE 的不同之处就在于，BGSAVE 会先 fork 一个子进程，由子进程来生成 RDB文件，而不是由父进程生成 RDB 文件，因为生成 RDB 文件时进程是没有办法响应新进入的请求的

那为什么 fork 出来的子进程又能访问到父进程的资源呢？具体到这个语境下，为什么子进程能访问到父进程的内存？

[《现代操作系统》](https://book.douban.com/subject/3852290/) 里讲到，（对 UNIX 而言）fork 操作后，父进程和子进程拥有相同的存储映像、环境字符串和同样的打开文件，子进程的初始地址空间是父进程的一个副本，不可写的内存区是共享的。

书里没有更细地讲内存，接着查资料，对内存，早期 UNIX 是直接完整复制一份父进程的内存给子进程，但是明显效率太低而且造成浪费，所以 Linux 采用了 [Copy-on-write](https://en.wikipedia.org/wiki/Copy-on-write) 技术来处理这个问题，简单得讲就是刚 fork 出来，父子进程各自持有自己的虚拟空间，但是对应的物理空间是同一个，此时把内存页的权限设置为 read-only，当两个进程中的某一个尝试写操作时，触发 page-fault，触发 kernel 中断，kernel 把触发异常的页复制一份，父子进程各自持有独立的一份页，各自读写

至此，答案找到，其实就是 fork 出来的子进程能完整读到父进程的内存，如果父进程后续有修改的话，修改前 kernel 会复制一份给子进程，这样子进程能读到 fork 时的内存页，继续进行生成 RDB 的过程

至于生成 RDB 过程中如果又有新的操作导致父进程内存中数据变化，那就是数据同步第 4 步中主服务器把缓存的变化数据传给从服务器来解决了


### 参考文献

+ [Redis 使用手册 - 复制 - 数据同步](http://redisguide.com/replication.html#id8)
+ [Wikipedia: Copy-on-write](https://en.wikipedia.org/wiki/Copy-on-write)
+ [COW奶牛！Copy On Write机制了解一下](https://juejin.im/post/5bd96bcaf265da396b72f855)