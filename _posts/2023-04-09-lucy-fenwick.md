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

In the code, I'll be calling this container `FIArray` - standing for floor indexed array. There's no actual name for this but this one seems as good as any. Here's a simple implementation in [Nim][9] (note that `div` is floor division):

```nim
type FIArray = object
  ##Given x, stores a value at each distinct (x div n).
  x: int64
  isqrt: int64
  arr: seq[int64]

proc newFIArray(x: int64): FIArray =
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc `[]`(S: FIArray, v: int64): int64 =
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`(S: var FIArray, v: int64, z: int64) =
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

And here's the incredibly simple Nim implementation:

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
|$$x$$|$$\pi(x)$$|Time (s)|
|:---:|:--------:|:------:|
|$$10^9$$|`50847534`|`0.049`|
|$$10^{10}$$|`455052511`|`0.259`|
|$$10^{11}$$|`4118054813`|`1.370`|
|$$10^{12}$$|`37607912018`|`7.259`|
|$$10^{13}$$|`346065536839`|`39.198`|
|$$10^{14}$$|`3204941750802`|`209.039`|



## Fenwick / Binary Indexed Trees

## Analysis + Optimization

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

[^1]: The author here claims the given algorithm runs in $$O(x^{2/3})$$ time - this is possible using a trick similar to the one we are going to describe here. The analysis of our plain Lucy algorithm basically applies to this author's algorithm and shows it runs in $$O(x^{3/4})$$ time which is still good.