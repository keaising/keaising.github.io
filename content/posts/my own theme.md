---
title: 自己的主题
layout: post
date: 2019-11-07
tags:
  - theme
---

终于自己做了主题

从2014年末开始，我就尝试写一点什么来记录自己，也就开始寻找做自己的博客的方法。最初使用的是jekyll，在知乎上看到有人推荐[rusty shutter](https://lhzhang.com/)，于是我的博客第一版就用了jekyll和这个主题

但是jekyll对Windows用户其实并不友好，配置Ruby开发环境不是一件容易的事情，以至于很多jekyll用户在本地使用docker来处理jekyll环境。另一方面jekyll对分类的支持并不特别好，很多我需要的功能都不能支持，于是萌发了自己写一个生成器的想法

此时遇到了[Hugo](https://gohugo.io/)，对Windows用户非常友好，生成速度超快，主题丰富，同时模板系统和分类系统都极其灵活，支持非常多的想法，还是用Go写的，实在不行我自己改生成器本身也可以

一开始我使用的是[qqhann](https://qqhann.dev/)的主题，[我还帮他加上](https://github.com/qqhann/hugo-primer/pull/29)了对[ruby语法](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby)的支持。但是这个主题的中英文混排并不能让我满意，于是我找到了[漢字標準格式](https://hanzi.pro/)，也正好在同时期遇到了两个主题：[I/O OVER](https://ioover.net/)和[Typeof.net](https://typeof.net/)，很遗憾，这两个主题都是闭源的，前者基于jekyll，后者基于Hexo。

我萌生了写一个样式和结构都满足自己需求的主题的想法，就是现在这样

+ 主题：基于[Hugo](https://gohugo.io/)
+ 基本框架：来自[qqhann](https://qqhann.dev/)
+ 红色基调：来自[rusty shutter](https://lhzhang.com/)
+ 设计风格：尽量贴近[Typeof.net](https://typeof.net/)，但是我放弃了他最显眼的衬线字体
+ 代码样式、导航栏样式：来自[I/O OVER](https://ioover.net/)
+ 排版：[漢字標準格式](https://hanzi.pro/)

天下文章一大抄，代码也一样，主题也一样