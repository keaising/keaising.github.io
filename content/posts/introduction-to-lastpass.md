---
title: "LastPass 基本用法"
date: 2020-03-07
draft: false
categories: ["introduction"]
---

## 简介

本文目标读者是刚接触密码管理软件的用户，同时也坐在了我开的家庭计划的车上的乘客

本文目标是让你们能上手用起来这款软件，尽量平滑得从以前的密码管理迁移到LastPass

### 1. 为什么要用密码管理软件

+ 如果所有网站的用户名和密码全用同一个，一旦有网站泄漏了密码就很危险
+ 如果每个网站都不同密码多了记不住，登录一些不常用的网站需要反复尝试和重置密码
+ 重置密码到最后一步「输入新密码」时还会被提示：「不能与用过的密码相同」
+ 信用卡号、安全码、支付密码记不住，每次都需要翻记事本，泄漏了也很危险

### 2. 市面上有哪些密码管理工具

+ 1Password
+ LastPass
+ EnPass
+ KeePass
+ ...

Q：为什么要选LastPass？

A：原因如下：
+ 所有常见平台都支持，在浏览器上的体验类似于Chrome浏览器，足够简单好用
+ 价格适中，满足我对一个密码管理软件的期待

## 入门

### 0. 注册和安装

通过我发的邀请链接注册用户，注册时会让你输出主密码(Master Password)，以后就用这个密码作为其他所有密码的大门钥匙了，请务必使用一个没有使用过且强度足够高的密码

如果不是我车上乘客的话，直接去LastPass官网注册即可

注册好之后就可以安装应用和Chrome扩展了，下载页面：[https://lastpass.com/misc_download2.php](https://lastpass.com/misc_download2.php)

一般来说安装LastPass的手机App和Chrome扩展就足够使用，如果还有其他管理需求，可以安装一个PC或者Mac应用

### 1. 设置两步验证

#### 什么是两步验证？

两步验证是一个安全机制，比如使用银行App转账时，一般在输入支付密码后，银行会给你的预留手机号发送一条验证码短信，正确输入验证码短信后才能顺利转账，这就可以认为是一个基于短信的两步验证。而在LastPass里，虽然也有紧急救援使用的预留手机号，但主要还是使用邮件和两步验证App来实现这一过程

#### 使用邮件验证

一个新账户注册好了之后默认就是使用邮件认证的，此时你如果尝试在手机App或者Chrome扩展上登录你的LastPass账户，LastPass会提示你登录失败，这是一个未经认证的新登录方式，请去邮件里确认是否要在新登录点登录账户。然后你需要打开邮箱，点击确认链接里的确认按钮，等待链接跳转成功后，重新在LastPass App或者Chrome扩展里登录

略微有点麻烦对吧？

相比之下，是不是手机验证码要稍微简单点：打开短信App，看一下验证码，输入并通过

所以我一般使用两步验证App来实现类似于手机验证码的效果

#### 使用两步验证App

支持两步验证的App主要有：

1. Gooole Authenticator [iOS](https://apps.apple.com/us/app/google-authenticator/id388497605) [Android](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en)
2. Microsoft Authenticator [iOS](https://apps.apple.com/us/app/microsoft-authenticator/id983156458) [Android](https://play.google.com/store/apps/details?id=com.azure.authenticator&hl=en)
3. LastPass Authenticator [iOS](https://apps.apple.com/us/app/lastpass-authenticator/id1079110004) [Android](https://play.google.com/store/apps/details?id=com.lastpass.authenticator&hl=en)

这3个里面随便选一个就好，功能都是一样的，不过我推荐使用Gooole Authenticator或者Microsoft Authenticator，下面以Gooole Authenticator为例

接下来开始设置

1. 在网页、PC App、Mac App上登录，如果提示需要邮件验证就去验证吧
2. 进入Account Settings -> Multifactor Authentication
3. 在Gooole Authenticator那一行的Action列中，点击铅笔图标进行设置
4. 在新弹出的页面中，将Enbale从No改为Yes，并点击BarCode后面的View，查看二维码
5. 在手机上打开Gooole Authenticator App，点击右上角的+，选择Scan barcode，扫描LastPass页面上的二维码
6. 设置完成，Gooole Authenticator App上会增加一个title是LastPass，备注是你的邮箱的6位数字，那就是你的验证码
7. 验证码每分钟自动更新一次

设置完成后，尝试在新的地方登录你的LastPass账户，就会要求你输入两步验证的验证码了，此时只需要打开Gooole Authenticator，输入验证码就可以了

### 2. 从Chrome中导入密码到LastPass

1. 我之前的密码都是存在Chrome中的，所以先从Chrome中导出：进入Chrome设置 -> 密码 -> 保存的密码 -> 右侧有个「导出」按钮，导出成csv
2. 导入流程在各端略有不同
3. 导入：Mac App上是在More Options -> Advanced -> Import，类型选Generic CSV File，然后点Import就可以选择chrome的密码文件了
4. 导入：Chrome扩展上是在Account Option -> Advanced -> Import，会弹出一个新页面，Source选择Generic CSV File，使用文本编辑器打开csv文件，比如vs code、记事本、TextEdit.app，全选并复制粘贴到Content里，等待LastPass处理重复的完毕后，点击Upload

无论采用何种导入方式都可以，LastPass会有一个自动去重的功能，效果一般，导入完成后，就可以在你的LastPass页面看到所有的密码了

如果刷新不及时的话，可以采用强制刷新Account Option -> Advanced -> Refresh Sites

### 3. 使用LastPass存储其他加密信息

LastPass除了保存密码以外，也可以保存其他加密文本、你的护照信息、银行卡/信用卡信息，这些都是在App里有单独分类的，可以尽情探索

此外，当你需要使用的时候，直接在App首页或者扩展的最顶部搜索，弹出的内容点击即可复制，非常方便

在Chrome中使用扩展的话，输入用户名和密码时，输入框最右侧会有个LastPass logo，点击之后可以选择该站点的用户名和密码并输入


## 番外
### 0. 不可能找回主密码

万一真把主密码忘了是没办法通过邮件找回的，邮件只会告诉你当初设置的密码提示是什么

那么紧急救援手机号就能了吗？也不能

**主密码丢失就只能直接转世**

手机号是给万一你的邮箱丢失了准备了，所以方便的话尽量还是设置一个吧

Mac App/PC App -> Account Settings -> General -> SMS Account Recovery

### 1. 多站点使用同一密码

主要用于公司内没有做单点登录，多个内部网站都需要用公司的邮箱密码登录，但是网站之间却不互通，每次改密码后都需要挨个修改不同站点的密码，此时就可以使用多站点同一密码功能了: Mac App/PC App -> Account Settings -> Equivalent Domains，将需要使用同一密码的站点都加到同一个条目里，域名用逗号分隔开即可

### 2. 不同二级域名使用不同密码

在SaaS公司经常能遇到另一种情况，公司在一个域名下做了多个子站点，比如dev.baidu.com, test.baidu.com, prod.baidu.com，分别对应于开发环境、测试环境和线上环境

但是你在3个环境的帐号密码不同，而默认情况下LastPass只认一级域名baidu.com，只要一级域名一样就认为是同一个站点，所以每次登录这3个环境的时候都会给你把3个环境的域名都弹出来让你选择

此时就可以告诉LastPass，这3个二级域名是不同的，不要混着用

功能是Mac App/PC App -> Account Settings -> URL Rules，点击Add新增一个条目，在Domain or Host填写你的二级域名即可

这个功能的原理是完全匹配URL，所以如果你的情况是端口不同的话，也可以添加到Port里，如果是路径不同，比如a.baidu.com/function1和a.baidu.com/function2，那么你需要把function1和function2添加到Path里，让LastPass做完全匹配