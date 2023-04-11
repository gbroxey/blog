---
title: "A Density Problem With GCDs"
---

> **Abstract.** I describe how Lucy_Hedgehog's algorithm works, and how it can be implemented. Then I show how Fenwick trees can be used to boost its runtime without much effort. The final runtime is at most $O(x^{2/3} (\log x \log \log x)^{1/3})$ to compute $\pi(x)$. I also give an extension to sums of primes and to primes in arithmetic progressions. The implementation gives $\pi(10^{13})$ in less than 3s.

The following is a test to see how I can force MathJax to render stuff.

We have $1+2=3$.

We have $$1+2=3$$.

We have

$1+2=3$

We have

$$1+2=3$$

There are a lot of nice combinatorial algorithms for computing $$\pi(x)$$, the number of primes $$p \leq x$$. One very commonly implemented algorithm is the [Meissel-Lehmer algorithm][1], which runs in roughly $$O(x^{2/3})$$ time and either $$O(x^{2/3})$$ or $$O(x^{1/3})$$ space depending on if you go through the trouble to do segmented sieving, which can be complicated.