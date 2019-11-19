---
title: 第一章 归纳的数据集
date: 2019-11-19
tags:
  - Programming Language
  - Scheme
  - EOPL
---

本章介绍了一些基本的编程工具，这些工具将在后续编写解释器(interpreters)、检查器(checkers)和类似组成编程语言核心处理器(processor)之类的程序的时候需要用到

由于一门语言中的语法(syntax)通常都是嵌套(nested)或者树状结构(treelike structure)，故递归在我们将使用的技术中将占据核心位置。第1.1节和第1.2节介绍了用归纳法来描述(specify)数据结构的方法，并揭示了这种描述方法将如何指导我们编写递归的程序。第1.3节阐述了如何将该方法扩展到更加复杂的问题中。最后，本章将以大量的练习作为结尾，这些练习才是本章的核心内容，他们将为你提供足够的经验，去掌握递归编程的思想(the technique of recursive programming)，而这思想，正是本书其他部分的基石。
