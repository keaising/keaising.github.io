---
title: Sams Teach Yourself TCP/IP in 24 Hours
layout: post-toc
guid: 4a17045b-26df-4271-9228-064200b9b916
date: 2019-10-26
weight: 100
tags:
  - TCP/IP
  - protocol
---

在我学习 TCP/IP 协议的道路上遇到过很多书，随便拎一本出来都是振聋发聩的作品：

+ [TCP/IP详解 卷1：协议](https://book.douban.com/subject/1088054/)
+ [图解TCP/IP（第5版）](https://book.douban.com/subject/24737674/)
+ [TCP/IP详解 卷1 协议（英文版）](https://book.douban.com/subject/26790659/)

但是我似乎并没有能从他们之中入到门，可能是我比较愚钝，难以理解到大师著作的精髓，直到我在 OReilly Online 遇到了 [Sams Teach Yourself TCP/IP in 24 Hours](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/)

这本书跟我之前很喜欢的 [SQL必知必会](https://book.douban.com/subject/24250054/)、[正则表达式必知必会](https://book.douban.com/subject/26285406/) 出自同一个系列，我是先在 OReilly 上读了才发现有中文版 [TCP/IP入门经典](https://book.douban.com/subject/10556677/)

这本书最好的地方在于详略得当，足够新也足够详细，但又没有详细到啰嗦的地步，读起来还是比较舒服的，我终于在这本书里弄明白了为何要划分子网、如何划分子网、子网掩码的用途用法、路由的基本方法等之前一直没有弄明白的内容，此书恰如其分得成为了我的入门之书

## Hour2. How TCP/IP Works

简单介绍了以下 4 个内容：

+ TCP/IP protocol system
+ The OSI model
+ Data packages
+ How TCP/IP protocols interact

### 2.1 TCP/IP protocol system

+ Network Access layer
+ Internet layer
+ Transport layer
+ Application layer

### 2.2 The seven-layer OSI model

OSI(Open Systems Interconnection) 有 7 层：

+ Physical layer
+ Data Link layer
+ Network layer
+ Transport layer
+ Session layer
+ Presentation layer
+ Application layer

OSI 和 TCP/IP 的关系如下

![osi vs tcpip](/images/2019/10/26/2.2 osi vs tcpip.png)

### 2.3 Data packages

发送数据时，数据包在协议栈上从上往下传递的过程中，每一层都会给数据包增加一个头部(header)，用来放置本层所需的信息。接收消息时，一个反向过程会将数据包从层层包裹中取出

![data package](/images/2019/10/26/2.3 data package.png)

### 2.4 QUIZ AND EXERCISES

1. [Q3] What are the advantages and disadvantages of UDP as compared to TCP?
2. [E1] List the functions performed by each layer in the TCP/IP stack.
3. [E4] Explain what it means to say that TCP is a reliable protocol.

快速答案参见：[Appendix A. Answers to Quizzes and Exercises](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/app01.html#app01)

### 2.5 KEY TERMS

Segment
: The data package passed from TCP at the Transport layer to the Internet layer.

Datagram
: 
   1. The data package passed from the Internet layer to the Network Access layer
   2. or a data package passed from UDP at the Transport layer to the Internet layer.

Frame
: The data package created at the Network Access layer.

**Segment** -> **Datagram** -> **Frame** 


## Hour 4. The Internet Layer

介绍了以下内容：

+ IP addresses
+ The IP header
+ ARP
+ ICMP

### 4.1 ADDRESSING AND DELIVERING

#### 4.1.1 IP 层存在的意义
在独立的LAN(Local Area Network)里，网卡间通信只需要物理地址即可传输数据，此时只需要Network Access layer即可

当在一个需要路由的网络环境中传输数据时，物理地址就不够用了，原因有2：

1. 物理地址很难越过路由接口进行寻址工作
2. 即便是可以，物理地址缺少逻辑结果进行分层的能力，导致寻址过程速度缓慢

IP 层应运而生：TCP/IP therefore makes the physical address invisible and instead organizes the network around a logical, hierarchical addressing scheme. 

IP 层具有以下能力：

1. This logical addressing scheme is maintained by the **IP protocol** at the Internet layer
2. The logical address is called the **IP address**
3. Another **Internet layer protocol** called **Address Resolution Protocol (ARP)** assembles a table that maps IP addresses to physical addresses

#### 4.1.2 IP 层传输策略

如果在同一网络中，就直接使用ARP得到物理地址，然后传输.

如果在不同网络中，

1. 数据首先被传输到 gateway，通过 gateway 传输到其他网络，gateway 也是路由器
2. 数据通过 gateway 进入到其他网络中，如果物理地址就在当前网络，那么传输给目标地址；如果不在，那么继续通过 gateway 向后传播，继续这一过程

### 4.2 INTERNET PROTOCOL

Internet Protocol (IP) 提供了一个层次化、与硬件无关的寻址系统，以便在复杂且需要路由的网络中传输数据，每个网卡都有一个唯一的 IP 地址

IP地址的组成部分

network ID
: 划分网络

host ID
: 在一个划分好的网络中找到特定主机
: 长度：4 x 8 bit，每 8bit 为一个 octet，用 0-255 之间的一个数字表示

IP 地址被划分为 5 类：

+ A：used the first 8 bits of the address for the network ID
+ B: used the first 16 bits
+ C: used the first 24 bits

5类地址的每一个地址就是一个网络，A类地址只使用了前8位作为network ID，每个A类地址的网络可以还可以有`2**8 x 2**8 x 2**8 = 16,777,216`个地址可以分配，B/C 类地址的计算同理

如果一个网络里还要划分子网该怎么办呢？VLSM

那如果有两三个网络需要合并成一个呢？CIDR

VLSM 和 CIDR 都是在子网掩码的基础上进行操作

VLSM
:  将子网掩码中的 1 右移，在网段中继续划分网段

CIDR
: 将子网掩码中的 0 左移，将多个相邻网段合并成一个


### 4.3 ADDRESS RESOLUTION PROTOCOL

Internet layer protocol

Map IP addresses to physical addresses

### 4.4 REVERSE ARP

RARP is the opposite of ARP. 

ARP is used when the IP address is known but the physical address is not known. 

RARP is used when the physical address is known but the IP address is not known.

### 4.5 INTERNET CONTROL MESSAGE PROTOCOL

两个作用：

1. Routers ICMP messages to notify the source IP of these problems.
2. ICMP is also used for other diagnosis and troubleshooting functions.

### 4.6 OTHER INTERNET LAYER PROTOCOLS

IP 层协议还有Border Gateway Protocol (BGP) 和 Routing Information Protocol (RIP) 都是路由协议，主要是用来加快路由的

### 4.7 QUIZ AND EXERCISES

[Q1](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/app01.html#app01qa6a2): What is the purpose of the TTL field in the IP header?

### 4.8 KEY TERMS

[Address Class](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/ch04.html#ch04term01a)
: A classification system for IP addresses. The network class determines how the address is subdivided into a network ID and host ID.

[Address Resolution Protocol (ARP)](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/ch04.html#ch04term02a)
: A key Internet layer protocol used to obtain the physical address associated with an IP address. ARP maintains a cache of recently resolved physical address-to-IP address pairs.

[Internet Control Message Protocol (ICMP)](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/ch04.html#ch04term06a)
: A key Internet layer protocol used by routers to send messages that inform the source IP of routing problems. ICMP is also used by the ping command to determine the status of other hosts on the network.

[Reverse Address Resolution Protocol (RARP)](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/ch04.html#ch04term11a)
: A TCP/IP protocol that returns an IP address if given a physical address. This protocol is typically used by a diskless workstation that has a remote boot PROM installed in its network adapter.

[Subnet](https://learning.oreilly.com/library/view/sams-teach-yourself/9780132810814/ch04.html#ch04term12a)
: A logical division of a TCP/IP address space.

## Hour 5. Subnetting and CIDR

主要是讲子网划分，知道子网掩码怎么算、VLSM、CIDR 即可

虽然这章是我花时间最多、看得最认真的，但是读懂之后就没什么可做摘抄的了

+ [CIDR vs VLSM: understanding how they works](https://www.routerfreak.com/cidr-vs-vlsm/)
+ [vlsm与cidr的原理，还有它们的不同之处](https://www.zhihu.com/question/52628019/answer/220436824)

### 5.1 Q&A

Q. A network admin calculates that he needs 21 mask bits for his network. What subnet mask should he use?

A. 21 mask bits: 11111111111111111111100000000000 is equivalent to two full octets plus an additional 5 bits. Each full octet is expressed in the mask as 255. The five bits in the third octet are equivalent to 128 + 64 + 32 + 16 + 8 = 248. The mask is 255.255.248.0.

Q. What IP addresses are assigned in the CIDR range 212.100.192.0/20?

A. The /20 supernet parameter specifies that 20 bits of the IP address will be constant and the rest will vary. The binary version of the initial address is

11010100.01100100.11000000.00000000

The first 20 bits of the highest address must be the same as the initial address, and the rest of the address bits can vary. Show the varying bits as the opposite end of the range (all 1s instead of all 0s):

11010100.01100100.11001111.11111111

The address range is 212.100.192.0 to 212.100.207.255.

Q. Calculate the CIDR network address you get if you combine the network addresses 180.4.0.0 through 180.7.255.255 into a single network?

A. You get the CIDR address 180.4.0.0/14.