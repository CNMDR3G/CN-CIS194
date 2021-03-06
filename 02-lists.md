<!--
Polymorphism and<br />Functional Programming Paradigms
-->
多态和函数式编程范式
======================================================

CIS 194 Week 2\
28 January, 2015

<!--
Additional Syntax
-->
其他语法
-----------------

<!--
The introduction in the first class meeting did not discuss local
variables. Here, we see a few examples of local variables in case these
constructs are useful for you in writing your homework solutions.
-->
第一节中没有介绍本地变量。现在，我们来看几个本地变量的例子，会对你们的作业有所帮助。

<!--
**`let` expressions**
-->
**`let` 表达式**

<!--
To define a local variable scoped over an expression, use `let`:
-->
用 `let` 来定义表达式范围内的本地变量：

```{.haskell}
strLength :: String -> Int
strLength []     = 0
strLength (_:xs) = let len_rest = strLength xs in
                   len_rest + 1
```

<!--
In this case, the use of the local variable is a little silly (better
style would just be `1 + strLength xs`), but it demonstrates the use of
`let`. Don’t forget the `in` after you’ve defined your variable!
-->
这个例子中的本地变量有点多余（较好的写法是 `1 + strLength xs`），但是足够演示
`let` 的用法，不要忘了变量定义之后的 `in`！

<!--
**`where` clauses**
-->
**`where` 从句**

<!--
To define a local variable scoped over multiple guarded branches, use
`where`:
-->
用 `where` 来定义多个分支范围内的本地变量：

```{.haskell}
frob :: String -> Char
frob []  = 'a'   -- len is NOT in scope here
frob str
  | len > 5   = 'x'
  | len < 3   = 'y'
  | otherwise = 'z'
  where
    len = strLength str
```

<!--
Note that the `len` variable can be used in any of the alternatives
immediately above the `where` clause, but not in the separate top-level
pattern `frob [] = 'a'`. In idiomatic Haskell code, `where` is somewhat
more common than `let`, because using `where` allows the programmer to
get right to the point in defining what a function does, instead of
setting up lots of local variables first.
-->
注意变量 `len` 可以在 `where` 上方的各个选择分支内使用，但是不能在另一个顶层定义
`frob [] = 'a'` 中使用。比起 `let`，Haskell 中更常使用 `where`，
因为它可以让程序员第一次看到函数时，首先关注函数本身做了什么，而不是先看到一堆本地变量的定义。

<!--
**Haskell Layout**
-->
**Haskell 的布局**

<!--
Haskell is a *whitespace-sensitive* language. This is in stark contrast
to most other languages, where whitespace serves only to separate
identifiers. (Haskell shares this trait with Python, which is also
whitespace-sensitive.) Haskell uses indentation level to tell where
certain regions of code end, and where new statements appear. The basic
idea is that, when a so-called *layout herald* appears, GHC looks at the
next thing it sees and remembers its indentation level. A later line
that begins at the exact same indentation level is considered another
member of the group, and a later line that begins at a lesser (more to
the left) indentation level is not part of the group.
-->
Haskell 是*对空白字符敏感*的语言，这和其他大多数仅把空白字符用来分割标示符的语言形成鲜明对比。
（这点 Haskell 和 Python 相似。）Haskell 中缩进层次指示了代码块结束和新语句开始的位置。
基本上，当一个所谓的*布局暗示*出现的时候，GHC 会看下一个位置并记住其缩进层次。
如果下一行缩进相同则被认为是同一组代码，如果下一行缩进更少则不认为是同一组。

<!--
The layout heralds are `where`, `let`, `do`, `of`, and `case`. Because
Haskell modules begin with `module Name where`, that means that the
layout rule is in effect over the declarations in the file. This means
that the following is no good:
-->
布局暗示包括 `where`、`let`、`do`、`of` 和 `case`。
Haskell 模块总是以 `module Name where` 开头，表明布局规则对整个文件里的定义都起效。
所以下面这样的定义有误：

```{.haskell}
x :: Int
x =
5
```

<!--
The problem is that the `5` is at the same indentation level (zero) as
other top-level declarations, and so GHC considers it to be a new
declaration instead of part of the definition of `x`.
-->
问题出在 `5` 和其他顶层定义缩进相同（零缩进），所以 GHC 认为这是一个新的定义而不是 `x` 定义的一部分。

<!--
The layout rule is often a source of confusion for newcomers to Haskell.
But, if you get stuck, return to this decription (or, any of the many
online) and re-read — often, if you think carefully enough about it,
you’ll see what’s going on.
-->
布局规则常常给 Haskell 新手带来困扰。如果你在以后遇到麻烦，回来重新看这里（或者其他网络资料）——
通常，多仔细想一想你就明白是怎么一回事了。

<!--
When calculating indentation level, tabs in code (you don’t have any of
these, do you?!?) are considered with tab stops 8 characters apart,
regardless of what your editor might show you. This potential confusion
is why tabs are a terrible, terrible idea in Haskell code.
-->
在计算缩进层次的时候，代码中的制表符（你没写对吧？！？）被认为是 8 个字符的长度，
而不一定是编辑器显示给你的长度。这种潜在的混乱使得制表符在 Haskell 缩进中被认为是很不好的用法。

<!--
**Accumulators**
-->
**累加器**

<!--
Haskell’s one way to repeat a computation is recursion. Recursion is a
natural way to express the solutions to many problems. However,
sometimes a problem’s structure doesn’t exactly match Haskell’s
structure. For example, say we have a list of numbers, that is, an
`[Int]`. We wish to sum the elements in the list, but only until the sum
is greater than 20. After that, the rest of the numbers should be
ignored. Because recursion over a list builds up the result from the end
backward, a naive recursion will not work for us. What we need is to
keep track of the running sum as we go deeper into the list. This
running sum is called an *accumulator*.
-->

Haskell 中重复给定计算的方法之一是递归。递归也是解决很多问题的最自然的解法。
但是有时候问题的结构并不完全符合 Haskell 的结构。比如我们有一组数字的列表 `[Int]`。
我们想累加列表中数字的和，但是超过 20 就停止，忽略之后的数字。
因为列表上的递归是从后向前计算结果的，所以通常的递归并不符合我们的要求。
随着列表的深入，我们需要即时跟踪当前的和，这个和就叫做*累加器*。

<!--
Here is the code that solves the stated problem:
-->
这是解决上面问题的代码：

```{.haskell}
sumTo20 :: [Int] -> Int
sumTo20 nums = go 0 nums   -- the acc. starts at 0
  where go :: Int -> [Int] -> Int
        go acc [] = acc   -- empty list: return the accumulated sum
        go acc (x:xs)
         | acc >= 20 = acc
         | otherwise = go (acc + x) xs

sumTo20 [4,9,10,2,8] == 23
```

<!--
*Parametric* polymorphism
-->
*参数*多态
-------------------------

<!--
One important thing to note about polymorphic functions is that **the
caller gets to pick the types**. When you write a polymorphic function,
it must work for every possible input type. This – together with the
fact that Haskell has no way to directly make make decisions based on
what type something is – has some interesting implications.
-->
多态函数的一个重要的特点是**调用者决定其类型**。
当你写一个多态函数时，它应该对所有可能的输入类型都工作。
这连同 Haskell 无法只根据某表达式的类型直接做决定的事实，产生了一些有趣的意味（？）。

<!--
For starters, the following is very bogus:
-->
对初学者来说，下面的代码很*假*:

```{.haskell}
bogus :: [a] -> Bool
bogus ('X':_) = True
bogus _       = False
```

<!--
It’s bogus because the definition of `bogus` assumes that the input is a
`[Char]`. The function does not make sense for *any* value of the type
variable `a`. On the other hand, the following is just fine:
-->
*假*是因为 `bogus` 的定义实际上假定了输入是 `[Char]`。
这个函数并不能对*任意*类型的 `a` 都奏效。
相反，下面的代码则没有问题：

```{.haskell}
notEmpty :: [a] -> Bool
notEmpty (_:_) = True
notEmpty []    = False
```

<!--
The `notEmpty` function does not care what `a` is. It will always just
make sense.
-->
`notEmpty` 函数并不关心 `a` 是什么就能工作。

<!--
This “not caring” is what the “parametric” in parametric polymorphism
means. All Haskell functions must be parametric in their type
parameters; the functions must not care or make decisions based on the
choices for these parameters. A function can’t do one thing when `a` is
`Int` and a different thing when `a` is `Bool`. Haskell simply provides
no facility for writing such an operation. This property of a langauge
is called *parametricity*.
-->
这种“不关心”就是参数多态中“参数化（parametric）”的含义。
所有的 Haskell 函数实现对于它的类型都必须是参数化的；函数不能介意或者基于这些类型参数做选择。
函数不能在 `a` 是 `Int` 时做一种事，而在 `a` 是 `Bool` 时做另一种事。
Haskell 不允许这样。这种语言特性叫做*参态（parametricity）*。

<!--
There are many deep and profound consequences of parametricity. One
consequence is something called *type erasure*. Because a running
Haskell program can never make decisions based on type information, all
the type information can be dropped during compilation. Despite how
important types are when writing Haskell code, they are completely
irrelevant when running Haskell code. This property gives Haskell a huge
speed boost when compared to other languages, such as Python, that need
to keep types around at runtime. (Type erasure is not the only thing
that makes Haskell faster, but Haskell is sometimes clocked at 20x
faster than Python.)
-->
参态有一些很深刻的意义。其中之一叫做*类型擦除*。
因为 Haskell 程序运行的时候不能再根据类型信息做决定，所以所有的类型信息在编译期间就可以被丢弃掉了。
不管类型对于 Haskell 代码来说多么重要，他们和运行中的程序都没有关系。
这个特性给 Haskell 带来了相比其他需要在运行时保留类型信息的语言（比如 Python）巨大的速度提升。
（类型擦除并不是唯一让 Haskell 比其他语言更快的方法，但 Haskell 有时候能比 Python 快 20 倍。）

<!--
Another consequence of parametricity is that it restricts what
polymorphic functions you can write. Look at this type signature:
-->
参态的另一个影响是它限制了多态函数的实现。例如下面的类型签名：

```{.haskell}
strange :: a -> b
```

<!--
The `strange` function takes a value of some type `a` and produces a
value of another type `b`. But, crucially, it isn’t allowed to care what
`a` and `b` are! Thus, *there is no way to write `strange`*!
-->
`strange` 函数获得一个类型是 `a` 的东西返回另一个类型是 `b` 的东西。
但是关键是，它不能得知 `a` 和 `b` 具体是什么。*所以根本没有办法写出这样的 `strange`！*

```{.haskell}
strange = error "impossible!"
```

<!--
(The function `error`, defined in the `Prelude`, aborts your program
with a message.)
-->
（`Prelude` 中定义的 `error` 函数可以终止整个程序并显示指定信息。）

<!--
What about
-->
再来看看

```{.haskell}
limited :: a -> a
```

<!--
That function must produce an `a` when given an `a`. There is only one
`a` it can produce – the one it got! Thus, there is only one possible
definition for `limited`:
-->
这个函数对于给定的 `a` 返回 `a`。只有唯一的 `a` 它能产生，就是它获得的那个！
所以 `limited` 只可能有一种实现：

```{.haskell}
limited x = x
```

<!--
In general, given the type of a function, it is possible to figure out
various properties of the function just by thinking about parametricity.
The function must have *some* way of producing the output type… but
where could values of that type come from? By answering this question,
you can learn a lot about a function.
-->
总的来说，给定一个函数的类型，只根据参态就可以推断出该函数的很多特性。
函数可以有*多种*产生输出值的方式，但是给定输出类型的值应从何而来？
通过试图回答这个问题，可以获得对函数的一些了解。

<!--
Total and partial functions
-->
Total 函数和 partial 函数
---------------------------

<!--
Consider this polymorphic type:
-->
考虑下面的多态类型：

```{.haskell}
[a] -> a
```

<!--
What functions could have such a type? The type says that given a list
of things of type `a`, the function must produce some value of type `a`.
For example, the Prelude function `head` has this type.
-->
什么样的函数有这样的类型？这个类型说明了给定一个 `a` 的列表，函数必须产生一个类型为 `a` 的值。
例如，Prelude 里的函数 `head` 即是此类型。

```{.haskell}
[a] -> a
```

<!--
It crashes! There’s nothing else it possibly could do, since it must
work for *all* types. There’s no way to make up an element of an
arbitrary type out of thin air.
-->
糟糕！好像除此之外没有别的选择了，因为这个函数必须能对*所有*类型工作。
没有办法凭空造出来一个任意类型的值。

<!--
`head` is what is known as a *partial function*: there are certain
inputs for which `head` will crash. Functions which have certain inputs
that will make them recurse infinitely are also called partial.
Functions which are well-defined on all possible inputs are known as
*total functions*.
-->
`head` 就是俗称的*partial 函数*：对于某些输入不能工作。
函数在某些输入上会无限递归也称做 partial。
函数在所有可能的输入上都有良好的定义叫做*total 函数*。

<!--
It is good Haskell practice to avoid partial functions as much as
possible. Actually, avoiding partial functions is good practice in *any*
programming language—but in most of them it’s ridiculously annoying.
Haskell tends to make it quite easy and sensible.
-->
好的 Haskell 实践当然是尽量避免 partial 函数。
这也是*任何*编程语言中的良好实践 —— 但是在决大多数语言中非常麻烦。
而在 Haskell 中往往简单又合理。

<!--
**`head` is a mistake!** It should not be in the `Prelude`. Other
partial `Prelude` functions you should almost never use include `tail`,
`init`, `last`, and `(!!)`. From this point on, using one of these
functions on a homework assignment will lose style points!
-->
**`head` 是个错误！**它不应该存在 `Prelude` 中。
其他你应该尽力避免的 Prelude 中的 partial 函数包括 `tail`、`init`、`last` 和 `(!!)`。
从现在开始在作业中使用其中任意一个都会丢掉样式分！

<!--
What to do instead?
-->
那应该怎么做？

<!--
**Replacing partial functions**
-->
**替换 partial 函数**

<!--
Often partial functions like `head`, `tail`, and so on can be replaced
by pattern-matching. Consider the following two definitions:
-->
像 `head`、`tail` 等等 partial 函数常常可以被模式匹配取代。比如下面两个定义：

```{.haskell}
doStuff1 :: [Int] -> Int
doStuff1 []  = 0
doStuff1 [_] = 0
doStuff1 xs  = head xs + (head (tail xs))

doStuff2 :: [Int] -> Int
doStuff2 []        = 0
doStuff2 [_]       = 0
doStuff2 (x1:x2:_) = x1 + x2
```

<!--
These functions compute exactly the same result, and they are both
total. But only the second one is *obviously* total, and it is much
easier to read anyway.
-->
这两个函数做的同样的事，而且也都是 total 的。但是只有第二个*显然*是 total 的，而且更易读。

<!--
Recursion patterns
-->
递归模式
------------------

<!--
What sorts of things might we want to do with an `[a]`? Here are a few
common possibilities:

-   Perform some operation on every element of the list

-   Keep only some elements of the list, and throw others away, based on
    a test

-   “Summarize” the elements of the list somehow (find their sum,
    product, maximum…).

-   You can probably think of others!
-->

对于 `[a]` 我们会做什么？有几种可能：

-   对列表中的每一个元素做某种操作

-   基于某种测试，只保留一些元素，丢掉其他的

-   对所有元素做“总结”（比如求和、求积、求最大值）

-   你能想到的其他的！

<!--
**Map**
-->
**映射（Map）**

<!--
Let’s think about the first one (“perform some operation on every
element of the list”). For example, we could add one to every element in
a list:
-->
让我们来考虑第一种情况（对列表中的每一个元素做某种操作）。
比如我们可以对列表中的每一个元素加一：

```{.haskell}
addOneToAll :: [Int] -> [Int]
addOneToAll []     = []
addOneToAll (x:xs) = x + 1 : addOneToAll xs
```

<!--
Or we could ensure that every element in a list is nonnegative by taking
the absolute value:
-->
或者对每一个取绝对值得到一个非负的列表：

```{.haskell}
absAll :: [Int] -> [Int]
absAll []     = []
absAll (x:xs) = abs x : absAll xs
```

<!--
Or we could square every element:
-->
或者对每一个平方：

```{.haskell}
squareAll :: [Int] -> [Int]
squareAll []     = []
squareAll (x:xs) = x^2 : squareAll xs
```

<!--
At this point, big flashing red lights and warning bells should be going
off in your head. These three functions look way too similar. There
ought to be some way to abstract out the commonality so we don’t have to
repeat ourselves!
-->
现在，你脑中应该有红灯作闪警报乱响了。
这几个函数这么相像，应该有什么办法把这种共性抽象出来，省去我们的重复工作。

<!--
There is indeed a way—can you figure it out? Which parts are the same in
all three examples and which parts change?
-->
确实有这么一种办法。你有没有看出来，这三个例子里哪些部分是相同的，哪些部分变化了？

<!--
The thing that changes, of course, is the operation we want to perform
on each element of the list. We can specify this operation as a
*function* of type `a -> a`. Here is where we begin to see how
incredibly useful it is to be able to pass functions as inputs to other
functions!
-->
变化的，当然是我们对每个元素做的操作。我们可以把这个操作特化为一个类型为 `a -> a` 的函数。
现在我们看到了把函数当做函数的输入的大用途！

```{.haskell}
map :: (a -> b) -> [a] -> [b]
map _ []     = []
map f (x:xs) = f x : map f xs
```

<!--
We can now use `mapIntList` to implement `addOneToAll`, `absAll`, and
`squareAll`:
-->
现在我们可以用 `map` 来实现 `addOneToAll`、`absAll` 和 `squareAll`:

```{.haskell}
exampleList = [-1, 2, 6]

map (+1) exampleList
map abs  exampleList
map (^2) exampleList
```

<!--
**Filter**
-->
**过滤（Filter）**

<!--
Another common pattern is when we want to keep only some elements of a
list, and throw others away, based on a test. For example, we might want
to keep only the positive numbers:
-->
另一种常见的模式是，我们只想根据某种测试保留列表中的部分元素，扔掉其他的。
比如我们只想保留所有的正数：

```{.haskell}
keepOnlyPositive :: [Int] -> [Int]
keepOnlyPositive [] = []
keepOnlyPositive (x:xs) 
  | x > 0     = x : keepOnlyPositive xs
  | otherwise = keepOnlyPositive xs
```

<!--
Or only the even ones:
-->
或者只保留所有的偶数：

```{.haskell}
keepOnlyEven :: [Int] -> [Int]
keepOnlyEven [] = []
keepOnlyEven (x:xs)
  | even x    = x : keepOnlyEven xs
  | otherwise = keepOnlyEven xs
```

<!--
How can we generalize this pattern? What stays the same, and what do we
need to abstract out?
-->
如何抽象这种模式？哪一部分是不变的，需要抽象出来？

<!--
The thing to abstract out is the *test* (or *predicate*) used to
determine which values to keep. A predicate is a function of type
`a -> Bool` which returns `True` for those elements which should be
kept, and `False` for those which should be discarded. So we can write
`filterIntList` as follows:
-->
需要抽象出来的应是用来决定哪些值该保留下来的*测试*（或者说*断言*）这部分。
断言是一个类型为 `a -> Bool` 的函数，对应当保留的值返回 `True`，应当忽略的值返回 `False`。
<!--然后我们可以改写 `filterIntList` 如下：-->

```{.haskell}
filter :: (a -> Bool) -> [a] -> [a]
filte _ [] = []
filter p (x:xs)
  | p x       = x : filter p xs
  | otherwise = filter p xs
```

<!--
**Fold**
-->
**折叠（Fold）**

<!--
We have one more recursion pattern on lists to talk about: folds. Here
are a few functions on lists that follow a similar pattern: all of them
somehow “combine” the elements of the list into a final answer.
-->
还有一个列表上的递归模式我们还没有说到：折叠。下面是几个模式相似的列表上的函数：
所有函数都试图“结合”列表中的所有元素来得到一个值。

```{.haskell}
sum' :: [Int] -> Int
sum' []     = 0
sum' (x:xs) = x + sum' xs

product' :: [Int] -> Int
product' [] = 1
product' (x:xs) = x * product' xs

length' :: [a] -> Int
length' []     = 0
length' (_:xs) = 1 + length' xs
```


<!--
What do these three functions have in common, and what is different? As
usual, the idea will be to abstract out the parts that vary, aided by
the ability to define higher-order functions.
-->
这几个函数有什么共同点又有什么不同？像刚才一样，我们想用高阶函数来把变化的部分抽象出来。

```{.haskell}
fold :: (a -> b -> b) -> b  -> [a] -> b
fold f z []     = z
fold f z (x:xs) = f x (fold f z xs)
```

<!--
Notice how `fold` essentially replaces `[]` with `z` and `(:)` with `f`,
that is,
-->
注意到 `fold` 中把 `[]` 替换为 `z`，把 `(:)` 替换为 `f`，即

    fold f z [a,b,c] == a `f` (b `f` (c `f` z))

<!--
(If you think about `fold` from this perspective, you may be able to
figure out how to generalize `fold` to data types other than lists…)
-->
从这个角度来看，你可能就知道如何推广 `fold` 到除了列表之外的其他数据结构上了。

<!--
Now let’s rewrite `sum'`, `product'`, and `length'` in terms of `fold`:
-->
下面，我们来用 `fold` 重写一下 `sum'`、`product'` 和 `length'`：

```{.haskell}
sum''     = fold (+) 0
product'' = fold (*) 1
length''  = fold addOne 0
 where addOne _ s = 1 + s
```

<!--
Of course, `fold` is already provided in the standard Prelude, under the
name
[`foldr`](http://haskell.org/ghc/docs/latest/html/libraries/base/Prelude.html#v:foldr).
Here are some Prelude functions which are defined in terms of `foldr`:
-->
当然 `fold` 已经在 `Prelude` 中了，叫做
[`foldr`](http://haskell.org/ghc/docs/latest/html/libraries/base/Prelude.html#v:foldr)。
下面是一些 `Prelude` 中用 `foldr` 定义了的函数：

-   `length :: [a] -> Int`
-   `sum :: Num a => [a] -> a`
-   `product :: Num a => [a] -> a`
-   `and :: [Bool] -> Bool`
-   `or :: [Bool] -> Bool`
-   `any :: (a -> Bool) -> [a] -> Bool`
-   `all :: (a -> Bool) -> [a] -> Bool`

<!--
There is also
[`foldl`](http://haskell.org/ghc/docs/latest/html/libraries/base/Prelude.html#v:foldl),
which folds “from the left”. That is,
-->
Prelude 还有一个
[`foldl`](http://haskell.org/ghc/docs/latest/html/libraries/base/Prelude.html#v:foldl),
表示 “从左向右” 折叠，即

    foldr f z [a,b,c] == a `f` (b `f` (c `f` z))
    foldl f z [a,b,c] == ((z `f` a) `f` b) `f` c

<!--
In general, however, you should use [`foldl'` from
`Data.List`](http://haskell.org/ghc/docs/latest/html/libraries/base/Data-List.html#v:foldl)
instead, which does the same thing as `foldl` but is more efficient.
-->
但一般情况下，你应该使用
[`Data.List` 中的 `foldl'`](http://haskell.org/ghc/docs/latest/html/libraries/base/Data-List.html#v:foldl)
代替 `foldl`。它们做的事情是一样的，但前者更高效。

<!--
Functional Programming
-->
函数式编程
----------------------

<!--
We have seen now several cases of using a functional programming style.
Here, we will look at several functions using a very functional style to
help you get acclimated to this mode of programming.
-->
我们已经见过不少函数式编程的例子了。
为了更加适应这种编程的方式，我们现在来看看几个非常具有函数式风格的函数。

<!--
**Functional combinators**
-->
**函数组合子**

<!--
First, we need a few more combinators to get us going:
-->
首先，我们还需要几个组合子：

```{.haskell}
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)
```

<!--
The `(.)` operator, part of the Haskell Prelude, is just function
composition. Say we want to take every element of a list and add 1 and
then multiply by 4. Here is a good way to do it:
-->
Prelude 中的 `(.)` 操作符即是函数的组合。
比如我们想要把列表中的每个元素加一然后乘以四，可以这样做：

```{.haskell}
add1Mul4 :: [Int] -> [Int]
add1Mul4 x = map ((*4) . (+1)) x
```

<!--
While we’re at it, we should also show the `($)` operator, which has a
trivial-looking definition:
-->
同时，我们也来看看 `($)` 操作符，它的定义很简单：

```{.haskell}
($) :: (a -> b) -> a -> b
f $ x = f x
```

<!--
Why have such a thing? Because `($)` is parsed as an operator, and this
is useful for avoiding parentheses. For example, if we wish to negate
the number of even numbers in a list, we could say
-->
为什么需要这个？因为 `($)` 是一个操作符，可以用来避免写很多括号。
例如，我们想得到列表中的偶数的个数的负数，可以这样写

```{.haskell}
negateNumEvens1 :: [Int] -> Int
negateNumEvens1 x = negate (length (filter even x))
```

<!--
or
-->
或者这样

```{.haskell}
negateNumEvens2 :: [Int] -> Int
negateNumEvens2 x = negate $ length $ filter even x
```

<!--
No more parentheses!
-->
少写很多括号呢！

**Lambda**

<!--
It is sometimes necessary to create an anonymous function, or *lambda
expression*. This is best explained by example. Say we want to duplicate
every string in a list:
-->
有时候我们需要创建匿名的函数，即*lambda 表达式*。用例子来说明，比如我们想重复列表中的所有字符串：

```{.haskell}
duplicate1 :: [String] -> [String]
duplicate1 = map dup
  where dup x = x ++ x
```

<!--
It’s a tiny bit silly to name `dup`. Instead, we can make an anonymous
function:
-->
单独给 `dup` 起个名字有点多余。其实，我们可以写成匿名函数：

```{.haskell}
duplicate2 :: [String] -> [String]
duplicate2 = map (\x -> x ++ x)
```

<!--
The backslash binds the variables after it in the expression that
follows the `->`. For anything but the shortest examples, it’s better to
use a named helper function, though.
-->
反斜线后面的变量名被绑定在了 `->` 后面的表达式里。不过，长一些的函数还是起个名字最好。

<!--
Currying and Partial Application
-->
柯里化（currying）和部分应用
--------------------------------

<!--
Remember how the types of multi-argument functions look weird, like they
have “extra” arrows in them? For example, consider the function
-->
还记得么，多参数函数的类型看起来有点儿奇怪，其中有很多“多余的”箭头？比如这个函数

```{.haskell}
f :: Int -> Int -> Int
f x y = 2*x + y
```

<!--
I promise that there is a beautiful, deep reason for this, and now it’s
finally time to reveal it: *all functions in Haskell take only one
argument*. Say what?! But doesn’t the function `f` shown above take two
arguments? No, actually, it doesn’t: it takes one argument (an `Int`)
and *outputs a function* (of type `Int -> Int`); that function takes one
argument and returns the final answer. In fact, we can equivalently
write `f`’s type like this:
-->
我曾经说过这其中是有优美深刻的原因的，现在终于是时间揭晓了：
*其实所有的 Haskell 中的函数都只有一个参数*。
什么<!--鬼-->？！上面这个函数 `f` 不是就有两个参数吗？
其实不是：它得到第一个参数（`Int`）然后返回了另一个函数（类型为 `Int -> Int`）；
而这个函数再得到另一个参数才返回最终的结果。
事实上我们可以把 `f` 的类型写成这样：

```{.haskell}
f' :: Int -> (Int -> Int)
f' x y = 2*x + y
```

<!--
In particular, note that function arrows *associate to the right*, that
is, `W -> X -> Y -> Z` is equivalent to `W -> (X -> (Y -> Z))`. We can
always add or remove parentheses around the rightmost top-level arrow in
a type.
-->
需要指出的是，类型中的箭头是*向右结合*的，`W -> X -> Y -> Z` 等价于 `W -> (X -> (Y -> Z))`。
类型中最右顶层的的括号去掉也没有关系。

<!--
Function application, in turn, is *left*-associative. That is, `f 3 2`
is really shorthand for `(f 3) 2`. This makes sense given what we said
previously about `f` actually taking one argument and returning a
function: we apply `f` to an argument `3`, which returns a function of
type `Int -> Int`, namely, a function which takes an `Int` and adds 6 to
it. We then apply that function to the argument `2` by writing
`(f 3) 2`, which gives us an `Int`. Since function application
associates to the left, however, we can abbreviate `(f 3) 2` as `f 3 2`,
giving us a nice notation for `f` as a “multi-argument” function.
-->
反过来，函数应用是*左*结合的。`f 3 2` 其实是 `(f 3) 2` 的简写。
这么说来我们之前说的 `f` 其实只需要一个参数然后返回另一个函数就合理了：
我们先把 `f` 应用在参数 `3` 上，得到一个类型为 `Int -> Int` 的函数，即一个对整数加六的函数。
然后把这个函数应用在参数 `2` 上，写作 `(f 3) 2`，最后得到一个整数。
因为函数应用是左结合的，所以我们可以把 `(f 3) 2` 缩写为 `f 3 2`，
看起来 `f` 就像一个“多参数”的函数一样。

<!--
The “multi-argument” lambda abstraction
-->
“多参数”的 lambda

```{.haskell}
\x y z -> ...
```

<!--
is really just syntax sugar for
-->
其实只是

```{.haskell}
\x -> (\y -> (\z -> ...))
```

的语法糖。

<!--
Likewise, the function definition
-->
同样，下面的定义

```{.haskell}
f x y z = ...
```

<!--
is syntax sugar for
-->
也是

```{.haskell}
f = \x -> (\y -> (\z -> ...)).
```

的语法糖。

<!--
This idea of representing multi-argument functions as one-argument
functions returning functions is known as *currying*, named for the
British mathematician and logician Haskell Curry. (His first name might
sound familiar; yes, it’s the same guy.) Curry lived from 1900-1982 and
spent much of his life at Penn State—but he also helped work on ENIAC at
UPenn. The idea of representing multi-argument functions as one-argument
functions returning functions was actually first discovered by Moses
Schönfinkel, so we probably ought to call it *schönfinkeling*. Curry
himself attributed the idea to Schönfinkel, but others had already
started calling it “currying” and it was too late.
-->
把多参数函数表示为单参数并返回函数的函数叫做*柯里化（currying）*，以英国数学和逻辑学家 Haskell Curry 命名。
（他的名字我们应该很熟悉，对，就是他。）柯里生于 1900 年逝于 1982 年，在宾州度过了他的大部分时光。
把多参数函数表示为单参数并返回函数的函数的想法其实首先是 Moses Schönfinkel 提出的，
所以可能更应该叫做 *schönfinkeling*。
柯里自己也指出这个想法来源于 schönfinkel，但是太晚了，别人早已经开始称其为 “currying” 了。

<!--
If we want to actually represent a function of two arguments we can use
a single argument which is a tuple. That is, the function
-->
如果我们实在想表示一个有两个参数的函数，我们可以用一个元祖（tuple）来当参数。即

```{.haskell}
f'' :: (Int,Int) -> Int
f'' (x,y) = 2*x + y
```

<!--
can also be thought of as taking “two arguments”, although in another
sense it really only takes one argument which happens to be a pair. In
order to convert between the two representations of a two-argument
function, the standard library defines functions called `curry` and
`uncurry`, defined like this (except with different names):
-->
这个函数可以看做有“两个”参数，尽管从某种意义上来说，它有的只是“一对”参数。
标准库里的 `curry` 和 `uncurry` 两个函数提供了这两种表达方式之间的转换：

```{.haskell}
curry :: ((a,b) -> c) -> a -> b -> c
curry f x y = f (x,y)

uncurry :: (a -> b -> c) -> (a,b) -> c
uncurry f (x,y) = f x y
```

<!--
`uncurry` in particular can be useful when you have a pair and want to
apply a function to it. For example:
-->
当你有一个元祖对，想把它应用在一个函数上时，`uncurry` 就非常有用了。比如：

    Prelude> uncurry (+) (2,3)
    5

<!--
**Partial application**
-->
**部分应用**

<!--
The fact that functions in Haskell are curried makes *partial
application* particularly easy. The idea of partial application is that
we can take a function of multiple arguments and apply it to just *some*
of its arguments, and get out a function of the remaining arguments. But
as we’ve just seen, in Haskell there *are no* functions of multiple
arguments! Every function can be “partially applied” to its first (and
only) argument, resulting in a function of the remaining arguments.
-->
Haskell 的函数都是已经柯里化了的，这使得*部分应用*变得非常简单。
部分应用的意思是指，我们把一个多参数的函数只应用到*一部分*参数上，得到一个可以应用剩余参数的函数。
但是我们刚刚已经见过了，Haskell 中从来*没有*多参数的函数！
每一个函数都可以（并只能）被“部分应用”在它的第一个参数上，得到一个可以应用剩余参数的函数。

<!--
Note that Haskell doesn’t make it easy to partially apply to an argument
other than the first. The one exception is infix operators, which as
we’ve seen, can be partially applied to either of their two arguments
using an operator section. In practice this is not that big of a
restriction. There is an art to deciding the order of arguments to a
function to make partial applications of it as useful as possible: the
arguments should be ordered from “least to greatest variation”, that is,
arguments which will often be the same should be listed first, and
arguments which will often be different should come last.
-->
我们注意到在 Haskell 里部分应用除了第一个参数之外的参数就不那么容易了，除非使用中缀操作符。
我们已经见过，通过操作符域，中缀操作符可以被部分应用在它的两个参数任意一个上面。
所以在实际应用中这并不是什么限制了。
函数的参数的顺序也是有讲究的，要使得部分应用越方便越好：参数的顺序应服从“最小变化到最可能变化”。
即，不大会变的参数放在前面，时常变化的参数放在后面。

<!--
**Wholemeal programming**
-->
**全麦编程**

<!--
Let’s put some of the things we’ve just learned together in an example
that also shows the power of a “wholemeal” style of programming.
Consider the function `foobar`, defined as follows:
-->
让我们来把刚学过的东西都放到一个例子里来，显示一下“全麦”风格的编程的威力。
比如如下定义的 `foobar` 函数：

```{.haskell}
foobar :: [Integer] -> Integer
foobar []     = 0
foobar (x:xs)
  | x > 3     = (7*x + 2) + foobar xs
  | otherwise = foobar xs
```

<!--
This seems straightforward enough, but it is not good Haskell style. The
problem is that it is

-   doing too much at once; and
-   working at too low of a level.

Instead of thinking about what we want to do with each element, we can
instead think about making incremental transformations to the entire
input, using the existing recursion patterns that we know of. Here’s a
much more idiomatic implementation of `foobar`:
-->

看起来足够直白，但这并不是最好的 Haskell 风格。问题出在：

-   同时做了太多事；
-   过于低层。

我们可以使用现有的几个递归模式，在整个输入上做增量变换，而不是考虑对每一个元素做什么。
下面是一个更为常见的 `foobar` 的实现：

```{.haskell}
foobar' :: [Integer] -> Integer
foobar' = sum . map ((+2) . (*7)) . filter (>3)
```

<!--
This defines `foobar'` as a “pipeline” of three functions: first, we
throw away all elements from the list which are not greater than three;
next, we apply an arithmetic operation to every element of the remaining
list; finally, we sum the results.
-->
`foobar'` 被定义为三个函数串联的管道：
首先从列表中排除所有大于三的元素，然后对每个剩下的元素做算术操作，最后求和。

<!--
Notice that in the above example, `map` and `filter` have been partially
applied. For example, the type of `filter` is
-->
注意在上面的例子中，`map` 和 `filter` 都是被部分应用的。例如，`filter` 的类型为：

```{.haskell}
(a -> Bool) -> [a] -> [a]
```

<!--
Applying it to `(>3)` (which has type `Integer -> Bool`) results in a
function of type `[Integer] -> [Integer]`, which is exactly the right
sort of thing to compose with another function on `[Integer]`.
-->
应用在 `(>3)`(其类型为 `Integer -> Bool`)上，返回一个类型为 `[Integer] -> [Integer]` 的函数。
恰好能和另一个在 `[Integer]` 上的函数组合。

<!--
**Point-free Style**
-->
**Point-free 风格**

<!--
The style of coding in which we define a function without reference to
its arguments—in some sense saying what a function *is* rather than what
it *does*—is known as “point-free” style. As we can see from the above
example, it can be quite beautiful. Some people might even go so far as
to say that you should always strive to use point-free style; but taken
too far it can become extremely confusing. `lambdabot` in the `#haskell`
IRC channel has a command `@pl` for turning functions into equivalent
point-free expressions; here’s an example:
-->
这种定义一个函数而不具名其参数 —— 与其在说定义函数*是什么*，不如说在定义函数*做什么* —— 的风格常被称为 “point-free” 风格。
从上面的例子可以看出来，这种风格有时候非常优美。有些人可能会<!--渐行渐远-->认为无论什么时候都应该使用 point-free 风格；
但是过于追求这种风格反而会造成巨大的困惑。
IRC 频道 `#haskell` 中的 `lambdabot` 有一个命令是 `@pl`，可以把函数转化为等价的 point-free 表达式；下面是一个例子：

    @pl \f g x y -> f (x ++ g x) (g y)
    join . ((flip . ((.) .)) .) . (. ap (++)) . (.)

<!--
This is clearly *not* an improvement!
-->
这可*一点也没有*提升！

<!--
Consider the following two functions:
-->
再看下面两个函数：

```{.haskell}
mumble  = (`foldr` []) . ((:).)

grumble = zipWith ($) . repeat
```

<!--
Can you figure out what these functions do? What if I told you that they
are both equivalent to the `map` function. These are great examples of
how point-free style can be taken too far. For this reason, some people
refer to it as point-less style.
-->
你能明白他们在做什么吗？其实他们都等价于 `map`。
这些都是 point-free 风格过犹不及的例子。
所以有些人称之为 point-less（看不出要点）风格。

------------------------------------------------------------------------
