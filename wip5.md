---
title: "Convex Hulls Title WIP"
tags: [algorithms]
date: 1970-01-01
---

> **Abstract.** Several number theoretic sums, primarily $\sum d(n)$ and $\sum r_2(n)$, can be dealt with using straightforward methods in relatively little time. By turning these into geometric problems involving lattice points in convex sets, it's possible to do these sums much faster. This is a fairly standard technique, but it can be difficult to visualize.

---

The first thing I'd like to do here is briefly discuss the two main examples we'll be dealing with. I'll quickly show how each example can be rephrased in terms of counting lattice points.

### Divisor Count Summatory Function

We considered in [summing multiplicative functions 1][mult1] how to compute the partial sums of the function $d(n)$, defined as the number of divisors of $n$. The summation is written as

$$D(n) = \sum_{1 \leq k \leq n} d(k)$$

where I will be taking care not to use my personally preferred variable $x$ as a summation limit.[^1]

This is the standard application of the so-called Dirichlet Hyperbola Method, which I described in detail [last time][mult1].

The idea is simple. The function $d(k)$ counts positive integer pairs $(x, y)$ with $xy = k$, and so summing over $k \leq n$ will give us the count of all integer pairs $(x, y)$ with $xy \leq n$. This region forms a hyperbola, hence the name hyperbola method. The important formula comes from exploiting the symmetry of the hyperbola, very quickly counting the lattice points in a small section of the hyperbola and computing the total count from that.

I included a diagram last time, but since this post is going to have a lot of diagrams and I want stylistic consistency, I've made a new one.[^2] Here's what the hyperbola method is doing:

<center><img src="/blog/docs/assets/images/wip/hyperbola_chunks.png" width="100%" height="100%"></center>

The red and purple areas on the left together contain $\sum_{x \leq \sqrt{n}} \left\lfloor\frac{n}{x}\right\rfloor$ lattice points.  
Because of symmetry, that's the same number of lattice points as in the blue and purple areas on the bottom.  
So, to get the total count, we can add those two together. We have to subtract the number of points in the purple square since those ones get counted twice.

This gives the answer as

$$D(n) = 2\sum_{k \leq \sqrt{n}} \left\lfloor \frac{n}{k} \right\rfloor - \lfloor\sqrt{n}\rfloor^2$$

which is by itself a perfectly good algorithm to compute $D(n)$, in $O(\sqrt{n})$ time:

```nim
proc divisorSummatory(n: int64): int64 =
  ##Computes d(1) + ... + d(n) in O(n^(1/2)) time.
  var nsqrt = isqrt(n)
  for k in 1..nsqrt:
    result += 2*(n div k)
  result -= nsqrt*nsqrt
```

For small values of $n$, this simple algorithm is certainly all you need. Even at $n = 10^{17}$ it is perfectly good at only a bit over two seconds to compute the answer. But if we want to push it to something like $n = 10^{24}$, which is more around the range we're interested in today, we will need to do something more involved.[^3]

---

Hi

[mult1]: /blog/2023/04/30/mult-sum-1.html
[aseprite]: https://www.aseprite.org/

[^1]: Obviously the reason is that later on, we will use $(x, y)$ as coordinates on a grid, and I would rather avoid the confusion from the outset. So from here on, we will be using $n$ as our summation limit, and $k$ as the free variable in the summation. The letters $x, y$ will be joining the party later.

[^2]: I made all the diagrams on this page by hand in [Aseprite][aseprite].  
The hyperbola is a Bézier curve with points at $(1, 16), (2, 3), (3, 2), (16, 1)$.

[^3]: Unless you're extremely patient. For $n = 10^{24}$ I estimated something like over two hours runtime for this more basic algorithm. It is pretty parallelizable though, if you're exceptionally lazy, since it has no memory requirement.