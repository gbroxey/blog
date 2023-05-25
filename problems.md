---
layout: page
title: Open Problems
permalink: /problems/
---

I've gathered some problems I haven't been able to completely resolve.  
If you decide to try these, or if you find that they've been solved in literature somewhere, I'd be interested to hear about them. A brief summary of relevant sources and current progress will be included.

---

> **Problem 1.** Suppose you have two sets $A$ and $B$ of natural numbers.  
> Write $A \perp B$ if the sets $b_1 A \cap b_2 A$ have zero natural density, whenever $b_1, b_2$ are different elements of $B$. In other words, $A$ has nearly disjoint $B$-dilations. Then the upper density of $A$ is at most
> 
$$\overline{\text{d}}(A) \leq \left(\sum \frac{1}{b}\right)^{-1}$$

See the following posts for context: [1](/blog/2023/04/13/density-gcds.html) [2](/blog/2023/04/18/dilations-primes.html)

The first post basically proves it for nice $B$ for which there exist $A$ such that the dilations $bA$ are disjoint and such that $A \times B = \mathbb N$. Erdős and Saffari call these "direct factors". This case extends to $B = \mathbb N$ by a limiting argument.

The second post proves it for the case in which $\sum \frac{1}{b} = \infty$ and such that the elements of $B$ are pairwise coprime. This contains the case $B = \mathbb P$ being the set of primes.

I've proved it by a few arguments for the cases (for example)

$$\begin{align*}
B &= \lbrace 1, 2, 3 \rbrace\\
B &= \lbrace 1, 2, 5 \rbrace\\
B &= \lbrace 1, 2, 3, 4 \rbrace\\
B &= \lbrace 1, p, q \rbrace \,\, \text{ when } p < q < p^2\\
\ldots &
\end{align*}$$

---