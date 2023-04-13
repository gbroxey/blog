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
> 
$$\dinf(bA) = \frac{1}{b} \dinf(A) \,\,\,\,\,\,\,\,\,  \dsup(bA) = \frac{1}{b}  \dsup(A) \,\,\,\,\,\,\,\,\, H(bA) = \frac{1}{b} H(A)$$

_Proof._ This is easy using definitions, [I promise][5]. Try it! $\proofqed$

> **Lemma 2.** When $A$ and $B$ are disjoint, we have the following:
> 
$$\begin{align*}\dsup(A \cup B) &\leq \dsup(A) + \dsup(B)\\
    \dinf(A \cup B) &\geq \dinf(A) + \dinf(B)\\
    H(A \cup B) &= H(A) + H(B)
    \end{align*}$$
> 
> The first inequality will be referred to as subadditivity of upper density.  
> Likewise the second will be referred to as superadditivity of lower density. 

_Proof._ This follows from subadditivity of $\limsup$, superadditivity of $\liminf$, and definitions.  
This extends to disjoint unions of any finite number of sets by induction. $\proofqed$

Now we know how density interacts with disjoint unions.  
Let's see how it interacts with set complements.

> **Lemma 3.** We have the following, whenever $B \subseteq A$:
> 
$$\begin{align*}\dsup(A - B) &\leq \dsup(A) - \dinf(B)\\
    \dinf(A - B) &\geq \dinf(A) - \dsup(B)\\
    H(A-B) &= H(A) - H(B)\end{align*}$$
> 
> When $\dnat(A)$ exists, we have equality in the first two relations.  
> Also, by substituting $A = A' \cup B'$ and $B = B'$ for disjoint $A', B'$, we can extend the inequalities in Lemma 2 as follows:
> 
$$\dsup(A) + \dinf(B) \leq \dsup(A \cup B) \leq \dsup(A) + \dsup(B)$$
> 
$$\dinf(A) + \dsup(B) \geq \dinf(A \cup B) \geq \dinf(A) + \dinf(B)$$

_Proof._ The first two are easy using counting functions; note that $\limsup \left(-\frac{B(n)}{n}\right) = -\liminf \frac{B(n)}{n}$, and that a similar relation works for $\liminf$. Fill in the details by hand if this doesn't make intuitive sense.

As for the third equation, just note that $A-B$ and $B$ are disjoint, then use Lemma 2. $\proofqed$

> **Lemma 4** (Inclusion-Exclusion). The following holds for all $A, B$:
> 
$$\begin{align*}
    \dsup(A \cup B) &\leq \dsup(A) + \dsup(B) - \dinf(A \cap B)\\
    \dinf(A \cup B) &\geq \dinf(A) + \dinf(B) - \dsup(A \cap B)\\
    H(A \cup B) &= H(A) + H(B) - H(A \cap B)
\end{align*}$$

_Proof._ Write $A' = A-B$, so by Lemma 3 we have $\dsup(A') \leq \dsup(A) - \dinf(A \cap B)$.

Moreover $A \cup B = A' \cup B$ is a disjoint union, so Lemma 2 gives us
$$\dsup(A \cup B) = \dsup(A' \cup B) \leq \dsup(A') + \dsup(B) \leq \dsup(A) + \dsup(B) - \dinf(A \cap B)$$
Similar applications of Lemmas 2 and 3 give us the other two results.

As before this can be extended to a finite number of sets by induction. The inductive step actually uses both inequalities, so they must be proved together. $\proofqed$

---

## Nearly Disjoint Dilations

In this section, I'll be making one or two extra definitions of my own, and proving some very nice properties which will assist us in our later proofs. I've tried to pick notations that make sense and help make things less wordy.

> **Definition.** Suppose that, for distinct $b_1$ and $b_2$ in $B$, we have $\dnat(b_1 A \cap b_2 A) = 0$.  
> That is, $A$ has "nearly disjoint" $B$-dilations. When this is true, we will write $A \perp B$.  
> Note that this is _not_ a symmetric relation in general.

> **Lemma 5.** Suppose that $A \perp B$, and that $H(B)$ exists.  
> Then $\dinf(A \times B) \geq \dinf(A) H(B)$.  
> When $H(B) = \infty$, the conclusion is that $\dinf(A) = 0$.

_Proof._ Start with finite $B$. We'll use superadditivity and inclusion-exclusion.

$$\dinf(A \times B) \geq \sum_b \dinf(bA) - \sum_{b_1 < b_2} \dsup(b_1A \cap b_2A) = \sum \frac{\dinf(A)}{b} = \dinf(A)H(B)$$

Now if we use the desired bound for finite subsets $B' \subseteq B$, we'll have 

$$\dinf(A \times B) \geq \dinf(A \times B') \geq \dinf(A) H(B')$$

Now as $H(B') \to H(B)$ from below, we see that $\dinf(A \times B) \geq \dinf(A) H(B)$.

In the case $H(B) = \infty$ we can suppose $\dinf(A) > 0$ for contradiction.  
We would have $\dinf(A)H(B') \to \infty$ which is impossible since it's bounded above by $1$. $\proofqed$

> **Lemma 6.** If $H(B) < \infty$ (and no other restrictions), then $\dsup(A \times B) \leq \dsup(A) \sum \frac{1}{b}$.

_Proof._ We start with $(A \times B)(x) \leq \sum_{b \in B} A(x/b)$.

Pick any $\varepsilon > 0$, and pick some partition $B = B_0 \cup B_1$ such that $B_0$ is finite and such that $H(B_1) \leq \varepsilon$.

Then we have

$$\begin{align*}
    (A \times B)(x) &\leq \sum_{b \in B_0} A(x/b) + \sum_{b \in B_1} x/b\\
    &= \sum_{b \in B_0} A(x/b) + x H(B_1)\\
    &\leq \sum_{b \in B_0} A(x/b) + \varepsilon x
\end{align*}$$

Now there exists a $y_0$ such that for all $y \geq y_0$ we have $A(y) \leq (\dsup(A)+\varepsilon)y$.

Suppose $x \geq \max(B_0)y_0$. Then we have

$$(A \times B)(x) \leq \sum_{b \in B_0} (\dsup(A) + \varepsilon) \frac{x}{b} + \varepsilon x = (\dsup(A) + \varepsilon) H(B_0)x + \varepsilon x$$

Therefore $\dsup(A \times B) \leq (\dsup(A) + \varepsilon)H(B_0) + \varepsilon \leq (\dsup(A) + \varepsilon)H(B) + \varepsilon$.

Letting $\varepsilon \to 0$ gives the result. $\proofqed$

The previous two lemmas have a lovely consequence which will be very helpful later.

> **Lemma 7.** Suppose that $A \perp B$, and that $A$ has a nonzero natural density.  
> Then $\sum \frac{1}{b}$ converges, and $A \times B$ has a natural density, which is equal to $\dnat(A) \sum \frac{1}{b}$.

That $\sum \frac{1}{b}$ exists is a consequence of Lemma 1 given $\dinf(A) > 0$.

Then using Lemmas 5 and 6 we have

$$\dinf(A) \sum \frac{1}{b} \leq \dinf(A \times B) \leq \dsup(A \times B) \leq \dsup(S) \sum \frac{1}{b}$$

Since $\dinf(A) = \dsup(A)$, these are all equalities, whence $\dnat(A \times B) = \dnat(A) \sum \frac{1}{b}$. $\proofqed$

---

## GCD Problem

> Write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of the set $A$.  
> Then $\dnat(G) = 0$ implies $\dnat(A) = 0$.

The proof I am going to present is a little hard to produce from thin air. There are other proofs, one of which I'll be including [at the end](#alternate-proof). My proof leads us down a path which leads to quite a few interesting and beautiful places, but the alternate proof is more direct. Hopefully you will see the value in both.

The strategy here is to first use the GCD condition to show that the dilations $kA$ are roughly disjoint ($A \perp \mathbb N$). This is not too hard. After this we'll need to show that, if $A$ were to have a nonzero upper density, then some of the dilations $kA$ necessarily overlap a lot. This is the more tricky part.

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

So in fact, if $G$ has density zero, so does every intersection $kA \cap jA$ for distinct $k, j$, and $A \perp \mathbb N$.

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

> **Lemma 999.** For all $n$, we have
> 
$$\prod_{p \leq n} \left(1 + \frac{1}{p}\right) \geq \sum_{p \leq n} \frac{1}{p}$$
> 
> And as $n$ tends to infinity, so does $\prod_{p \leq n} \left(1 + \frac{1}{p}\right)$.

It's pretty simple to prove this, especially if you assume that the sum of reciprocals of primes diverges. There are quite a few nice proofs of this fact which you can read about [on Wikipedia][3]. The inequality there is obvious if you expand out the product: $1/p$ appears as a term for every prime $p$.

This proof proceeds by contrapositive. We will assume that $\dsup(A) > 0$ and prove that $\dsup(G) > 0$, which does bear some resemblance to my proof. To do so, we'll pick any $\varepsilon > 0$, and assume that $n$ is an arbitrarily large integer such that $A(n) \geq (\dsup(A)-\varepsilon)n$. The goal is to prove that $\limsup G(n)/n > 0$.

We're going to be putting all of the integers in $S$ into buckets such that there are asymptotically many buckets, and that many buckets will give rise to unique elements of $G$.

Pick a nice large value $T$. Every integer can be written as a product $ab$ where $a$ is $T$-smooth (no prime factors greater than $T$) and $b$ has only prime factors greater than $T$.  Say $a = p_1^{e_1} p_2^{e_2} \ldots p_k^{e_k}$ is factored into primes. Then $ab$ will go into a bucket corresponding to the representative

$$p_1^{2\lfloor e_1/2 \rfloor} p_2^{2\lfloor e_2/2 \rfloor} \ldots p_k^{2\lfloor e_k/2 \rfloor} \cdot b$$

We're just rounding down each of those first exponents to be even. So for example, if we had $T = 5$ and we wanted to put the integer $51480$ into a bucket, we would factor $51480 = 2^3 \cdot 3^2 \cdot 5 \cdot 11 \cdot 13$ first, and round down the exponents on $2, 3, 5$ to be even.

Therefore $51480$ is in the bucket with representative $2^2 \cdot 3^2 \cdot 5^0 \cdot 11 \cdot 13 = 5148$.

> **Lemma 1000.** The density of the set of bucket representatives is $\prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$.  
>  Therefore, up to $n$, the number of bucket representatives is asymptotically
> 
$$n \cdot \prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$$

_Proof._ The set of bucket representatives can be written as the product $R_0 \times R_1$, where $R_0$ is the set of all integers not divisible by any primes $p \leq T$, and $R_1$ is the set of all square $T$-smooth naturals.

Helpfully, $R_0$ is periodic mod $\prod_{p \leq T} p$, and hence it has a nonzero natural density.

Then, since $R_0 \perp R_1$ (check this yourself), the set of bucket representatives has a defined natural density (Lemma 7), and we know it has to be $\dnat(R_0 \times R_1) = \dnat(R_0) H(R_1)$.

Now we can calculate

$$\begin{align*}
\dnat(R_0) &= \prod_{p \leq T} \left(1 - \frac{1}{p}\right)\\
H(R_1) &= \prod_{p \leq T} \left(1 + \frac{1}{p^2} + \frac{1}{p^4} + \ldots\right)\\
&= \prod_{p \leq T} \frac{1}{1-p^{-2}}
\end{align*}$$

Then, since

$$\left(1 - \frac{1}{p}\right)\frac{1}{1-p^{-2}} = \left(1 + \frac{1}{p}\right)^{-1}$$

we have the claimed density. $\proofqed$

We have one last property of this setup to verify.

> **Lemma 1001.** Bucket membership is closed under $\gcd$:  
> If $a_1$ and $a_2$ are in the same bucket, then $\gcd(a_1, a_2)$ would be in that bucket too.

_Proof._ This is easy from definitions. You don't want this post to be LONGER, do you? $\proofqed$

We're ready to prove the GCD problem now.

Choose a value of $T$ large enough so that

$$\prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1} <\, \dsup(A)$$

This is possible by Lemma 999.

Let's write $\delta = \prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$ because we'll be using it pretty often in the next few lines.

The number of bucket representatives up to $n$ is asymptotically $\delta n$.  
Also, writing $k = \pi(T)$, each bucket contains at most $2^k$ elements of $A$.

Recall that we have an arbitrary $\varepsilon > 0$, and that we pick $n$ with $A(n) \geq (\dsup(A)-\varepsilon)n$.  
Consider the set of buckets which contain only a single element of $A$ up to $n$.  
Then the number of elements outside these buckets is at asymptotically least

$$A(n) - \delta n \geq (\dsup(A) - \delta - \varepsilon)n$$

Pick $\varepsilon$ small enough so that $\dsup(A) - \delta - \varepsilon > 0$.

All the rest of these elements have to be in buckets which are not singletons.  
How many buckets must there be?  
Since each one has at most $2^k$ elements, the number of such buckets is at least

$$\frac{\dsup(A)-\delta-\varepsilon}{2^k}n$$

In each such bucket, we can pick two distinct $a_1, a_2 \leq n$ and produce $\gcd(a_1, a_2) \in G$.  
These GCDs we're generating are no greater than $n$.  
Thanks to Lemma 1001, they are also all distinct, and so we have

$$G(n) \geq \frac{\dsup(A)-\delta-\varepsilon}{2^k}n$$

Remember that this is not for all $n$ but only those $n$ satisfying $A(n) \geq (\dsup(A)-\varepsilon)n$.

We immediately have 

$$\dsup(G) \geq \frac{\dsup(A)-\delta-\varepsilon}{2^k} > 0$$

which completes the proof. $\proofqed$



[1]: https://en.wikipedia.org/wiki/Natural_density
[2]: https://projecteuler.net/about
[3]: https://en.wikipedia.org/wiki/Divergence_of_the_sum_of_the_reciprocals_of_the_primes
[4]: https://math.berkeley.edu/~tb65536/index.html
[5]: http://catb.org/jargon/html/E/exercise--left-as-an.html