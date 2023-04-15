---
title: "Nearly Disjoint Dilations: Primes"
tags: [number theory, density]
---

> **Abstract.** I'll prove that if $A$ has nonzero upper density, there are primes $p < q$ so that the intersection $pA \cap qA$ has nonzero upper density. We can also choose $p$ and $q$ to be very close to each other in some specific ways. This will use some basic probability theory.

---

[Last time](/blog/2023/04/13/density-gcds.html), we defined upper and lower density and some of its nice properties. You should read that post before this one because at least a few ideas will be repeated here.

Recall that we defined $A \perp B$ to mean that, for any distinct $b_1, b_2$ in $B$, the intersections $b_1A \cap b_2A$ always have density zero. In other words, $A$ has nearly disjoint $B$-dilations.  
We also defined $H(B)$ to be the sum $\sum 1/b$, or $H(B) = \infty$ if the sum diverges.  

The important conjecture of the previous post was the following:

> **Conjecture 1.** Suppose $\newcommand{\dnat}{\mathrm d}
\newcommand{\dsup}{\overline{\mathrm d}}
\newcommand{\dinf}{\underline{\mathrm d}}
\newcommand{\proofqed}{\quad\quad\quad\square}A \perp B$. Then $\dsup(A) \leq H(B)^{-1}$.  
> When $H(B) = \infty$, the conclusion is $\dsup(A) = 0$.

We proved the conjecture in the case that $B$ was the set of divisors of some integer, which also implied by a limiting argument the case $B = \mathbb N$. Many cases remain unclear.

Today we'll prove the conjecture assuming that $H(B) = \infty$ and that the elements of $B$ are pairwise coprime. Pretty clearly the case $B = \mathbb P$ follows.

It's interesting to notice that this case can be worded as follows:

> **Corollary.** Suppose $\dsup(A) > 0$.  
> Then there are primes $p < q$ so that $\dsup(pA \cap qA) > 0$.  
> In other words, the equation $pa_1=qa_2$ has many, many solutions with $a_1, a_2 \in A$, so many that the set of $a_1$-values which work form a subset of $A$ with nonzero upper density.

It seems very interesting. How could we prove this?

Let's look at Lemma 9 from the previous post.

> **Lemma 9.** Suppose $U$ and $V$ are sets of naturals such that $U \times V = \mathbb N$, where $V$ is finite.  
> Then, if $A \perp V$, we have $\dsup(A) \leq \dsup(U)$.

In the case of the primes, we'd want $U \times \mathbb P = \mathbb N$ for a set $U$ of exceptionally low density.  
Is something like that possible?

Suppose that we pick $\varepsilon > 0$ and look at a generic set $U$ with density $\varepsilon$.  
What's the probability an integer $n$ is included in $U \times \mathbb P$?  
If $n$ has $k$ prime factors, it'd be something like $1-(1-\varepsilon)^k$.  
Only a density zero subset of the naturals have less than $k$ prime factors (see [Corollary 1](/blog/2023/04/13/density-gcds.html) near the end), so we can pick a really big $k$ and then $U \times \mathbb P$ should have density close to $1$.

Aside from handwaving away almost every important detail in the proof, this approach will work!  
The biggest issue here is of course the idea of picking a random set of naturals with a certain density. The infiniteness of the naturals makes things very ugly for us.

Instead, the plan will be to look at large prefixes of $A$ and finding a nice random looking prefix of $U$ which has low density, but such that $U \times \mathbb P$ has density near $1$. That way we can hopefully rely on nice finite probability distributions.

The second biggest issue is that Lemma 9 only applies to finite sets $V$, and unfortunately the set of primes is infinite. The fix here is to take as $V$ large subsets of the primes and be careful with our estimates.

---

For the following, $B$ is a set of pairwise coprime naturals such that $H(B) = \infty$.

We're going to start with a lemma which will assist us with using only finitely many primes.  
To avoid confusion with the lemmas we'll reference from the previous post we'll start numbering with..

> **Lemma 13.** Bla bla bla