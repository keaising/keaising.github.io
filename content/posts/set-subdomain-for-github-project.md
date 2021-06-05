---
title: 为非个人项目的 GitHub repo 设置子域名
layout: post
date: 2021-06-05
tags:
  - GitHub Pages
---

最近在把以前的博客找回来

我从第一版博客开始，就一直在用基于 GitHub Pages和markdown的方案，最初用的静态生成器是Jekyll，但是Ruby在Windows的上体验一直都难以言表，在Ubuntu上想把我的那个Jekyll主题跑起来也常常遇到问题，后来我转移到了Hugo，很符合我作为一个文学创作者的身份

不过这也导致在多次迁移过程中我的博客被拆分成了几块，每块都是一个 GitHub repo，每个 repo 都有自己的一个二级域名，比如我现在放在表世界的博客是 [shuxiao.wang](https://shuxiao.wang)，它对应的 repo 是 [keaising.github.io](https://github.com/keaising/keaising.github.io)。实际上我还有几个博客，暂时把他们成为 A/B/C，他们各自在不同的 repo 里，也有各自的域名，各自的域名分别是 A.shuxiao.wang、B.shuixao.wang和C.shuxiao.wang

之前都相安无事，因为除了主域名 [shuxiao.wang](https://shuxiao.wang) 以外，其他域名都是 http 的，最近重拾了要把他们找回来的想法，第一步当然是给他们加上 https

但是在 GitHub Pages 里设置的时候遇到了不小的麻烦

按照 GitHub Pages 的官方教程，每个人或者每个组织（每个Github UserName）拥有一个 github.io 结尾的二级域名当作GitHub Pages的默认域名，比如我的 GitHub UserName 是 `keaising`，那么我的二级域名是 `keaising.github.io`，只要你设置了 GitHub Pages，且不做其他设置，那么你就可以通过 `{username}.github.io` 访问到这个网站

在最早的GitHub Pages要求里，`keaising.github.io`这个主域名对应的 repo 的名字必须也叫`keaising.github.io`，且 gh-pages 分支必须是网站所有的html/js/css等静态文件。不过现在这一切都不要求了，repo 名字随便改，分支名字也随便改（但是需要在GitHub Pages设置里面选一下你的静态文件在哪个分支）

在了解以上知识的情况下我们来说实际情况，以我自己为例

我买了一个域名 `shuxiao.wang`，解析的时候，我给主机记录 `@`和`www`都设置了一条值为 `github.io`的CNAME记录，然后在`keaising.github.io`这个 repo 里将域名写成我的自定义域名`shuxiao.wang`，这样我的 `keaising.github.io` 域名就会被GitHub 301重定向到 `shuxiao.wang`。这是主域名和主项目的情况，一切非常完美

再来说说我的 A/B/C 3个项目，他们的repo名字就是 A/B/C，如果我设置了 GitHub Pages，但是没有给他们设置域名，那么他们会自动获得两个域名 `keaising.github.io/A` 和`shuxiao.wang/A`，只不过前者会被 Github 自动重定向到后者。如果给`A.shuxiao.wang`也同样设置一个一条值为 `github.io`的CNAME记录，那么最后生效的还是 `shuixiao.wang/A`

但是对我来说我不是很喜欢 `shuxiao.wang/A` 这种风格，我更喜欢 `A.shuxiao.wang`，此时我需要的是能自己设置自定义域名的二级域名。就是要告诉 Github：将 `keaising.github.io/A`重定向到 `A.shuxiao.wang` 而不是 `keaising.github.io/A`

这在 GitHub Pages 的文档里貌似没有写，我在 [StackOverflow](https://stackoverflow.com/a/46461290) 上找到了一个方法，虽然看起来是试出来的，但是可以用，就是在解析 A/B/C 的域名时，将 A/B/C 的 CNAME 记录都设置为 `{username}.github.io`，对我来说就是 `keaising.github.io`，这样解析之后就是 `A|B|C.shuxiao.wang`，非常完美

大约过一个小时，HTTPS也可以启用起来，这样设置工作就完成了