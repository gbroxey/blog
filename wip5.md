---
title: "Fast Convex Hulls for Number Theory"
tags: [algorithms]
date: 1970-01-01
---

> **Abstract.** We want to compute $\sum_{k \leq n} \left\lfloor \frac{n}{k} \right\rfloor$ and $\sum_{-r \leq k \leq r} \left\lfloor \sqrt{r^2 - k^2} \right\rfloor$ quickly.  
> The first one is a partial sum of $d(n)$, the divisor count function, and the second one is the number of lattice points inside a circle of radius $r$. In [my post][mult1] on multiplicative functions, we use the Dirichlet hyperbola method to handle the first sum in $O(\sqrt{n})$ time. The latter sum is usually just done brute force in $O(r)$ time. We will improve both runtimes with convex hull methods.

---

Hi

[mult1]: /blog/2023/04/30/mult-sum-1.html