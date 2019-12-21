---
title: 第一章 归纳的数据集
date: 2019-11-19
tags:
  - Programming Language
  - Scheme
  - EOPL
---

本章介绍了一些基本的编程工具，这些工具在后续编写解释器(interpreters)、检查器(checkers)和类似组成编程语言核心处理器(processor)之类的程序的时候需要用到

由于一门语言中的语法(syntax)通常都是嵌套(nested)或者树状结构(treelike structure)，故递归在我们将使用的技术中将占据核心位置。第1.1节和第1.2节介绍了用归纳法来描述(specify)数据结构的方法，并揭示了这种描述方法将如何指导我们编写递归的程序。第1.3节阐述了如何将该方法扩展到更加复杂的问题中。最后，本章将以大量的练习作为结尾，这些练习才是本章的核心内容，他们将为你提供足够的经验，去掌握递归编程的思想(the technique of recursive programming)，而这思想，正是本书其他部分的基石。

## 1.1 递归得描述(specified)数据

为一个过程(procedure)编写代码时，我们必须准确得知道该过程的参数的类型、以及该过程的返回值的类型。通常这些值都是复杂类型。在本节，我们将介绍描述这些值的一般方法。

### 1.1.1 归纳描述法(Inductive Specification)

*归纳描述法* 是一个描述数据的有力方法。为了展示这一点，我们将用它来描述自然数{{< math "N={0,1,2,...}" >}}的一个真子集{{< math "S" >}}
  
**定义1.1.1**
: 自然数{{< math "n" >}}属于集合{{< math "S" >}}，当且仅当
    1. {{< math "n=0" >}}，或者
    2. {{< math "n-3 \in S" >}}

让我们看看如何使用这个定义来决定哪些自然数属于集合{{< math "S" >}}，我们知道{{< math "0 \in S" >}}，那么{{< math "3 \in S" >}}，因为{{< math "(3-3)=0" >}}且{{< math "0 \in S" >}}。类似可知{{< math "6 \in S" >}}，因为{{< math "(6-3)=0" >}}且{{< math "3 \in S" >}}。将该推理过程继续下去，我们可以得到结论：所有的{{< math "3" >}}的倍数都属于集合{{< math "S" >}}。

那么其他的自然数呢？{{< math "1 \in S" >}}是否成立呢？我们知道{{< math "1 \ne 0" >}}，因此不满足条件1；此外{{< math "(1-3)=-2" >}}，这不是一个自然数也就不属于集合{{< math "S" >}}，因此不满足条件2。故{{< math "1" >}}不满足任何一个条件，{{< math "1 \not \in S" >}}，类似的，{{< math "2 \not \in S" >}}。那么{{< math "4" >}}呢？{{< math "4 \in S" >}}只有在{{< math "1 \in S" >}}成立的情况下成立，但是{{< math "1 \not \in S" >}}，所以{{< math "4 \not \in S" >}}。类似地，我们可以得到这样的结论：如果{{< math "n" >}}是一个自然数且它不是{{< math "3" >}}的倍数，那么{{< math "n \not \in S" >}}

以上讨论可以得到结论：{{< math "S" >}}是这样的自然数的集合：{{< math "3" >}}的倍数

我们可以用这个定义来写一个判断自然数{{< math "n" >}}是否属于集合{{< math "S" >}}的过程(procedure)

```scheme
in-S? : N -> Bool
usage: (in-S? n) = #t if n is in S, #f otherwise

(define in-S?
    (lambda (n)
        (if (zero? n) #t
            (if (>= (- n 3) 0)
                (in-S? (- n 3))
                #f))))
```

这里我们根据定义用Scheme写了一个递归过程。其中`in-S? : N -> Bool`是一个批注(comment)，称为该过程的*契约(contract)* ，它表示`in-S?`被设计为这样一个过程：以一个自然数作为入参并产生一个布尔值作为出参。这样的批注对读写代码都是很有帮助的

为了判断{{< math "n \in S" >}}是否成立，我们首先判断{{< math "n=0" >}}是否成立，如果后者成立，则前者也成立。否则我们需要看{{< math "n-3 \in S" >}}是否成立，为了判断{{< math "n-3 \in S" >}}是否成立，我们先要检查{{< math "(n-3) \ge 0" >}}是否成立。如果成立的话，我们就可以使用我们已有的过程逻辑来判断它是否属于集合{{< math "S" >}}，如果不成立，那么{{< math "n" >}}不可能属于集合{{< math "S" >}}

下面是另一种集合{{< math "S" >}}的定义

**定义1.1.2**
: 定义集合{{< math "S" >}}为包含于自然数{{< math "N" >}}且满足下列两个性质的最小集合:
    1. {{< math "n \in S" >}}，且
    2. 如果{{< math "n \in S" >}}，那么{{< math "n+3 \in S" >}}

一个“最小集合”是指满足条件1和条件2且是任何满足条件1和条件2的集合的子集。很容易看出这样的集合只有一个：假设存在{{< math "S_1" >}}和{{< math "S_2" >}}都满足条件1和条件2且都是最小集合，那么{{< math "S_1 \subseteq S_2 " >}}（因为{{< math "S_1" >}}是最小集合）且{{< math "S_2 \subseteq S_1 " >}}（因为{{< math "S_2" >}}也是最小集合），因此{{< math "S_1=S_2" >}}。我们需要这个额外条件，否则会有许多集合满足以上两个条件（参见练习1.3）

另外还有一种定义的写法：

{{< formula "\frac{}{0 \in S}\qquad" >}}

{{< formula "\frac{n \in S}{(n+3) \in S}\qquad" >}}