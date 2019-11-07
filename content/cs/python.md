---
title: Python
layout: post
date: 2016-01-01
no: 4
---

## @staticmethod vs. @classmethod

`2019-10-02`

主要来源：[Stack Overflow](https://stackoverflow.com/questions/136097/what-is-the-difference-between-staticmethod-and-classmethod)

``` python
class A(object):
    def foo(self, x):
        print "executing foo(%s, %s)" % (self, x)

    @classmethod
    def class_foo(cls, x):
        print "executing class_foo(%s, %s)" % (cls, x)

    @staticmethod
    def static_foo(x):
        print "executing static_foo(%s)" % x    

a = A()

a.foo(1)
# executing foo(<__main__.A object at 0xb7dbef0c>,1)

a.class_foo(1)
# executing class_foo(<class '__main__.A'>,1)

A.class_foo(1)
# executing class_foo(<class '__main__.A'>,1)

a.static_foo(1)
# executing static_foo(1)

A.static_foo('hi')
# executing static_foo(hi)
```

可以认为`foo`是实例方法，`class_foo`是类方法，而`static_foo`是静态方法

+ `foo` 会隐式传递参数`self`，`self`是当前调用这个方法的实例: `a`

+ `class_foo` 会隐式传递参数`cls`，`cls`是当前调用这个方法的类: `A`

+ `static_foo` 什么都没有，显示传递给它什么参数它就有什么，可以看成普通的 module function
