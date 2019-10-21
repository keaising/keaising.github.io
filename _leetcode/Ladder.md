---
title: Ladder
layout: post
guid: 2ef3550f-8cf3-400b-a55b-c512c9af8be3
date: 2019-10-21
tags:
  - 网鱼网咖
  - Python
---

这是在 telegram 网鱼网咖群里聊天时，Haruhi贴的一个题，题目如下：

![wangyuwangka](/media/images/2019/10/21/wangyuwangka.jpg)

思路很简单

> 可以从14、13、12级跨到第15级 f(15)=f(14)+f(13)+f(12)
>
> 递推公式出来鸟~

当然要得到一个答案是非常简单的

```python
def ladder(N, m = 3):
    h = {}
    h[1] = 1
    h[2] = 2
    h[3] = 4
    for i in range(4, N+1):
        h[i] = h[i-1]+h[i-2]+h[i-3]
    print(h[N])

ladder(15)
```

狗叔：时间复杂度和空间复杂度？

我回答：

> hash把每级阶梯的走法存下来，N级阶梯的话空间复杂度O(N)，时间复杂度也是O(N)，先用迭代从1开始迭代到N，然后最后加起来就行。递归的复杂度我就不知道该怎么分析了

狗叔：Hash的空间复杂度是多少？

回答：O(N)

santo: O(4)

```python
def ladder(total, step):
    h = {}
    for i in range(1, step + 1, 1):
        h[i] = sum([h[x] for x in range(1, i)])+1

    for i in range(step + 1, total + 1):
        temp = sum([h[x] for x in range(1, step + 1)])
        for j in range(1, step):
            h[j] = h[j+1]
        h[step] = temp
    print(h[step])

ladder(15, 3)
```