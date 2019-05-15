---
title: "CLI in C# 其三"
date: 2019-05-14
draft: false
tags: ["CSharp", "dotnet core"]
categories: ["programming"]
series: ["CLI in C#"]
---

.Net Core控制台应用的打包方法主要是两类：

+ nuget包，对应dotnet core global tool的部署方法
+ 可执行文件，对应直接运行，Windows平台体现为exe文件

## nuget包

nuget包的打包子命令是pack，本地打包和调试常用的是以下几条命令

```powershell
//打包
dotnet pack --output ./.nupkg

//从本地源安装到本地全局工具
dotnet tool install -g gen --add-source ./.nupkg

//从本地源更新本地全局工具
dotnet tool update -g gen --add-source ./.nupkg

//卸载
dotnet tool uninstall -g gen 
```

命令比较简单，且在dotnet core官网都有文档说明，此处不再赘述。需要说明的是，通过`dotnet pack`打包之后，`./.nupkg`目录下会生成`.nuget`文件，该文件的名称跟项目配置相关，可以通过直接修改项目配置进行修改。此外，生成的nuget包可以通过上传到[nuget.org](https://www.nuget.org/)的方式让其他人安装该全局工具，[nuget.org](https://www.nuget.org/)生成的默认安装指令为

``` powershell
dotnet tool install --global gen --version 1.0.0
``` 

可以看出，nuget包安装dotnet core global tool的工具相对来说比较简单，而且在打包的时候也比较简单，不用考虑跨平台的问题，dotnet core SDK会自动处理好。

但是，也正是因为依赖了dotnet core SDK，在没有安装dotnet core SDK的机器上运行dotnet core gloabl tool就会比较麻烦，所以有的场景下会希望打包成可以独立运行的可执行文件，直接在Windows/Linux/macOS上运行，下面进行介绍

## 打包可执行文件

> 接下来要介绍的方法完全兼容Windows/Linux/macOS三大主流平台，所以只是简单以Windows为例进行演示，其他平台只需要修改编译和打包参数即可，在任何平台打包和编译都是可以的

此处的目标是在当前环境下打包一个可以在64位Windows10环境下执行的exe文件，希望能不依赖dotnet core SDK，所以加上自包含的特性，并且去掉debug信息，指定打包类型为`Release`，使用的打包脚本如下：

```powershell
dotnet publish -r win10-x64 --self-contained true -c Release
```
执行以上命令后，可以在`./bin/Release/netcoreapp2.1/win10-64/publish`目录下找到生成的所有exe和dll文件，此时可以直接运行exe文件使用演示应用

但是这样传输、部署和使用都不太方便，经常会有打包成一个单文件exe的需求，这个需求可以借助[warp-packer](https://github.com/dgiagio/warp)解决

warp-paker是一个在命令行下将可执行文件打包成一个单文件的工具，支持三大平台的部分编译方式。安装非常简单，在Windows平台直接下载exe文件放到一个被环境变量`PATH`包含了的目录下就可以全局使用了，如果不需要全局使用，直接放在当前目录运行就行

此处我们要用warp-packer打包一个64位Windows架构、源目录在`./bin/Release/netcoreapp2.1/win10-64/publish`、输出结果叫`gen-packed.exe`的单文件exe，命令如下：




