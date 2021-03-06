---
title: "Auto mouse keyboard"
date: 2020-12-13
draft: false
tags:
  - "to grace"
---

给兔子写了一个半自动化工具，让她可以自己编写流程的情况下，操作鼠标和键盘完成一系列任务。项目代码在 [https://github.com/keaising/auto-mouse-keyboard/](https://github.com/keaising/auto-mouse-keyboard/)

## 使用

1. 在 Release 页面下载得到 exe 文件，将下载文件随意放到一个目录下
2. 在同目录添加一个文本文件，名字是 amk.conf
3. 在资源管理器地址栏输入 powershell
4. 在弹出的新窗口中输入 .\auto-mouse-keyboard.exe 即可开始运行

## 配置文件 amk.conf 格式说明

配置文件中每行是一条指令，指令分为 3 类：注释、设置和流程

### 注释指令

开头第一个字符是 `#` 的都是注释，比如

```bash
# This is a comment
```

如果一行什么都不写，或者全都写空格，那就是空指令，什么都不会影响也不会有任何作用

### 设置指令

目前只有两个设置，设置每条命令执行的时间间隔(SHIM，单位毫秒)和设置当前显示器的分辨率缩放(SCALE)

下面设置中，第一行设置两条命令之间间隔 500 毫秒执行，第二行标示当前显示器的分辨率缩放了 150%

```bash
SHIM=500
SCALE=1.5
```

分辨率缩放主要是影响鼠标移动位置，在高分屏中会需要用到，当你发现鼠标移动的实际位置跟设定的位置不一致的时候需要检查，不设置的话默认是 1，没有缩放

### 流程指令

流程分为 5 类

- 鼠标移动
- 鼠标点击
- 键盘输入
- 键盘按键
- 暂停

**鼠标移动**

以一个分辨率为 1920\*1080 的屏幕为例，左上角坐标为(0,0)，右下角坐标为(1920,1080)

将鼠标移动到屏幕坐标 (300,200) 的位置

```bash
M=300,200
```

**鼠标点击**

在当前位置点击鼠标

第一行：左键单击，第二行：左键双击，第三行：右键单击，第四行：右键双击

```bash
C=left
C=left,double
C=right
C=right,double
```

**键盘输入**

在当前位置输入文本

```bash
I=23333
I=可以是中文，也可以是 I love Grace
I=%^*(&())(
I=可以包含各种特殊符号，也可以   有空格
```

**键盘按键**

可以是单个按键，也可以是组合键

单个按键包括 `a-z`、 `0-9`和以及普通的功能键

同时也可以使用组合键，比如耳熟能详的 `Ctrl+C`/ `Ctrl+V`

所有支持的按键列表见 [https://github.com/go-vgo/robotgo/blob/master/docs/keys.md](https://github.com/go-vgo/robotgo/blob/master/docs/keys.md)

```bash
T=1
T=cmd
T=esc
T=c,ctrl
T=v,ctrl
T=d,cmd
T=e,cmd
```

需要注意，使用组合键的时候，数字和字母需要放前面，功能键（比如 cmd/ctrl/shift）需要放后面，用逗号分隔开

下面只是列举常用的功能键

```bash
	"cmd"		is the "win" key for windows
	"alt"
	"ctrl"
	"shift"
	"capslock"
	"space"
	"backspace"
	"delete"
	"enter"
	"tab"
	"esc"
	"escape"
	"up"		Up arrow key
	"down"		Down arrow key
	"right"		Right arrow key
	"left"		Left arrow key
	"home"
	"end"
	"pageup"
	"pagedown"

	"f1"
	"f2"
	"f3"
	"f4"
	"f5"
	"f6"
	"f7"
	"f8"
	"f9"
	"f10"
	"f11"
	"f12"
```

**暂停**

手动控制两个操作之间的间隔，真正的间隔会变成 (SHIM+S)毫秒，暂停的单位是毫秒

比如配置里 `SHIM=400`，脚本如下

```conf
T=enter
S=300
I=wow
```

那么，摁下回车和输入 `wow`之间的真实间隔是 `SHIM+S+SHIM=400+300+400=1100 ms`

需要注意，使用组合键的时候，数字和字母需要放前面，功能键（比如 cmd/ctrl/shift）需要放后面，用逗号分隔开

**循环**

使一个片段反复执行 N 次，比如下列的语句

```conf
S=2000
C=left
I= begin

L=3
C=left
I=wow
T=enter*3
L

I= done
```

首先暂停 2000ms，左键点击一次，输入 `begin`，然后开始循环

在每次循环里，首先左键点击一次，输入 `wow`，然后摁 3 次回车

3 次循环结束后，输入 `done`

两个 L 必须成对出现，否则最后一个单个 L 到结尾的内容会全部循环

成对出现的 L 以第一个 L 的次数为执行次数，不写就是 0 次
