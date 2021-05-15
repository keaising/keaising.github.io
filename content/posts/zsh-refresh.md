---
title: 不优化，zsh 也超快
layout: post
date: 2021-05-15
tags:
  - dotfiles
---

如果你折腾过 shell，那你肯定遇到过 [oh-my-zsh](https://ohmyz.sh/)，这个巨大的框架什么都好，就是有点慢。在用了一年多 oh-my-zsh 之后，我有点烦了那种卡卡的感觉，想换一个 shell 试试。在尝试 fish 之后我放弃了这种所谓的现代 shell，我还是更喜欢完全文本化的配置，fish 的语法跟 bash 差别太大我也不是很喜欢，毕竟 bash 的语法是日常绕不过的坎，我希望尽量贴合 bash。这个思路下可选的其实并不多，要么是 bash，要么是曾经要兼容 bash 但是后来放弃了不过也勉强能兼容的 zsh

所以问题就变成了，怎么把 zsh 搞快一点？

稍微搜索一下，我找到了这么几个文档

1. [为什么说 zsh 是 shell 中的极品？](https://www.zhihu.com/question/21418449)
2. [Faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
3. [我就感觉到快 —— zsh 和 oh my zsh 冷启动速度优化](https://blog.skk.moe/post/make-oh-my-zsh-fly/#)

1 可以看作是安利，zsh 是个好 shell，除了配置有点麻烦以外其他都很赞

2 是朋友发给我的一个优化文，主要是讲述了 zsh 启动过程中每个配置文件的作用和他们之间的先后加载顺序，还提到了一个几乎所有 oh my zsh 的优化文章都会提的一个东西：lazy load

3 是一个实际优化案例，思路跟 2 里的几乎一样，也是减少子进程和懒加载，不过更加实战，很多脚本都可以直接照着跑

我在自己尝试了一番之后发现，其实不用这些优化策略，配置好的 zsh 也可以很快，只要控制好加载的内容就足够了，接下来我叙述一下我的折腾过程

## 1. 明确需求

没错，哪怕只是做自己的事也需要明确一下需求，为什么我需要 oh my zsh 呢？

因为我不会装插件和主题，以前用的都是 oh my zsh 自带的插件和主题，只需要跑一下 oh my zsh 的一键安装脚本就可以用了

那我到底需要 oh my zsh 的什么功能？或者叫现在我对 shell 的需求是什么？

1. 配色好看一点
2. 能展示当前路径，git 分支信息和状态
3. 最好是带补全和提示
4. 命令有颜色提示，输错了能提示一下
5. 能搜索历史记录和目录下的文件

最后我做出来的效果如下：

![final1](/images/zsh-refresh/final-1.png)

可以看到这几种情况

1. command 在 $PATH 中存在，是浅绿色的，如果不存在，是红色
2. 正常情况下提示符是浅绿色delta，如果上一条执行错误，是红色的×，如果是 vi mode，是蓝色的 V
3. 如果目录是个 git repo，显示当前所在的分支名，如果有更改或者远端有更改，将状态展示在分支名后面

下图是搜索历史记录，在 shell 里摁 CTRL+R 触发搜索，CTRL+N/P 选择上一项/下一项

![final2](/images/zsh-refresh/final-2.png)

下图是搜索当前路径下文件，格式是 command + 空格 ++ ll + TAB，CTRL+N/P 选择上一项/下一项，选择到合适的文件之后摁回车，出现在 shell 里的内容是 command + 内容（ll 只是用来做触发关键字的，可以自定义）

![final3](/images/zsh-refresh/final-3.png)

## 2. 找到工具

### 插件管理工具

需求和目的明确之后只需要找对应的工具了，首先是把框架搭起来，oh my zsh 肯定是不能用了，那就找一个插件管理工具来帮我们管插件。

我找到的是 [zinit](https://github.com/zdharma/zinit)，从跑分上看，它的速度比钦定的 antigen 快，看了下用法也算简单，那就它了

### 高亮/补全/提示

其次是找插件，我的需求就是语法高亮、补全和提示，正好 zsh-users 的仓库里有这 3 个

+ [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
+ [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
+ [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

正好可以满足需求，用 zinit 装上即可

```shell
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
```

只要把这 3个插件一装上，在 zsh 里输入 command 就已经有高亮和提示效果了

### 主题

在 oh my zsh 时期，我用的主题是 pure，但是那个主题稍微想自定义一下都很困难，需要学习的概念有点多，我这次正好就放弃了，重新换一个

我选择了比较现代的、用Rust写的 [Starship](https://starship.rs/)，它的优点是速度很快、配置简单、文档齐全、默认配色就足够好看，自己做微调也相对容易，最后我的配置文件长这样

```config
add_newline = true

[directory]
truncation_length = 0
truncate_to_repo = false

[git_branch]
format = "[$branch]($style) "
# format = "[$symbol$branch]($style) "

[golang]
format = "[$symbol()]($style)"

[cmd_duration]
format = "[$duration]($style) "
min_time = 3_000

[character]
success_symbol = "[Δ](bold green)"
error_symbol = "[✗](bold red)"
vicmd_symbol = "[V](bold blue) "

[username]
style_user = "yellow bold"
style_root = "black bold"
format = "[$user@]($style)"
disabled = false

[hostname]
ssh_only = true
format =  "[$hostname](bold yellow) "
disabled = false

[package]
disabled = true

[gcloud]
disabled = true

[aws]
disabled = true
```

### 搜索

搜索分为搜索历史和搜索当前目录下的文件，搜索当然是用超好用的 [fzf](https://github.com/junegunn/fzf)，fzf 的配置超简单，运行速度很快，照着官方文档弄就行，我唯一改了的是反转了一下上下，我不是很喜欢搜索结果在最下面的默认展示风格，于是调整了一下

``` shell
# 反转展示结果
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# 搜索文件时的触发因子
export FZF_COMPLETION_TRIGGER='ll'
# 搜索文件时改成 fd 搜索且允许搜索隐藏文件
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# 下面这个文件是 fzf 安装期间自动生成的，不用改
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
```

我在官方文档的提示下安装了 ripgrep/fd/bat 等工具，这些工具都是用 Rust 写的 grep/find/cat 的替代品，速度很赞，推荐使用

## 3. 跑个分

配置好之后直接跑个分

```shell
# 不加载配置
for i in $(seq 1 5); do /usr/bin/time /bin/zsh --no-rcs -i -c exit; done

# 正常加载配置
for i in $(seq 1 5); do /usr/bin/time /bin/zsh -i -c exit; done
```

![v](/images/zsh-refresh/v.png)

在完全没有用任何 lazy load 和减少子进程之类的优化的情况下，启动速度也不过是 0.2s 左右，而且这里面还夹杂了我所有的其他初始化脚本（当然这里面也没有什么很重的初始化内容），对于我来说已经很满意了。

由于我的 ssh key 也放在 dotfiles 里的，现在不能公开完整的配置文件，过几天我换个仓库重新来过之后，会把我的 dotfiles 仓库放出来