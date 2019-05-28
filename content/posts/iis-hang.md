---
title: "IIS 应用程序池中断排查"
date: 2019-05-15
draft: true
tags: ["dotnet framework", "IIS"]
categories: ["bug on face"]
---

## BG

也是工作里遇到的一个问题，一个host在IIS上的古老项目（最早可以追溯到16年前），时不时会报下面这个错误：

> 应用程序池“.NET”提供服务的进程在与 Windows Process Activation Service 通信时出现严重错误

IIS的应用程序池有一个故障自动保护机制，在应用程序池出现几次错误之后，会自动将应用程序池关闭，需要手动重启。服务器上的默认设置是5分钟5次，也就是说，如果在服务器上5分钟内出现了5次上述异常，IIS将自动关闭该站点的应用程序池，届时所有业务中断

这个故障的发生频率也不算高，一两个月出现一次中断，但是每次中断之后都需要有人手动登陆到服务器上解决，这一点非常麻烦。对客户也极端不友好，客户的反映是每隔一段时间就要出问题，到底靠不靠谱

一个非常非常临时的解决方案是，关掉自动保护机制，报错就报错，别挂应用程序池。这当然也是一个解决方案，只不过粗糙了一点
## Log

接到这个问题时我的第一反应是：日志呢日志呢日志呢，看看日志不就知道了。但是拿到服务器上的所有IIS日志、应用程序日志和系统日志之后就傻了，应用程序日志干干净净什么都没有，IIS日志也干干净净什么都没有，连报错都没有，只有系统日志里出现了上面的报错信息

问题还是得解决啊，于是写邮件申请dump线上堆栈信息，将[Debug Diagnostic Tool](https://www.microsoft.com/en-us/download/details.aspx?id=58210)安装到服务器，根据教程[IIS Application Pool Crash and Debug Diag](https://blogs.msdn.microsoft.com/parvez/2016/08/06/iis-application-pool-crash-and-debug-diag/)设置好就可以开始dump了。dump文件通常都比较大，会导致两个问题，一是将堆栈信息写入文件时