---
title: "Density and GCDs"
tags: [number theory, density]
---

$$
\newcommand{\dnat}{\mathrm d}
\newcommand{\dsup}{\overline{\mathrm d}}
\newcommand{\dinf}{\underline{\mathrm d}}
\newcommand{\proofqed}{\quad\quad\quad\square}
$$

> **Abstract.** Suppose $A$ is a set of natural numbers, and write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of $A$. I'll prove that if $G$ has density zero, then $A$ has density zero. This will be written for people who have seen limits before but aren't familiar with density. Therefore we will be deriving some of its simple properties first, and then aiming at the stated problem. I'll present a nice proof which will prepare us for some generalizations I'll get to in future posts.

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

Let's start by proving some things about density.  
This will be the really basic stuff, so skip to [the next section](#nearly-disjoint-dilations) if this all looks familiar.

In this section, $A$ and $B$ are general sets, and $a$ and $b$ refer to their elements.

We'll start with some definitions that will make our theorems look nicer.

> **Definition.** Write $H(A)$ for the harmonic sum $\sum\frac{1}{a}$ over $a \in A$.  
> When it diverges, write $H(A) = \infty$.

> **Definition.** For naturals $b$, write $bA$ for the set of all $ba$ for $a \in A$.  
> This is the $b$-dilation of $A$.  
> We can define $A \times B$ for the union of all the $b$-dilates of $A$, over $b \in B$.

We can easily describe how dilation changes the properties of a set we like.

> **Lemma 1.** We have the following inequalities:

$$\dinf(bA) = \frac{1}{b} \dinf(A) \,\,\,\,\,\,\,\,\,  \dsup(bA) = \frac{1}{b}  \dsup(A) \,\,\,\,\,\,\,\,\, H(bA) = \frac{1}{b} H(A)$$

_Proof._ This is easy using definitions, [I promise][5]. Try it! $\proofqed$

> **Lemma 2.** When $A$ and $B$ are disjoint, we have the following:

$$\begin{align*}\dsup(A \cup B) &\leq \dsup(A) + \dsup(B)\\
    \dinf(A \cup B) &\geq \dinf(A) + \dinf(B)\\
    H(A \cup B) &= H(A) + H(B)
    \end{align*}$$

_Proof._ This follows from subadditivity of $\limsup$, superadditivity of $\liminf$, and definitions.  
This extends to disjoint unions of any finite number of sets by induction. $\proofqed$

Now we know how density interacts with disjoint unions.  
Let's see how it interacts with set complements.

> **Lemma 3.** We have the following, whenever $B \subseteq A$:

$$\begin{align*}\dsup(A - B) &\leq \dsup(A) - \dinf(B)\\
    \dinf(A - B) &\geq \dinf(A) - \dsup(B)\\
    H(A-B) &= H(A) - H(B)\end{align*}$$

> When $\dnat(A)$ exists, we have equality in the first two relations.  
> Also, by substituting $A = A' \cup B'$ and $B = B'$ for disjoint $A', B'$, we can extend the inequalities in Lemma 2 as follows:

$$\begin{align*}\dsup(A) + \dinf(B) &\leq \dsup(A \cup B) &\leq \dsup(A) + \dsup(B)\\
\dinf(A) + \dsup(B) &\geq \dinf(A \cup B) &\geq \dinf(A) + \dinf(B)
\end{align*}$$

_Proof._ 

> **Lemma 4** (Inclusion-Exclusion). The following always hold ($A$ and $B$ do not have to be disjoint):
> 

---

## Nearly Disjoint Dilations

In this section, I'll be making one or two extra definitions of my own, and proving some very nice properties which will assist us in our later proofs. I've tried to pick notations that make sense and help make things less wordy.

> **Definition.** Suppose that, for distinct $b_1$ and $b_2$ in $B$, we have $\dnat(b_1 A \cap b_2 A) = 0$.  
> That is, $A$ has "nearly disjoint" $B$-dilations. When this is true, we will write $A \perp B$.  
> Note that this is _not_ a symmetric relation in general.

> **Lemma 1.** Suppose that $A \perp B$, and that $\sum \frac{1}{b}$ exists.  
> Then $\dinf(A \times B) \geq \dinf(A) \sum \frac{1}{b}$.  
> When $\sum \frac{1}{b}$ diverges, the conclusion is that $\dinf(A) = 0$.

> **Lemma 2.** If $\sum \frac{1}{b} < \infty$ (and no other restrictions), then $\dsup(A \times B) \leq \dsup(A) \sum \frac{1}{b}$.

The previous two lemmas have a lovely consequence which will be very helpful later.

> **Lemma 3.** Suppose that $A \perp B$, and that $A$ has a nonzero natural density.  
> Then $\sum \frac{1}{b}$ converges, and $A \times B$ has a natural density, which is equal to $\dnat(A) \sum \frac{1}{b}$.

That $\sum \frac{1}{b}$ exists is a consequence of Lemma 1 given $\dinf(A) > 0$.

Then using Lemmas 1 and 2 we have

$$\dinf(A) \sum \frac{1}{b} \leq \dinf(A \times B) \leq \dsup(A \times B) \leq \dsup(S) \sum \frac{1}{b}$$

Since $\dinf(A) = \dsup(A)$, these are all equalities, whence $\dnat(A \times B) = \dnat(A) \sum \frac{1}{b}$. $\proofqed$

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

The following proof of [the original GCD problem](#gcd-problem) is due to [Project Euler][2] user [tb65536][4].

We need the following lemma about prime numbers:

$$\lim_{n \to \infty} \prod_{p \leq n} \left(1 + \frac{1}{p}\right) \geq \lim_{n \to \infty} \sum_{p \leq n} \frac{1}{p} \to \infty$$

It's pretty simple to prove this, especially if you assume that the sum of reciprocals of primes diverges. There are quite a few nice proofs of this fact which you can read about [on Wikipedia][3]. The inequality there is obvious if you expand out the product: $1/p$ appears as a term for every prime $p$.

This proof proceeds by contradiction. We will assume that $\dsup(A) > 0$ and prove that $\dsup(G) > 0$, which does bear some resemblance to my proof. To do so, we'll pick any $\varepsilon > 0$, and assume that $n$ is an arbitrarily large integer such that $A(n) \geq (\dsup(A)-\varepsilon)n$. The goal is to prove that $\limsup G(n)/n > 0$.

We're going to be putting all of the integers in $S$ into buckets such that there are asymptotically many buckets, and that many buckets will give rise to unique elements of $G$.

Pick a nice large value $T$. Every integer can be written as a product $ab$ where $a$ is $T$-smooth (no prime factors greater than $T$) and $b$ has only prime factors greater than $T$.  Say $a = p_1^{e_1} p_2^{e_2} \ldots p_k^{e_k}$ is factored into primes. Then $ab$ will go into a bucket corresponding to the representative

$$p_1^{2\lfloor e_1/2 \rfloor} p_2^{2\lfloor e_2/2 \rfloor} \ldots p_k^{2\lfloor e_k/2 \rfloor} \cdot b$$

We're just rounding down each of those first exponents to be even. So for example, if we had $T = 5$ and we wanted to put the integer $51480$ into a bucket, we would factor $51480 = 2^3 \cdot 3^2 \cdot 5 \cdot 11 \cdot 13$ first, and round down the exponents on $2, 3, 5$ to be even.

Therefore $51480$ is in a bucket corresponding to $2^2 \cdot 3^2 \cdot 5^0 \cdot 11 \cdot 13 = 5148$.

**Claim.** The density of the set of bucket representatives is $\prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$, and therefore when bucketing the integers up to $n$, there will asymptotically be about $n \cdot \prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$ buckets.

We can see that every integer is either a bucket representative, or is some representative multiplied by a few of the primes up to $T$. We can prove our claim by showing that the density of the bucket representatives exists and equals $$.


Pick a value $T$ large enough so that

$$\prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1} <\, \dsup(A)$$

This is possible due to the lemma aforementioned. 

[1]: https://en.wikipedia.org/wiki/Natural_density
[2]: https://projecteuler.net/about
[3]: https://en.wikipedia.org/wiki/Divergence_of_the_sum_of_the_reciprocals_of_the_primes
[4]: https://math.berkeley.edu/~tb65536/index.html
[5]: http://catb.org/jargon/html/E/exercise--left-as-an.html