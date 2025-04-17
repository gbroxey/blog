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

I included a diagram last time, but since this post is going to have a lot of diagrams and I want stylistic consistency, I've made a new one.

<center><img src="/blog/docs/assets/images/hyperbola_chunks.png" width="100%" height="100%"></center>

---

Hi

[mult1]: /blog/2023/04/30/mult-sum-1.html

[^1]: Obviously the reason is that later on, we will use $(x, y)$ as coordinates on a grid, and I would rather avoid the confusion from the outset. So from here on, we will be using $n$ as our summation limit, and $k$ as the free variable in the summation. The letters $x, y$ will be joining the party later.