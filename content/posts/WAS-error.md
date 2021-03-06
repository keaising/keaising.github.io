---
title: "A fatal communication error with WAS"
date: 2019-07-29
draft: false
tags: ["IIS"]
categories: ["bugs"]
---


## 背景情况

也是工作里遇到的一个问题，一个 host 在 IIS 上的古老项目（最早可以追溯到 16 年前），时不时会报下面这个错误：

> 应用程序池 “.NET” 提供服务的进程在与 Windows Process Activation Service 通信时出现严重错误

IIS 的应用程序池有一个故障自动保护机制，在应用程序池出现几次错误之后，会自动将应用程序池关闭，需要手动重启。服务器上的默认设置是 5 分钟 5 次，也就是说，如果在服务器上 5 分钟内出现了 5 次上述异常，IIS 将自动关闭该站点的应用程序池，届时所有业务中断

当然，最快的解决方案就是直接把这个 Protection 关闭

确实我们也是这么做的，毕竟这问题都好几年了也没能解决，曾经也找了微软技术专家过来，几千块钱一天也没搞定，后来慢慢就没人关心了，反正出问题就把出问题那台服务器的 Protection 一关，大家就安心过日子，大不了重启一下解决问题

正好那天我看到了处理这个问题的往来邮件，问了一句：有没有人用 WinDBG 看过？得到的答案是在座没有，原来只有一个人处理过这个问题，但是已经去了别的组，由于之前请过微软技术专家没解决，于是从此以后再也没人接手这个摊子

## 日志分析

接到这个问题时我的第一反应是：日志呢日志呢日志呢，看看日志不就知道了。但是拿到服务器上的所有 IIS 日志、应用程序日志和系统日志之后就傻了，应用程序日志干干净净什么都没有，IIS 日志也干干净净什么都没有，连报错都没有，只有系统日志里出现了上面的报错信息


于是我就接了过来，先去找实施看了下线上报错信息，IIS 里面完全看不到任何报错信息，Event Viewer 里只有连续的 5 个 warning，message 里非常简单一句话：

>  A process serving application pool  suffered a fatal communication error with the Windows Process Activation Service

其他啥都没有了。于是把这句话扔到谷歌里去看了看，找到了这个链接 [Rapid-Fail Protection](https://stackoverflow.com/questions/11010807/application-pool-defaultapppool-is-being-automatically-disabled-due-to-a-serie)，确定自己没有找错方向，至少问题触发点找到了

但是根据那个 StackOverflow 下的答案去做并不解决问题，因为线上已经是答案所说的配置了。此外还有[类似的一个问题](https://stackoverflow.com/questions/7204444/iis7-a-process-serving-application-pool-yyyyy-suffered-a-fatal-communication)里面的回答我也都一一尝试过，并没有好用的解决方案，答案不在此处

万事休矣，那就上 WinDBG 呗。写了两天邮件，外加自己在运维那儿站了一个小时和在线上抓数据差点被用户投诉，终于拿到了出问题的服务器上的日志，日志抓取方法参见 [IIS Application Pool Crash and Debug Diag](https://blogs.msdn.microsoft.com/parvez/2016/08/06/iis-application-pool-crash-and-debug-diag/)

拿到日志之后开始分析，发现 IIS 从启动时就报了一个错，再往后就就没了，1 个 G 的日志里就这一个错，错误信息里说

> In w3wp__wcfhandler____First chance exception 0XE06D7363.dmp the assembly instruction at KERNELBASE!RaiseException+39 in C:\Windows\System32\KERNELBASE.dll from Microsoft Corporation has caused an unknown exception on thread xx

我只知道可能是内核报错了，但是真要让我 debug 我也不会，再搜一次，居然有人跟我遇到一样的问题：[Need help: KernelBase.dll crashes](https://social.msdn.microsoft.com/Forums/vstudio/en-US/d02d1074-47c1-4df6-9264-03d306039b92/need-help-kernelbasedll-crashes?forum=wcf)，其中最关键的一句是：

> ... I noticed that a referenced project was a version running under .NET 3.5 while the WCF service itself was 4.0. The referenced project is datatypes for the service request and response. 

> ... it did not produce any errors or warnings during build process. 

> ... IIS was running .NET 4. Whenever the service calls for serialization of the data type assembly, the framework will create a serialization assembly ("Data.XmlSerializer.dll") - and this happens at runtime the first time a particular data type is requested...

>  ...When the framework tries to load the assembly it exits all contexts and crashes KernelBase.dll.

大意是他们依赖的一个项目是基于 .NET 3.5 的，但是 WCF 是基于 .NET 4.0 的，依赖的项目用 XmlSerializer 进行序列化，编译、部署的时候都不会报错，但是 IIS 会自动给不是同一版本 .NET Framework 的程序集自动生成一个对应版本的 .dll，重新生成和部署成同一个版本的问题就解决了

## 处理

可能的问题找到了，于是写了个 Powershell 脚本，把站点下的所有 dll 文件的 .NET Framework 版本跑了一遍，抓出了所有版本不同的 dll，然后找人逐一询问用途和是否能重新编译和部署

花了两天时间确定了 4 个嫌疑最大的 dll，在服务器上干掉之后确实能看到这类报错数量变少了

但是，由于不能重新打包（有的 dll 连代码都没了，要打包只能反编译出来重新打包）和重新部署（怕影响线上正常使用，每次都只会增量部署，删除每一个 dll 都要十足的理由），所以这个问题只是被缓解了，没办法根本性处理

总共耗时大半周，还是有一些成果的，至少现在不会触发 IIS 的宕机阈值了 _(:з」∠)_