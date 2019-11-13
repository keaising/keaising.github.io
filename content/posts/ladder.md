---
title: 楼梯有多少种走法
layout: post
guid: 2ef3550f-8cf3-400b-a55b-c512c9af8be3
date: 2019-10-21
tags:
  - 网鱼网咖
  - Python
---

这是在 telegram 网鱼网咖群里聊天时，Haruhi贴的一个题，题目如下：

![wangyuwangka](/images/2019/10/21/wangyuwangka.jpg)

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

santo: O(4) 就行了

有道理，因为只需要存 4 个值用来迭代就行了

santo还提了一个更加快捷得到答案的方法：

> 前四个列出来
>
> 奇偶偶奇, mod 4 = 0的是(1+0+0)%2; mod 4 = 1的是(1+1+0)%2, ...  然后这题里只有一个偶数...  这种选择题, 应该是要人秒答? 所以随便蒙一下...

此外，Haruhi还发散了一下，如果总共 total 级阶梯，一次最多跨越 step 级，那有多少种方法？

于是我又给写了一下

```python
def ladder(total, step):
    assert total > 0
    assert step > 0
    h = {}
    # 走完脚力范围内一次性可以走完的阶梯，获得迭代的基础
    for i in range(1, step + 1, 1):
        h[i] = sum([h[x] for x in range(1, i)])+1

    # 对不能一次走完的阶梯进行迭代
    for i in range(step + 1, total + 1, 1):
        # temp 是新的阶梯可能走的次数
        temp = sum([h[x] for x in range(1, step + 1)])
        # 挤占掉最小的一次阶梯 e.g. 
        # 1 2 4 ->
        # 2 4 7 ->
        # 4 7 13
        for j in range(1, step):
            h[j] = h[j+1]
        h[step] = temp
    
    # 兼容 total < step 的情况
    print(h[step] if total > step else h[total])

ladder(5, 3)
```