---
title: "Lucy's Algorithm + Fenwick Trees"
date: 2023-04-09
---

There are a lot of nice combinatorial algorithms for computing $$\pi(x)$$, the number of primes $$p \leq x$$. One very commonly implemented algorithm is the [Meissel-Lehmer algorithm][1], which runs in roughly $$O(x^{2/3})$$ time and either $$O(x^{2/3})$$ or $$O(x^{1/3})$$ space depending on if you go through the trouble to do segmented sieving, which can be complicated.

In fact I think the whole ML algorithm looks awfully complicated. This [exposition][2] by Lagarias, Miller, and Odlyzko gives a lot of detail for those who wish to try implementing it. I personally haven't tried to implement it myself yet. Mostly because the method I'm going to detail in this post has proven completely sufficient for me and much simpler to write.

I'm going to write this assuming that the reader hasn't seen either Lucy's algorithm nor Fenwick trees before. Feel free to skip over sections if it's not new to you - some of this information [already appears][5] in well written blogs elsewhere, but I really wanted to write about this myself.

## The Lucy_Hedgehog Algorithm

Named for Project Euler user Lucy_Hedgehog, this was actually originally an algorithm to compute the sum $$\sum_{p \leq x} p$$. You can find [her original post][3] about this in the forum threads for problem 10. The idea is to describe what happens in a [sieve of Eratosthenes][4] and use what some more people call the "square root trick".

In the sieve of Eratosthenes, one starts by initializing every integer from $$2$$ to $$x$$ as "maybe prime".

The smallest element in the sieve is now marked as definitely prime, and all of its multiples are eliminated from the sieve. This is repeated until all primes have been yanked out. If you couldn't write one of these sieves from memory, it would probably be helpful to your understanding to do some research into it, as Lucy's algorithm and the Eratosthenes sieve are conceptually very similar.

So, for each prime $$p \leq x$$, we would be iterating over all of its multiples, which gives us basically a runtime of $$\sum_{p \leq x} \frac{x}{p} \sim x \log \log x$$ (check out [Mertens' second theorem][6] if this is unfamiliar).

To turn this into a nice prime counting algorithm we define a function $$S(v, p)$$ which will be the number of integers $$n$$ in the range $$2 \leq n \leq v$$ remaining after sieving with all of the primes up to $$p$$. We start with $$S(v, 1) = v-1$$ since $$1$$ is never in the sieve.

Considering $$S(v, p)$$, we see that every integer we eliminate from the sieve is a multiple of $$p$$. Specifically (and you should check this by doing the sieve by hand!) the integers we eliminate are exactly $$p$$ times those remaining in the sieve that are between $$p$$ and $$v/p$$!

This leads us to the crucial formula

$$S(v, p) = S(v, p-1) - \left[S(v/p, p-1) - S(p-1, p-1)\right]$$

One more very important observation is that if $$p^2 > v$$, then $$S(v, p) = S(v, p-1)$$ - that is, we only actually need to sieve out the primes up to $$\sqrt{v}$$, after which we will have $$S(x, \sqrt{x}) = \pi(x)$$.

### Square Root Trick
The next important theoretical detail on the list relates to the "key values" $$v$$ which show up as arguments in a recursive implementation of $$S(v, p)$$. Since $$S(v, p) = S(\lfloor v \rfloor, p)$$, we should only consider integer arguments.

Part of the story here is the equality

$$\left \lfloor \frac{\lfloor x/m \rfloor}{n} \right \rfloor = \left \lfloor \frac{x}{mn} \right \rfloor$$

You should convince yourself of this - the left hand side is the largest integer $$k$$ such that $$kn \leq \lfloor x/m \rfloor$$. This is true if and only if $$kn \leq x/m$$, for which $$k$$ is maximized at $$\left \lfloor \frac{x}{mn} \right \rfloor$$.

So, with this knowledge in mind, each key value $$v$$ is just the floor of a bigger key value divided by an integer - hence the set of key values is the set of distinct values taken by $$\left \lfloor \frac{x}{n} \right \rfloor$$.

The "square root trick" describes exactly how many and which values that expression can take. It's closely related to Dirichlet's hyperbola method (described in [this blog post][7] and in section 3.5 of Apostol's _Introduction to Analytic Number Theory_). The idea is that if $$n \leq \sqrt{x}$$, all of the values $$\lfloor x/n \rfloor$$ will be distinct, and if $$n > \sqrt{x}$$ we will have $$\lfloor x/n \rfloor < \sqrt{x}$$. Therefore there are at most $$2\sqrt{x}$$ distinct key values to deal with, which is not so bad.

The following image shows a plot of $$10/n$$ (the blue line) and the values $$\lfloor 10/n \rfloor$$ as black points. The blue shaded section is for $$n \leq \sqrt{10}$$, and you can see that for $$n > \sqrt{10}$$ we have lots of repeated values due to the restriction $$10/n \leq \sqrt{10}$$.

<center><img src="/blog/docs/assets/images/2023-04-09-hyperbola.png" width="75%" height="75%"></center>

This trick is ubiquitous and used in a large variety of number theoretic summation techniques, for example in [this algorithm][8] to compute the partial sums of the totient function $$\varphi(n)$$ in $$O(x^{3/4})$$ time[^1].

### Data Structure Details

To implement Lucy's algorithm, then, it helps to have a nice container to store an `int64` at each key value `v` (where `x` is fixed and known). In my personal library I use a lightweight wrapper object which stores the following data:
- The value `x``
- The value `isqrt` defined as $$\lfloor \sqrt{x} \rfloor$$
- An array `arr` of length `L`, where $$L = 2\lfloor \sqrt{x} \rfloor$$, or if $$\left\lfloor \frac{x}{\lfloor \sqrt{x} \rfloor}\right\rfloor = \lfloor \sqrt{x}\rfloor$$ use $$L = 2\lfloor \sqrt{x} \rfloor-1$$

We will see why we sometimes need this lower value of `L` presently.

The strategy is to index the array by `1, 2, ..., isqrt, x div isqrt, x div (isqrt-1), ..., x`.  
This has a total length of `2*isqrt`. If we query the input `v`, we check if `v <= isqrt`. If it is, we return `arr[v-1]`, and otherwise return `arr[L-(x div v)]`.

For example, with $$x = 12$$ we have `isqrt == 3` and our array elements correspond to 

$$\left\{1, 2, 3, \left\lfloor\frac{12}{3}\right\rfloor, \left\lfloor\frac{12}{2}\right\rfloor,\left\lfloor\frac{12}{1}\right\rfloor\right\} = \left\{1, 2, 3, 4, 6, 12 \right\}$$

No issues here. Let's try with $$x = 10$$, where `isqrt = 3` again, but

$$\left\{1, 2, 3, \left\lfloor\frac{10}{3}\right\rfloor, \left\lfloor\frac{10}{2}\right\rfloor,\left\lfloor\frac{10}{1}\right\rfloor\right\} = \left\{1, 2, 3, 3, 5, 10 \right\}$$

This duplicate index would cause us a headache. Hence if at the boundary we have `isqrt == x div isqrt` we will omit that second value, giving us `L == 2*isqrt - 1` in that case. It's important to be careful about this both here and in other applications of the square root trick.

In the code, I'll be calling this container `FIArray` - standing for floor indexed array. There's no actual name for this but this one seems as good as any. Here's a simple implementation[^3] in [Nim][9] (note that `div` is floor division):

```nim
type FIArray = object
  ##Given x, stores a value at each distinct (x div n).
  x: int64
  isqrt: int64
  arr: seq[int64]

proc newFIArray(x: int64): FIArray =
  ##Initializes a new FIArray with result[v] = 0 for all v.
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc `[]`(S: FIArray, v: int64): int64 =
  ##Accesses S[v].
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`(S: var FIArray, v: int64, z: int64) =
  ##Sets S[v] = z.
  if v <= S.isqrt: S.arr[v-1] = z
  else: S.arr[^(S.x div v).int] = z

iterator keysInc(S: FIArray): int64 =
  ##Iterates over the key values of S in increasing order.
  for v in 1..S.isqrt: yield v
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for n in countdown(S.isqrt - 1, 1):
    yield S.x div n

iterator keysDec(S: FIArray): int64 =
  ##Iterates over the key values of S in decreasing order.
  for n in 1..(S.isqrt - 1):
    yield S.x div n
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for v in countdown(S.isqrt, 1): yield v
```

Nothing magical is happening here quite yet, it's just incredibly helpful to have these functions set up when we actually implement Lucy's algorithm. Speaking of, we can describe and implement it now -

### Algorithm (Lucy)
1. Initialize `S[v] = v-1` for each key value `v`.
2. For `p` in `2..sqrt(x)`,  
    2a. If `S[p] == S[p-1]`, then `p` is not a prime (_why?_) so increment `p` and try again.  
    2b. Otherwise, `p` is a prime - for each key value `v` satisfying `v >= p*p`, in _decreasing order_, update the value at `v` by  `S[v] -= S[v div p] - S[p-1]`.
3. Return `S`. Here, `S[v]` is the number of primes up to `v` for each key value `v`.

Why, in step 2b, do we have to update the array elements in decreasing order?

This is a side effect of us using a single array `S` to store `S[v, p]` for all keys `v` and `p <= isqrt`. There is a loop invariant here: after step 2b, `S[v] = S[v, p]`. During step 2b, part of the array should be `S[v, p]` and part of it should be `S[v, p-1]`. We have to be careful that when we update `S[v]` to equal `S[v, p]` that we will not need the value `S[v, p-1]` in the future, since it will be overwritten. The natural way to make sure of this is to simply update the highest `v` first, since any `S[v, p]` will only need to access `S[w, p-1]` for `w < p`.

I'm not sure if my explanation of this part in words is completely satisfactory, so here I've drawn a small dependency graph of `S[v, p]` for `x = 10`.

<center><img src="/blog/docs/assets/images/2023-04-09-dependency10.png" width="85%" height="85%"></center>

We see that each `S[v, p]` depends only on `S[w, p-1]` for `w <= v`.  
Also notice the curious `S[5, 2]` node which is not actually used to compute `S[10, 3]` - we can skip some work by not updating `S[5, 2]` at all! That's not immediately relevant but it is a key part of some algorithms which do _not_ produce every value $$\pi(v)$$ and only produce a provably correct value of $$\pi(x)$$.

For now, though, here's the incredibly simple Nim implementation of Lucy's algorithm:
```nim
proc pi(x: int64): FIArray =
  var S = newFIArray(x)
  for v in S.keysInc:
    S[v] = v-1
  for p in 2..S.isqrt:
    if S[p] == S[p-1]: continue
    #p is prime
    for v in S.keysDec:
      if v < p*p: break
      S[v] = S[v] - (S[v div p] - S[p-1])
  return S
```

Hopefully you can understand the allure of this prime counting method.

A quick benchmark tells us that we can compute $$\pi(10^{12}) = 37607912018$$ in only `7.3s` (on my machine). Since we only store about $$2\sqrt{x} = 2*10^6$$ values in our container, this also has fantastic memory usage. If we try running it at a few more powers of ten we get the following runtime data:


|x|pi(x)|Time (s)|
|:---:|:---:|:---:|
|10<sup>9</sup>|50847534|0.049|
|10<sup>10</sup>|455052511|0.259|
|10<sup>11</sup>|4118054813|1.370|
|10<sup>12</sup>|37607912018|7.259|
|10<sup>13</sup>|346065536839|39.198|
|10<sup>14</sup>|3204941750802|209.039|


Beyond $$10^{14}$$ we're a little too lazy to wait so long. Honestly, the algorithm described so far probably suffices for most uses in Project Euler, and even for $$10^{14}$$ you only need an array of length $$2*10^7$$ which is very reasonable. The inclusion of a Fenwick tree will also significantly increase memory requirements, from $$O(\sqrt{x})$$ to $$O(x^{2/3})$$ or so, but it will also give us a nice performance boost if you're able to spend a bit more on RAM.

## Fenwick / Binary Indexed Trees

A **Fenwick Tree** (also known as a **Binary Indexed Tree** or **BIT**) is a data structure which has been described in a [billion][10] [different][11] [places][12] in a lot of detail by [very smart computer scientists][13] who know a lot more than I do. Really - this thing has a plethora of uses, for example [counting inversions in an array][14], quickly calculating the index of a permutation among all permutations listed lexicographically[^2], and as you'll see soon, prime counting! Seriously, you should go read all the articles I just linked.

I'm only going to be lightly touching on how a Fenwick tree works, because I'd rather just use it as a black box here.

Suppose we have an array `a[1..n]` indexed from `1` to `n`.  
A standard Fenwick tree supports two operations:
- **Prefix sums**, which query `a[1] + a[2] + ... + a[i]` for some `i <= n`.
- **Updates**, which modify the array by `a[i] += c` for some `i <= n` and integer `c`.

On an ideal array, the first operation would take $$O(i)$$ time, and the second would take constant time.

In our applications we would like to perform the prefix sums quickly. One idea is to store the prefix sums instead of the base array - that way we can get the prefix sums in constant time. But then to update an element of the array we would have to modify $$O(n-i+1)$$ partial sums, and so the update operation gets as slow as the prefix operation once was.

A Fenwick tree balances the prefix and update operations - both will take $$O(\log n)$$ time, which is excellent.

The way this is done is by computing a bunch of range sums over many different overlapping intervals of the base array. It's done in such a way that 
- every prefix sum is composed of about $$O(\log n)$$ of the intervals we have pre-computed, and
- every element of the base array belongs to about $$O(\log n)$$ of the intervals we care about!

Thus, if we want to compute a prefix sum we just add up about $$O(\log n)$$ values, and to update an element of the base array we update about $$O(\log n)$$ range sums.

<center><img src="https://cp-algorithms.com/data_structures/binary_indexed_tree.png"></center>

Image source is [cp-algorithms.com][16].

It's all very nice in theory but sounds like it would be a bit annoying to implement. Fortunately you can essentially use the binary structure of computer memory to your benefit, which makes it _exceptionally_ simple to code:

```nim
type Fenwick[T] = object
  arr: seq[T]

proc newFenwick[T](len: int): Fenwick =
  result.arr.newSeq(len)

proc len[T](f: Fenwick[T]): int = f.arr.len

proc sum[T](f: Fenwick[T], i: SomeInteger): T =
  ##Returns f[0] + f[1] + ... + f[i]. Time O(log i).
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii>0:
    result += f.arr[ii-1]
    ii -= (ii and (-ii))

proc addTo[T](f: var Fenwick[T], i: SomeInteger, c: T) =
  ##Adds c to a single element of the base array. O(log i)
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii<=f.arr.len:
    f.arr[ii-1] += c
    ii += (ii and (-ii))

proc `[]`[T](f: Fenwick[T], i: SomeInteger): T =
  ##Accesses a single element of the base array. O(log i)
  if i==0: return f.sum(0)
  return f.sum(i) - f.sum(i-1)

proc `[]=`[T](f: var Fenwick[T], i: SomeInteger, x: T) =
  ##Sets a single element of the base array. O(log i)
  f.addTo(i, x-f[i])
```

This is a basic, barebones implementation of the structure, but it'll work great.  
I've also given it a generic type `T`, which will be `int` in our case. It's helpful to be able to use `int64` in case you want to do sums of primes later (you do).

It's possible to do a lot more than this with a Fenwick tree. For example, if you have a nontrivial initial state you'd like the base array to have, you can initialize the tree in linear time instead of updating each of the elements individually. It's explained in [this Codeforces blog by sdnr1][15].

For ease of use I'm going to use a slightly less general version of that method in which we create the Fenwick tree with a default value - every element of the base array equal to some constant `default`.

It looks like this:

```nim
proc newFenwick[T](len: int, default: T): Fenwick[T] =
  ##Initializes a fenwick tree with a constant array, f[i] = default for all i.
  result.arr.newSeq(len)
  for i in 0..<len:
    result.arr[i] = default
  for i in 1..len:
    var j = i + (i and (-i))
    if j<=len: 
      result.arr[j-1] += result.arr[i-1]
```

This is everything we need from the land of data structures to speed up Lucy's algorithm.

## Application of Fenwick Trees to Lucy's Algorithm

The way we trade memory for speed here is common to algorithms of this type.

Select some constant $$\sqrt{x} < y \leq x$$ as a parameter to be optimized later. We will be performing a standard Eratosthenes sieve up to $$y$$ _while_ updating our `FIArray` using the recursion we derived earlier for the key values $$v > y$$. If you've seen some of the faster methods for computing the totient summatory function, this will seem familiar. I am going to describe the algorithm next, and we will discover why Fenwick trees are needed here.

Initialize the Eratosthenes sieve as usual with all of the numbers from `2` to `y` marked as "maybe prime". At the same time initialize the `FIArray` for Lucy's algorithm as usual. Now for each of the $$O(x/y)$$ key values satisfying $$v \geq y$$ update the `FIArray` in the same way as in Lucy's algorithm. We will then proceed with a step of the sieve - identifying a prime `p` and eliminating all of its multiples from the sieve in $$O(y/p)$$ time.

The important bit to note here is that if the Lucy step sets `S[v, p] -= S[v div p, p-1] - S[p-1, p-1]` and either of `v div p` or `p-1` is at most `y`, then instead of using the value stored in the `FIArray` we need to compute the number of remaining integers in the Eratosthenes sieve. This is the application of the Fenwick tree - we can store a `1` if the integers is maybe prime and a `0` if it is definitely not prime, and then prefix sums compute the number of remaining integers up to some value.

Now that we know what's going to happen, here's the algorithm:

### Algorithm (Lucy + Fenwick)
1. Compute the sieving limit $$y$$.
2. Initialize a Fenwick tree called `sieve` indexed on `0..y`, with default value `1`.  
Set `sieve[0]` and `sieve[1]` to `0`, since these are not a part of the initial Eratosthenes setup.
3. Initialize a boolean array `sieveRaw` in a similar way as `sieve` - initialized to `false`, and then set `sieveRaw[0]` and `sieveRaw[1]` to `true`. It's a little easier to have it inverted in this way, where `sieveRaw[j]` being `true` corresponds to `j` being composite. This has very little impact on space requirements and will allow us to query a single element of the base sieve array in constant time which will be helpful.

4. For `p` in `2..sqrt(x)`,  
    4a. If `sieveRaw[p]` is `true`, then `p` is not a prime so increment `p` and try again.  
    4b. Otherwise, `p` is a prime - for each key value `v` satisfying `v >= p*p` and `v > y`, in _decreasing order_, update the value at `v` by  `S[v] -= S_0[v div p] - S_0[p-1]`, where `S_0[u]` is equal to `S[u]` if `u > y` and equal to `sieve.sum(u)` otherwise.  
    4c. Do a step of the Eratosthenes sieve - for each multiple of `p` up to `y`, say `j = p*k`, check `sieveRaw[j]`. If it is `false`, we need to eliminate `j` from the sieve by setting `sieveRaw[j]` to `true` and adding `-1` to `sieve[j]`.
5. For each key value $$v \leq y$$, test if `sieveRaw[v]`. If it is true, set `S[v] = S[v-1]`, otherwise `S[v] = S[v-1]+1`.
6. Return `S`. Here, `S[v]` is the number of primes up to `v` for each key value `v`.

## Analysis + Optimization
Clearly we are using $$O(y)$$ space. So how about our runtime?

This part will involve a lot of tedious casework so feel free to skip it and trust me instead.

For each prime $$p \leq \sqrt{x}$$, the Eratosthenes step has to modify `sieve[p*k]` for (at most) all of the values `p*k <= y`.  
Each update using the Fenwick tree takes $$O(\log(y))$$ time, for a total of $$O\left(\frac{y \log y}{p}\right)$$ time.

Then the Eratosthenes step takes us a total runtime of

$$\begin{align*}
\sum_{p \leq \sqrt{x}} \frac{y \log y}{p} &\sim y \log y \log \log \sqrt{x}\\
&\sim y \log y \log \log x
\end{align*}$$

Okay, now for the Lucy step.
## Benchmarks

## Sums of Primes, Primes Squared, ...

## Primes in Arithmetic Progressions

## Trick for Further Optimization

[1]: https://en.wikipedia.org/wiki/Meissel%E2%80%93Lehmer_algorithm
[2]: https://www.ams.org/journals/mcom/1985-44-170/S0025-5718-1985-0777285-5/S0025-5718-1985-0777285-5.pdf
[3]: https://projecteuler.net/thread=10;page=5#111677
[4]: https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
[5]: https://codeforces.com/blog/entry/91632
[6]: https://en.wikipedia.org/wiki/Mertens%27_theorems#Mertens'_second_theorem_and_the_prime_number_theorem
[7]: https://angyansheng.github.io/blog/dirichlet-hyperbola-method
[8]: https://mathproblems123.wordpress.com/2018/05/10/sum-of-the-euler-totient-function/
[9]: https://nim-lang.org/
[10]: https://codeforces.com/blog/entry/57292
[11]: https://www.hackerearth.com/practice/notes/binary-indexed-tree-or-fenwick-tree/#c217533
[12]: https://math-porn.tumblr.com/post/93129714459/range-queries-and-fenwick-trees
[13]: https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.14.8917
[14]: https://www.geeksforgeeks.org/inversion-count-in-array-using-bit/
[15]: https://codeforces.com/blog/entry/63064
[16]: https://cp-algorithms.com/data_structures/fenwick.html

[^1]: The author here claims the given algorithm runs in $$O(x^{2/3})$$ time - this is possible using a trick similar to the one we are going to describe here. The analysis of our plain Lucy algorithm basically applies to this author's algorithm and shows it runs in $$O(x^{3/4})$$ time which is still good.

[^2]: I looked and actually can't find a reference for this so I'll probably write something on it at some point.

[^3]: The function `isqrt()` uses the Babylonian algorithm and belongs in [a utility file](https://github.com/gbroxey/blog/blob/main/code/utils/iops.nim) available in the blog's repository.