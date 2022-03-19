---
title: 第一章 归纳的数据集
date: 2019-11-19
weight: 201
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

让我们看看如何使用这个定义来决定哪些自然数属于集合{{< math "S" >}}，我们知道{{< math "0 \in S" >}}，那么{{< math "3 \in S" >}}，因为{{< math "(3-3)=0" >}}且{{< math "0 \in S" >}}。类似可知{{< math "6 \in S" >}}，因为{{< math "(6-3)=0" >}}且{{< math "3 \in S" >}}。将该推演过程继续下去，我们可以得到结论：所有的{{< math "3" >}}的倍数都属于集合{{< math "S" >}}。

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
    1. {{< math "0 \in S" >}}，且
    2. 如果{{< math "n \in S" >}}，那么{{< math "n+3 \in S" >}}

一个“最小集合”是指满足条件1和条件2且是任何满足条件1和条件2的集合的子集。很容易看出这样的集合只有一个：假设存在{{< math "S_1" >}}和{{< math "S_2" >}}都满足条件1和条件2且都是最小集合，那么{{< math "S_1 \subseteq S_2 " >}}（因为{{< math "S_1" >}}是最小集合）且{{< math "S_2 \subseteq S_1 " >}}（因为{{< math "S_2" >}}也是最小集合），因此{{< math "S_1=S_2" >}}。我们需要这个额外条件，否则会有许多集合满足以上两个条件（参见练习1.3）

另外还有一种定义的写法：

{{< formula "\dfrac{}{0 \in S}\qquad" >}}

{{< formula "\dfrac{n \in S}{(n+3) \in S}\qquad" >}}

这只是前面写法的一种简写形式，每一个条目称为一个“推演规则”，或者简称为一个“规则”，横线读作“如果...那么...”，横线上半部分称为“假设/先行词”，横线下半部分称为“结论/推断”。当存在两个以上假设时，他们之间默认用“且”连接（例如**定义1.1.5**）。没有假设的规则称为“公理”，通常，公理的横线会省略不写，比如：

{{< formula "0 \in S" >}}

该公理的意思是：自然数{{< math "n" >}}在集合{{< math "S" >}}中，当且仅当语句{{< math "n \in S" >}}可以在有限次数内使用推演规则从公理推导出。这个解释天然得保证了集合{{< math "S" >}}是在规则范围内闭合的所有集合里的最小集合

这些定义全都描述了同样的事。第一个版本我们称为「自上而下」法，第二个版本称为「自下而上」法，而第三个版本称为「推演规则」法，现在我们来试试将这些规则应用到其他例子

**定义1.1.3 (整数数列，自上而下)**
: 一个`Scheme list`是一个`List-of-Int`，当且仅当：
    1. 它是一个空数列，或者
    2. 它是一个car是整数、cdr是一个整数数列的序对(pair)


在这里我们使用`Int`表示全体整数的集合，用`List-of-Int`表示全部`整数数列`的集合

译者注：
: 关于序对(pair)、car、cdr可以阅读[Pairs and lists - Revised(5) Scheme](https://people.csail.mit.edu/jaffer/r5rs/Pairs-and-lists.html)。以下关于简单的Scheme语法不再提示

接下来再看另一个定义

**定义1.1.4 (整数数列，自下而上)**
: 集合`List-of-Int`在满足以下两个条件时，就是最小的`Scheme List`集合
    1. {{< math "() \in List-of-Int" >}}，且
    2. 如果{{< math "n \in Int" >}}且{{< math "l \in List-of-Int" >}}，那么{{< math "(n . l) \in List-of-Int">}}

这里我们使用占位符`.`来表示Scheme语言中`cons`操作的结果。`(n . l)`表示一个Scheme语言中的一个序对，在这个序对中，`car`是`n`，`cdr`是`l`

**定义1.1.5 (整数数列，推演规则)**
: {{< formula "() \in List-of-Int" >}}
    {{< formula "\dfrac{n \in Int \hspace{2em} l \in List-of-Int}{(n \hspace{.5em} . \hspace{.5em} l) \in List-of-Int}\qquad" >}}

这3个定义是相等的。我们接下来演示一下如何用他们来生成`List-of-Int`中的一些元素

1. `()`是一个整数列，因为它满足定义1.1.4的属性1或者是满足定义1.1.5的第一个规则
2. `(14 . ())`是一个整数列，根据定义1.1.4的属性2可知，因为`14`是一个整数，而`()`是一个整数列，我们可以将这个推论写作是`List-of-Int`的第二条规则的一个实例 
{{< formula "\dfrac{14 \in Int \hspace{2em} () \in List-of-Int}{(14 \hspace{.5em} . \hspace{.5em} ()) \in List-of-Int}\qquad" >}}
3. `(3 . (14 . ()))`是一个整数列，根据属性2可知，因为`3`是一个整数，而`(14 . ())`是一个整数列，我们也可以将这个推演过程写作`List-of-Int`的第二条规则的一个实例
{{< formula "\dfrac{3 \in Int \hspace{2em} (14 \hspace{.5em} . \hspace{.5em} ()) \in List-of-Int}{(3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ())) \in List-of-Int}\qquad" >}}
4. `(-7 . (3 . (14 . ())))`是一个整数列，根据属性2可知，因为`-7`是一个整数，而`(3 . (14 . ()))`是一个整数列，这次我们同样将这个推演过程写作`List-of-Int`的第二条规则的一个实例
{{< formula "\dfrac{-7 \in Int \hspace{2em} (3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ())) \in List-of-Int}{(-7 \hspace{.5em} . \hspace{.5em} (3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ()))) \in List-of-Int}\qquad" >}}
5. 如果一个数列也是这样构建的话，那就是一个整数列

将上面的点表示法转换成列表表示法，可以看到`()`、`(14)`、`(3 14)`、`(-7 3 14)`都包含于`List-of-Int`。我们也可以将规则全部合起来，得到整个{{< math "(-7 \hspace{.5em} . \hspace{.5em} (3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ()))) \in List-of-Int" >}}因果链的全景图。下面这个树状图被称为*派生树*或者*演绎树*

{{< formula "\begin{align} 14 \in N \hspace{2em} () &\in List-of-Int \\ \rule{3.5cm}{.6pt} & \rule{3.5cm}{.6pt} \\ 3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ())) &\in List-of-Int \\ \rule{6cm}{.6pt} & \rule{3.5cm}{.6pt} \\ -7 \in N \hspace{2em} (3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ())) &\in List-of-Int \\ \rule{6cm}{.6pt} & \rule{3.5cm}{.6pt} \\ (-7 \hspace{.5em} . \hspace{.5em} (3 \hspace{.5em} . \hspace{.5em} (14 \hspace{.5em} . \hspace{.5em} ()))) & \in List-of-Int \end{align}" >}}

练习1.1 [*]
: 写出下列集合的归纳法定义。每个定义都要写3种类型(自上而下，自下而上，推演规则)，并使用你所写的规则，举出每个集合的示例数据
    1. {{< math "{3n+2 \hspace{.5em} | \hspace{.5em} n \in N}" >}}
    2. {{< math "{2n+3m+1 \hspace{.5em} | \hspace{.5em} n,m \in N}" >}}
    3. {{< math "{(n,2n+1) \hspace{.5em} | \hspace{.5em} n \in N}" >}}
    4. {{< math "{(n,n^2) \hspace{.5em} | \hspace{.5em} n \in N}" >}} 
    不要在定义的规则中使用平方，一点小提示，想想这个方程 {{< math "(n+1)^2 = n^2+2n+1 ">}}

练习1.2 [**]
: 根据以下规则分别可以得到什么样的集合？并阐述理由
    1. {{< math "(0,1) \in S \hspace{3em} \dfrac{(n, k) \in S}{(n+1,k+7) \in S}\qquad" >}}
    2. {{< math "(0,1) \in S \hspace{3em} \dfrac{(n, k) \in S}{(n+1,2k) \in S}\qquad" >}}
    3. {{< math "(0,0,1) \in S \hspace{3em} \dfrac{(n, i, j) \in S}{(n+1,j,i+j) \in S}\qquad" >}}
    4. [***] {{< math "(0,1,0) \in S \hspace{3em} \dfrac{(n, i, j) \in S}{(n+1,i+2,i+j) \in S}\qquad" >}}

练习1.3 [*]
: 找到满足以下条件的自然数集合`T`：
    1. {{< math "0 \in T">}}
    2. 对任何{{< math "n \in T">}}，都有{{< math "n+3 \in T">}}
    3. {{< math "T \neq S">}}，其中{{< math "S">}}是定义1.1.2中的集合

### 1.1.2 用语法(Grammars)定义集合

之前的例子非常的直观，但是很容易想象到，在处理更复杂的数据类型的时候，描述过程会变得相当的笨重。为了作出改进，我们将展示如何用*语法*来描述集合。语法一般常用于描述字符串集合，但我们同样能用它来定义数值集合。比如我们可以用如下语法来定义{{< math "List-of-Int" >}}

{{< formula "\begin{align} List-of-Int &::= () \\ List-of-Int &::= (Int \hspace{.5em} . \hspace{.5em} List-of-Int) \end{align}" >}}

由于定义1.1.4有两个属性，对应得这里有两条规则。第一条规则意味着空数组包含于`List-ofInt`，第二条规则说明了如果`n`在集合`Int`中、`l`在集合`List-of-Int`中，那么`(n . l)`在集合`List-of-Int`中，这两条规则的组合被称为一个*语法*

现在我们来仔细看看语法的定义，在定义中有如下元素：

+ **非终结性符号**：非终结性符号是指那些被定义的集合的名字。在上面的例子中只有一个这样的集合，但通常来说，一般都会有好几个被定义的集合，这些集合有时候也被称为**句法范畴**。方便起见，我们约定对集合和非终结性符号的名字使用大写名字，在引用他们中的元素时使用小写名字。听起来很复杂但是一看例子就明白了，比如：{{< math "Expression">}}是 非终结的，所以我们写作{{< math "e \in Expression" >}}或者`e is an expression.` 另一种惯用约定是巴科斯范式(Backus-Naur Form)，或者简称BNF，写法是在单词两端写箭头，比如：{{< math "<expression>">}}

+ **终结性符合**：比如以下符合：`. ( )`，一般会用等宽字体来写，比如`lambda`

+ **Production**：一条规则就是一个production(产品)。每个production分为左右两侧，左侧是一个非终结性符合，右侧是终结性符号和非终结性符号。左右两侧由符号`::=`分隔，读作*是*。右侧内容阐明了根据其他句法范畴和终结性符号(比如左括号、右括号和句号)来构造句法范畴成员的方法

有时候，如果从上下文中已经可以得到足够清晰的意义，production中的部分句法范畴也会不进行定义，比如`Int`

语法经常会用使用符号缩写进行编写。如果一个production的左侧内容跟上一个production的左侧内容一致，推荐直接把左侧内容省略，比如：

{{< formula "\begin{align} List-of-Int &::= () \\ &::= (Int \hspace{.5em} . \hspace{.5em} List-of-Int) \end{align}" >}}

也可以只写一次`::=`，用一个特殊的`|`符号将右侧的两行内容分隔，比如：

{{< formula "\begin{align} List-of-Int ::= () \hspace{.5em} | \hspace{.5em} (Int \hspace{.5em} . \hspace{.5em} List-of-Int) \end{align}" >}}

还有一种缩写形式叫*Kleene star*(克林星)，用{{< math "\{...\}^*">}}符号来表示
