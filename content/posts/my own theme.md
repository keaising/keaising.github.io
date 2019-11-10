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

一开始我使用的是[qqhann](https://qqhann.dev/)的主题，[我还帮他加上](https://github.com/qqhann/hugo-primer/pull/29)了对[ruby语法](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby)的支持。但是这个主题的中英文混排并不能让我满意，于是我找到了[漢字標準格式](https://hanzi.pro/)，也正好在同时期遇到了两个主题：[I/O OVER](https://ioover.net/)和[Typeof.net](https://typeof.net/)，很遗憾，这两个主题都是闭源的，前者基于jekyll，后者基于Hexo。正好此时我开始读[EOPL](https://book.douban.com/subject/3136252/)，发现这本书貌似因为没有中文翻译而读者甚少，但是读过的人都评价甚高，堪比SICP，所以我打算一边读一边做翻译，如果翻译一本书的话，有一个自己能自由控制格式的站点就很有必要了

我萌生了写一个样式和结构都满足自己需求的主题的想法，就是现在这样

+ 生成器：[Hugo](https://gohugo.io/)
+ 基本框架：来自[qqhann](https://qqhann.dev/)
+ 红色基调：来自[rusty shutter](https://lhzhang.com/)
+ 设计风格：尽量贴近[Typeof.net](https://typeof.net/)，但是我放弃了他最显眼的衬线字体，衬线字体比较老派，控制不好就会显得老气，我还是老老实实用非衬线讨好习惯小屏幕的用户吧
+ 代码样式、导航栏样式：来自[I/O OVER](https://ioover.net/)
+ 排版：[漢字標準格式](https://hanzi.pro/)，优势在于自动在中英文混排时加间隔、标点悬挂、挤压，劣势在于性能比较差，在渲染时能显著看到页面抖动和重排，个人博客的话还算可以接受

主体功能基本完成，未来还想做的包括：

+ 用Ice帮忙写的分栏样式做一个分两栏的模板，给翻译的书稿做评注功能【已有规划】
+ 将Cloud页面的顶部加上所有的tag/category/series的集合【完成】
+ 页面锚点【完成】
+ 目录/toc

天下文章一大抄，代码也一样，主题也一样