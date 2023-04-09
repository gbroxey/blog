---
title: "Lucy's Algorithm + Fenwick Trees"
date: 2023-04-09
---

There are a lot of nice combinatorial algorithms for computing $$\pi(x)$$, the number of primes $$p \leq x$$. One very commonly implemented algorithm is the Meissel-Lehmer algorithm, which runs in roughly $$O(x^{2/3})$$ time and either $$O(x^{2/3})$$ or $$O(x^{1/3})$$ space depending on if you go through the trouble to do segmented sieving stuff.

Testing.