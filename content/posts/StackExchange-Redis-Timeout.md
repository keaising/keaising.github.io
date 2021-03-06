---
title: "处理dotnet core Redis超时异常"
date: 2019-04-29
tags: ["redis", "dotnet core"]
categories: ["bugs"]
---

压力测试过程中遇到的一个问题，框架是asp.net core 2.2，redis组件是[StackExchange.Redis 2.0.601](https://stackexchange.github.io/StackExchange.Redis/)，在高并发场景下会报错，报错信息：

![log](/images/redis-timeout/log.png)

## 搜索 & 分析

#### 排查服务端

一开始没仔细看log，以为是Redis服务器报错，经过单独压测服务器发现完全没有问题

#### 排查客户端

再回来仔细分析log，StackExchange.Redis提示了一个链接 [StackExchange.Redis/Timeouts](https://stackexchange.github.io/StackExchange.Redis/Timeouts)，该页面列举了常见的超时错误的几种情况：

+ 网络 / CPU 带宽瓶颈
+ 运行时间较长的Redis指令（可以通过SlowLog指令在redis服务器上查看
+ 大请求挡在多个小请求之前，大请求超时导致后续请求全部被阻塞，所有请求都超时了
+ 线程中busyIO和busyworker导致的超时（.Net平台线程实现机制相关）

#### log提供的信息

粗略一看也很难看出问题在哪儿，可能出问题的点很多，搜索过GitHub、Stackoverflow类似的问题之后有了两点总结：

1. 使用StackExchange.Redis出现超时的问题挺多，为此StackExchange.Redis重构了一版推出了2.0版本，此次我们使用的已经是2.0版本，所以很多以前针对1.0版本的处理方法不再有效，只有报错信息可供参考。
2. 结合GitHub、Stackoverflow的资料，分析我们的报错日志（图二）可以知道：
    + sq：202表明有202个请求（request）被因为超时被阻塞，
    + in：1010表明有1010 bytes数据没有被StackExchange.Redis及时处理，还在内核缓冲区等到被处理，
    + mgr: 10 of 10 available，表明 StackExchange.Redis内部线程池的10个线程都处于空闲状态
    + IOCP: (Busy=0,Free=1000,Min=8,Max=1000), IOCP空闲
    + WORKER: (Busy=77,Free=32690,Min=8,Max=32767)，WORKER很忙

## 整理资料

#### IOCP & WORKER

简单来说，IOCP（I/O Completion Port）线程是dotnet框架为了协调超快的CPU处理速度和相对来说非常慢的网络、硬盘IO而搞出来的线程使用方式，广泛用于各种网络IO、磁盘IO和文件IO。

推荐阅读：

1. [MSDN: I/O Completion Ports IOCP基本定义和基本用法](https://docs.microsoft.com/en-us/windows/desktop/fileio/i-o-completion-ports)
2. [wiki: Input/output completion port IOCP概述](https://en.wikipedia.org/wiki/Input/output_completion_port)
3. [I/O completion port's advantages and disadvantages IOCP的优缺点](https://stackoverflow.com/questions/5283032/i-o-completion-ports-advantages-and-disadvantages)

相对应的，WORKER线程是在你使用了`Task.Run(…)`或者`ThreadPool.QueueUserWorkItem(…)`之后用于处理并发线程而产生的，他们也大量被用于CLR中其他有多线程和后台运行需求的地方。

推荐阅读：

1. [ThreadPool Growth: Some Important Details](https://gist.github.com/JonCole/e65411214030f0d823cb) **这篇必读！！！**
2. [How to troubleshoot Azure Cache for Redis](https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-how-to-troubleshoot#burst-of-traffic) **这篇有案例分析**

#### 结合log分析

对我们的应用来说，总共有3个线程池， 

1. StackExchange.Redis自带的线程池mgr：(10 / 10)
2. IOCP: (Busy=0,Free=1000,Min=8,Max=1000)
3. WORKER: (Busy=77,Free=32690,Min=8,Max=32767)

在我们的应用服务器上的情况是，有一个8核CPU，线程池最小情况下有8个线程，StackExchange.Redis空闲，IO也毫无压力，但是worker线程比较忙，在并发数高的情况下由于默认的最小线程池中的8个线程不够用，框架又给应用产生了69个线程，线程池中总共有77线程

dotnet生成新线程的规则是，当有新任务需要线程时，先在线程池中找空闲线程，如果没有空闲的，等待500ms看是否有线程空闲出来，如果还是没有，产生一个新线程

我们的Redis超时设置为5000ms，只需要有10个任务没有及时处理，就超时报错了

由于应用中大量使用了`async/await`导致应用对worker线程的需求非常大，并发数较低时线程池自己的调度可以及时处理，所以不会出问题，压测时并发数突然升高，线程池来不及调度，导致Redis的request/response来不及处理，触发5000ms超时报错抛异常

## 处理方法

根据[Recommendation](https://gist.github.com/JonCole/e65411214030f0d823cb#recommendation) 的建议，调整配置文件中最小线程数到100，然后测试、调整、再测试、再调整循环，找到一个适合应用的大小。

注意：

1. 这里调整的是worker线程，会被整个应用程序共享，并不只是被redis使用
2. 线程数也不能调整得特别大，线程切换是有代价的，过大会得不偿失

实际测试显示，调整到50就能顺利通过300并发的压力测试，日常应用在100-200之间

## 猜想

StackExchange.Redis也维护了一个线程池用于处理并发读写Redis的问题，但是可以看到完全是空闲状态，猜想是因为应用程序的线程池太忙了所以根本没机会用上，我猜想或许我们可以把应用程序完全改成同步的，让StackExchange.Redis的线程池去做redis的调度，可能能够解决一些莫名其妙的并发问题，线程太多之后切换线程上下文的消耗也可能会高到不可忽视。但是项目代码已经好几万行，基本上全是异步`async/await`代码，修改起来代价太大，只能以后有空了自己用一个小项目测试了