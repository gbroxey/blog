---
layout: page
title: Open Problems
permalink: /problems/
date: 2023-05-28
modified_date: 2023-05-29
---

I've gathered some problems I haven't been able to completely resolve.  

If you decide to try these, or if you find that they've been solved in literature somewhere, I'd be interested to hear about them. I'll include a bried summary of progress.

---

## Problem 1

> Suppose you have two sets $A$ and $B$ of natural numbers.  
> Write $A \perp B$ if the sets $b_1 A \cap b_2 A$ have zero natural density, whenever $b_1, b_2$ are different elements of $B$. In other words, $A$ has nearly disjoint $B$-dilations.  
> Then the upper density of $A$ is at most
> 
$$\overline{\text{d}}(A) \leq \left(\sum \frac{1}{b}\right)^{-1}$$

See the following posts for context: [1](/blog/2023/04/13/density-gcds.html) [2](/blog/2023/04/18/dilations-primes.html)

The first post basically proves it for nice $B$ for which there exist $A$ such that the dilations $bA$ are disjoint and such that $A \times B = \mathbb N$. Erdős and Saffari call these "direct factors".  
This case extends to $B = \mathbb N$ by a limiting argument.

The second post proves it for the case in which $\sum \frac{1}{b} = \infty$ and such that the elements of $B$ are pairwise coprime. This contains the case $B = \mathbb P$ being the set of primes.

I've proved it by a few arguments for the cases (for example)

$$\begin{align*}
B &= \lbrace 1, 2, 3 \rbrace\\
B &= \lbrace 1, 2, 5 \rbrace\\
B &= \lbrace 1, 2, 3, 4 \rbrace\\
B &= \lbrace 1, p, q \rbrace \,\, \text{ when } p < q < p^2
\end{align*}$$

The general case, as well as the special case $B = \lbrace 1, p, q \rbrace$, remain open.

---

## Problem 2

> Fix a base $b > 1$ and a natural number $x_1$.  
> Let $x_{n+1} = x_n + f(x_n)$ where $f(x)$ is the sum of the base-$b$ digits of $x$.  
> Similarly create the sequence $y_n$ starting from a natural number $y_1$.  
> Then there exists an integer $i$ such that $x_n = y_{n+i}$ for all large $n$ iff $\gcd(x_1, b-1) = \gcd(y_1, b-1)$.  
> In the binary case, there always exists such an integer $i$.

It seems like there's some simple proof that I'm just totally overlooking here.

Let tetration be written as ${^{n}a} = a^{a^{\ldots^a}}$, where there are $n$ levels in the tower.

Here's a proof (minus computer calculation) that, in the binary case, any starting values $a_1, b_1 < {^{2000}}{2}$ will both eventually be mapped to the same value.

Fix $K$ and initialize the range $\lbrack 1, {^{K}2} - 1 \rbrack$.  
Any integer in this range will eventually be mapped to the range $\lbrack {^{K}2}, {^{K}2} + {^{K-1}2} - 1 \rbrack$, since the max bit count in the first range is ${^{K-1}2}$.

From there it gets a little uglier, this range maps into $\lbrack {^{K}2} + {^{K-1}2}, {^{K}2} + {^{K-1}2} - 1 + 1 + {^{K-2}2} \rbrack$.  
Continuing on, you get ranges of the form $\lbrack {^{K}2} + {^{K-1}2} + \ldots + {^{J}2} + U, {^{K}2} + {^{K-1}2} + \ldots + {^{J-1}2} + V \rbrack$ which get successively narrower, and you stop once the value of $V$ exceeds ${^{J-1}2}$. That only realistically happens for $J-1 \leq 4$, since ${^{5}2}$ is astronomically big.

Now, that doesn't reduce the problem to one integer, rather a small range (seemingly linear in $K$) which we can manually test to ensure they all converge to one trajectory. To do that we separate off the sum of powers of two down to ${^{5}2}$ and treat the bit count of those separately.

My [super old Facebook post](https://www.facebook.com/groups/1923323131245618/posts/2139500409627888/) on this says that every starting value under ${^{2000}2}$ is eventually mapped to ${^{2000}2} + {^{1999}2} + \ldots + {^{5}2} + 838365944$.

---

## Problem 3

> Say $\alpha$ is an algebraic number.  
> Is there always a finite sequence of polynomials $f_1, f_2, \ldots, f_k$ with integer coefficients which, when composed, has $f_1(f_2(\ldots f_k(\alpha) \ldots)) = 0$?

If $\alpha = \frac{p}{q}$ is rational, the length one sequence $f_1(x) = qx - p$ works.

What if $\alpha$ is a quadratic irrational, say $A \alpha^2 + B \alpha + C = 0$?

Then the sequence $f_1(x) = x+C$ and $f_2(x) = x(Ax+B)$ works.  

I posted this some years ago on the [actually good math problems](https://www.facebook.com/groups/1923323131245618/posts/2765082573736332/) Facebook group. There, Jordi Ribes provided a working sequence for the cubic case:

> Any cubic x^3+ax^2+bx+c divides the polynomial (x+a/3)^2*((x+a/3)^2-(a^2-3b)/3)^2-((2a^3-9ab+27c)/27)^2. This comes from computing the depressed cubic t^3+dt+e (where d,e depend on a,b,c) through the change t=x+a/3, and noting that t^3+dx+e divides t^2*(t^2+d)^2-e^2. So f_1(x)=(x+a/3)^2, f_2(x)=x*(x-(a^2-3b)/3)^2, f_3(x)=x-((2a^3-9ab+27c)/27)^2.

Seems interesting. The cases with degree $\geq 4$ are open.