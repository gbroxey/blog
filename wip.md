---
title: "Density and GCDs"
tags: [number theory, density]
---

> **Abstract.** Suppose $A$ is a set of natural numbers, and write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of $A$. I'll prove that if $G$ has density zero, then $A$ has density zero. This will be written for people who have seen limits before but aren't familiar with density. Therefore we will be deriving some of its simple properties first, and then aiming at the stated problem. I'll present a nice proof which will prepare us for some generalizations I'll get to in future posts.

---

## Defining Density
Density is a way to measure the largeness of an infinite set of naturals - it's a number between $0$ and $1$ describing how tightly packed the elements of a set are. There are a lot of ways to define it, and there's not an immediate indication which one is best. We can come up with a few properties that a property called density should probably have:

- The density of $\mathbb N$ should be $1$
- The density of the empty set should be $0$
- The density of a finite set of naturals should be $0$, since most naturals are not in that set
- The density of the set of even naturals should be $1/2$, since half of the naturals are even
- If $A \subseteq B$, then the density of $A$ should be at most the density of $B$
- If you have a finite collection of sets, and no two sets overlap, the density of their union should be the sum of the densities of the sets - density should be additive

You could probably come up with more "obvious" properties of density even without knowing how it is actually defined. This is a pretty good sign actually, since each property restricts how we could define it. 

First, we'll use the following notation for the **counting function** of the set $A$.

$$A(x) = \left| A \cap \{1, 2, \ldots, \lfloor x \rfloor\}\right|$$

This is the number of elements of $A$ which are no greater than $x$. It's helpful to have this shorthand. Now let's try to define density! The following should make a good amount of sense:

$$\mathrm d(A) = \lim_{x \to \infty} \frac{A(x)}{x}$$

This is known as [natural density][1]. The numerator is the number of elements of $A$ up to $x$, so the fraction tells us the probability a uniformly chosen integer up to $x$ is in $A$. You can check all of the obvious properties listed above - they are all nice and easy to prove, assuming that all the limits actually exist.

Actually, that's an issue. Can we come up with a nice example of a set with no defined density?

We can tell that the fraction will always give us something between $0$ and $1$. So any badly behaved set should oscillate between being very dense and very sparse. One way to do this is to use the set of integers with an odd number of binary bits!

The following is a plot of $A(x)/x$ for this set:

<center><img src="/blog/docs/assets/images/wip-bad-density.svg"></center><br>

You can see that there is no defined density in this case. It oscillates between $1/3$ and $2/3$ forever.  
It is not particularly challenging to prove, *but* you should try to do it yourself if you haven't worked with density before. The lightly dashed lines in the graph are at $y = \frac{1}{3}, \frac{2}{3}$ and every power of two for the $x$ values. This should give you a pretty good idea of how the proof could go.

To get around this we can define an upper and lower density. In this case, the upper density would be $2/3$, and the lower density would be $1/3$. They're defined as you would expect:

$$\begin{align*}
\overline{\mathrm d}(A) &= \limsup_{x \to \infty} \frac{A(x)}{x}\\
\underline{\mathrm d}(A) &= \liminf_{x \to \infty} \frac{A(x)}{x}
\end{align*}$$

The notation for this is terribly inconsistent. This is the notation I like. Sometimes when authors are referring to upper density, the word "upper" is omitted. When it would be ambiguous I'll be specific.

---

**GCD Problem:**

> Write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of the set $A$.  
> Then $\mathrm d(G) = 0$ implies $\mathrm d(S) = 0$.



[1]: https://en.wikipedia.org/wiki/Natural_density