---
title: "A fatal communication error with WAS"
date: 2019-07-29
draft: true
tags: ["IIS"]
categories: ["bug on face"]
---

参与维护的一个有十几年的老项目，前几年用WCF重写了一遍（就不要吐槽为什么都201X年了还有人用这玩意重构业务，企业级的事，能说古老吗），做成了CS架构（都201X年了居然还有人在提这个词），称为2.0版本，服务端host在IIS上

之前这系统就有各种各样的小毛病，也是因为不够稳定所以这套东西在上线一年之后就停止在各个全公司的推广了，当时带领开发的leader也被干掉。但是由于新的替代系统迟迟没有上线，已经上线的多个版本就继续维护，公司内形成1.0继续使用，2.0版本也同时使用和维护，3.0版本锐意开发的尴尬局面，我所在的组就一边开发新系统，一边维护旧系统

在维护2.0版本的时候，发现其中一组实例时不时会被IIS直接关闭，一番调查之后，发现是IIS failover机制导致的：[Rapid-Fail Protection](https://stackoverflow.com/questions/11010807/application-pool-defaultapppool-is-being-automatically-disabled-due-to-a-serie)，当短时间内频繁发生比较严重的错误和警告时（默认时5分钟内5次），IIS会直接关闭应用程序池以保护应用和自身。

当然，最快的解决方案就是直接把这个Protection关闭

确实我们也是这么做的，毕竟这问题都好几年了也没能解决，曾经也找了微软技术专家过来，几千块钱一天也没搞定，后来慢慢就没人关心了，反正出问题就把出问题那台服务器的Protection一关，大家就安心过日子，大不了重启一下解决问题

正好那天我看到了处理这个问题的往来邮件，问了一句：有没有人用WinDBG看过？得到的答案是在座没有，原来只有一个人处理过这个问题，但是已经去了别的组，由于之前请过微软技术专家没解决，于是从此以后再也没人接手这个摊子

于是我就接了过来，先去找实施看了下线上报错信息，IIS里面完全看不到任何报错信息，Event Viewer里只有连续的5个warning，message里非常简单一句话：

>  A process serving application pool  suffered a fatal communication error with the Windows Process Activation Service

其他啥都没有了。于是把这句话扔到谷歌里去看了看，找到了这个链接[Rapid-Fail Protection](https://stackoverflow.com/questions/11010807/application-pool-defaultapppool-is-being-automatically-disabled-due-to-a-serie)，确定自己没有找错方向，至少问题触发点找到了

但是根据那个StackOverflow下的答案去做并不解决问题，因为线上已经是答案所说的配置了。此外还有[类似的一个问题](https://stackoverflow.com/questions/7204444/iis7-a-process-serving-application-pool-yyyyy-suffered-a-fatal-communication)里面的回答我也都一一尝试过，并没有好用的解决方案，答案不在此处

万事休矣，那就上WinDBG呗。写了两天邮件，外加自己在运维那儿站了一个小时和在线上抓数据差点被用户投诉，终于拿到了出问题的服务器上的日志，日志抓取方法参见[IIS Application Pool Crash and Debug Diag](https://blogs.msdn.microsoft.com/parvez/2016/08/06/iis-application-pool-crash-and-debug-diag/)

拿到日志之后开始分析，发现IIS从启动时就报了一个错，再往后就就没了，1个G的日志里就这一个错，错误信息里说

> In w3wp__wcfhandler____First chance exception 0XE06D7363.dmp the assembly instruction at KERNELBASE!RaiseException+39 in C:\Windows\System32\KERNELBASE.dll from Microsoft Corporation has caused an unknown exception on thread xx

我只知道可能是内核报错了，但是真要让我debug我也不会，再搜一次，居然有人跟我遇到一样的问题：[Need help: KernelBase.dll crashes](https://social.msdn.microsoft.com/Forums/vstudio/en-US/d02d1074-47c1-4df6-9264-03d306039b92/need-help-kernelbasedll-crashes?forum=wcf)，其中最关键的一句是：

> Alright I think we have found the problem. Looking over the developer code I noticed that a referenced project was a version running under .NET 3.5 while the WCF service itself was 4.0. The referenced project is datatypes for the service request and response. These data types are serialized using XmlSerializer. While the reference to a .NET 3.5 project indeed was an error it did not produce any errors or warnings during build process.

大意是
