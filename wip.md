---
title: "Density and GCDs"
tags: [number theory, density]
---

$$
\def\dnat{{\mathrm d}}
\def\dsup{{\overline{\mathrm d}}}
\def\dinf{{\underline{\mathrm d}}}
$$

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

$$\dnat(A) = \lim_{x \to \infty} \frac{A(x)}{x}$$

This is known as [natural density][1]. The numerator is the number of elements of $A$ up to $x$, so the fraction tells us the probability a uniformly chosen integer up to $x$ is in $A$. You can check all of the obvious properties listed above - they are all nice and easy to prove, assuming that all the limits actually exist.

Actually, that's an issue. Can we come up with a nice example of a set with no defined density?

We can tell that the fraction will always give us something between $0$ and $1$. So any badly behaved set should oscillate between being very dense and very sparse. One way to do this is to use the set of integers with an odd number of binary bits!

The following is a plot of $A(x)/x$ for this set:

<center><img src="/blog/docs/assets/images/wip-bad-density.svg"></center><br>

You can see that there is no defined density in this case. It oscillates between $1/3$ and $2/3$ forever.  
It is not particularly challenging to prove, *but* you should try to do it yourself if you haven't worked with density before. The lightly dashed lines in the graph are at $y = \frac{1}{3}, \frac{2}{3}$ and every power of two for the $x$ values. This should give you a pretty good idea of how the proof could go.

To get around this we can define an upper and lower density. In this case, the upper density would be $2/3$, and the lower density would be $1/3$. They're defined as you would expect:

$$\begin{align*}
\dsup(A) &= \limsup_{x \to \infty} \frac{A(x)}{x}\\
\dinf(A) &= \liminf_{x \to \infty} \frac{A(x)}{x}
\end{align*}$$

The notation for this is terribly inconsistent. This is the notation I like. Sometimes when authors are referring to upper density, the word "upper" is omitted. When it would be ambiguous I'll be specific.

Now that we have things written out, with a defined upper and lower density for every set, we can look at proving some of the basic properties we are going to be using in later sections.

---

## Preliminaries

---

## GCD Problem

> Write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of the set $A$.  
> Then $\dnat(G) = 0$ implies $\dnat(A) = 0$.

The proof I am going to present is a little hard to produce from thin air. There are other proofs, one of which I'll be including [at the end](#alternate-proof). My proof leads us down a path which leads to quite a few interesting and beautiful places, but the alternate proof is more direct. Hopefully you will see the value in both.

The strategy here is to first use the GCD condition to show that the dilations $kA$ are roughly disjoint. This is not too hard. After this we'll need to show that, if $A$ were to have a nonzero upper density, then some of the dilations $kA$ necessarily overlap a lot. This is the more tricky part.

So we start by picking two integers $k < j$. How large can the intersection $\dsup(kA \cap jA)$ be?

Suppose we write $k = gk'$ and $j = gj'$ where $g = \gcd(k, j)$. Then

$$\begin{align*}
\dsup(kA \cap jA) &= \dsup(k'gA \cap j'gA)\\
&= \frac{1}{g}\cdot\dsup(k'A \cap j'A)
\end{align*}$$

What does an integer $n \in k'A \cap j'A$ look like?  
We would have two distinct elements of $A$, call them $a_1$ and $a_2$, such that $n = k'a_1 = j'a_2$.  
Now since $\gcd(k', j') = 1$, we have $k' \mid a_2$ and $j' \mid a_1$, so write $a_1 = j' b_1$ and $a_2 = k' b_2$.

Then $n = k' j' b_1 = k' j' b_2$ implies that $b_1 = b_2$, and therefore

$$\gcd(a_1, a_2) = b_1 = b_2 = \frac{k'a_1}{k'j'} = \frac{j'a_2}{k'j'} \in G$$

Now factoring back in $g = \gcd(k, j)$, we have

$$kA \cap jA \subseteq \frac{kj}{g} G = \mathrm{lcm}(k, j) G$$

So in fact, if $G$ has density zero, so does every intersection $kA \cap jA$ for distinct $k, j$.

---

Next we want to attempt to relate this to the density of $A$. How can we do this?

Pick your favorite large integer $n$ and construct the set $B$ of all divisors of $n!$.  
We'll also construct a nice set $C$ such that the dilations $cB$ partition $\mathbb N$.

The goal is to prove that $\dsup(A) \leq \dsup(C)$, and that as $n$ gets large, $\dsup(C)$ tends to zero.

## TODO

---

Now let's look at a fun corollary:

> Let $\mathbb P_k$ be the set of integers with at most $k$ prime factors.
> Then $\mathrm d(\mathbb P_k) = 0$ for all $k$.  
> In particular, the primes have density zero.

---

## Alternate Proof

The following proof of [the original GCD problem](#gcd-problem) is due to [Project Euler][2] user tb65536.

We need the following lemma about prime numbers:

$$\lim_{n \to \infty} \prod_{p \leq n} \left(1 + \frac{1}{p}\right) \geq \lim_{n \to \infty} \sum_{p \leq n} \frac{1}{p} \to \infty$$

It's pretty simple to prove this, especially if you assume that the sum of reciprocals of primes diverges. There are quite a few nice proofs of this fact which you can read about [on Wikipedia][3]. The inequality there is obvious if you expand out the product: $1/p$ appears as a term for every prime $p$.

This proof proceeds by contradiction. We will assume 

[1]: https://en.wikipedia.org/wiki/Natural_density
[2]: https://projecteuler.net/about
[3]: https://en.wikipedia.org/wiki/Divergence_of_the_sum_of_the_reciprocals_of_the_primes