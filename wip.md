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

This will be the really basic stuff, so skip to [the next section](#nearly-disjoint-dilations) if this all looks familiar.

In this section, $A$ and $B$ are general sets of naturals, and $a$ and $b$ refer to their elements.

We'll start with some definitions that will make our theorems look nicer.

> **Definition.** Write $H(A)$ for the harmonic sum $\sum\frac{1}{a}$ over $a \in A$.  
> When it diverges, write $H(A) = \infty$.

> **Definition.** For naturals $b$, write $bA$ for the set of all $ba$ for $a \in A$.  
> This is the $b$-dilation of $A$.  
> We can define $A \times B$ for the union of all the $b$-dilates of $A$, over $b \in B$.  
> In other words, $A \times B = \lbrace ab \mid a \in A, b \in B \rbrace$.

We can easily describe how dilation changes the properties of a set we like.

> **Lemma 1.** We have the following equalities:
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

> **Definition.** Suppose that, for any distinct $b_1$ and $b_2$ in $B$, we have $\dnat(b_1 A \cap b_2 A) = 0$.  
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

> **Lemma 6.** If $H(B) < \infty$ (and no other restrictions), then $\dsup(A \times B) \leq \dsup(A) H(B)$.

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
> Then $H(B) < \infty$, and $A \times B$ has a natural density, which is equal to $\dnat(A) H(B)$.

That $H(B) < \infty$ exists is a consequence of Lemma 5 given $\dinf(A) > 0$.

Then using Lemmas 5 and 6 we have

$$\dinf(A) \sum \frac{1}{b} \leq \dinf(A \times B) \leq \dsup(A \times B) \leq \dsup(S) \sum \frac{1}{b}$$

Since $\dinf(A) = \dsup(A)$, these are all equalities, whence $\dnat(A \times B) = \dnat(A) \sum \frac{1}{b}$. $\proofqed$

---

## GCD Problem

> Write $G$ for the set of all $\gcd(x, y)$ where $x, y$ are different members of the set $A$.  
> Then $\dnat(G) = 0$ implies $\dnat(A) = 0$.

The proof I am going to present is a little hard to produce from thin air. There are other proofs, one of which I'll be including [at the end](#alternate-proof). My proof leads us down a path which stops at quite a few interesting and beautiful places, but the alternate proof is more direct. Hopefully you will see the value in both.

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

So in fact, if $G$ has density zero, so does every intersection $kA \cap jA$ for distinct $k, j$, so $A \perp \mathbb N$.

---

Next we want to attempt to relate this to the density of $A$. How can we do this?

Pick your favorite large integer $k$ and let $R_0$ be the set of all the naturals coprime to everything up to $k$.  
Factor $k! = p_1^{e_1} p_2^{e_2} \ldots p_j^{e_j}$, where $j = \pi(k)$.  
We'll let $R_1$ be the set of all the naturals whose $p_i$-exponent is divisible by $e_i+1$.  
Finally let $R_2$ be the set of all the divisors of $k!$.

We see that $A \perp R_2$ (since $A \perp \mathbb N$), and we see $R_0 \times R_1 \times R_2 = \mathbb N$.  
Moreover, every product $r_0 r_1 r_2$ is unique, so that $R_0 \perp R_1$ and $(R_0 \times R_1) \perp R_2$.[^1]

The plan is to show that $\dsup(A) \leq \dsup(R_0 \times R_1)$, and that $\dsup(R_0 \times R_1)$ goes to zero as $k \to \infty$.

> **Lemma 8.** The set $R_0 \times R_1$ has a natural density, which equals $H(R_2)^{-1}$.  
> Also, $H(R_2) \geq 1 + \frac{1}{2} + \ldots + \frac{1}{k} \to \infty$.

_Proof._ First, $R_0$ is periodic mod $k!$ and so has a nonzero natural density.  
Then by Lemma 7, since $R_0 \perp R_1$, the set $R_0 \times R_1$ has a natural density.

Finally since $(R_0 \times R_1) \perp R_2$, by Lemma 7 we have $\dnat(R_0 \times R_1) H(R_2) = \dnat(\mathbb N) = 1$.

The lemma's inequality is simply because every natural up to $k$ is a divisor of $k!$. $\proofqed$

To finish the proof, we need to show that $\dsup(A) \leq \dsup(R_0 \times R_1)$. This is not too hard:

> **Lemma 9.** Suppose $U$ and $V$ are sets of naturals such that $U \times V = \mathbb N$, where $V$ is finite.  
> Then, if $A \perp V$, we have $\dsup(A) \leq \dsup(U)$.

_Proof._ First, we reduce to the case where $A$ has fully disjoint $V$-dilations.   
Let $A'$ be the set

$$A' = A - \bigcup_{\substack{v_1, v_2 \in V \\ v_1 \neq v_2}}\frac{1}{v_1}\left(v_1 A \cap v_2 A\right)$$

Intuitively, we look at all of the intersections $v_1 A \cap v_2 A$ and throw out the offending elements of $A$.

Since $\dnat(v_1 A \cap v_2 A) = 0$, we have $\dsup(A) = \dsup(A')$.

So now we can move forward assuming that $A$ has disjoint $V$-dilations.

The next step is to construct an injective map $\phi: A \to U$ with $\phi(a) \leq a$.  
With such a map, we would have $A(n) \leq \lbrack\phi(A)\rbrack(n) \leq U(n)$, so $\dsup(A) \leq \dsup(U)$.

For each $a \in A$, let $\phi(a)$ be the smallest $u \in U$ such that $a \in uV$.  
At least one $u$ must exist. That $\phi(a) \leq a$ is obvious, since $a = \phi(a)v$ for some $v$ in $V$.

Now suppose $\phi(a_1) = \phi(a_2) = u$ for some distinct $a_1, a_2$ in $A$.  
Then $a_1 = uv_1$ and $a_2 = uv_2$ for some $v_1, v_2$ in $V$.  
But then $v_2a_1 = v_1a_2$ and so $v_1A$ and $v_2A$ are not disjoint.

Since this is a contradiction, $\phi$ is injective. $\proofqed$

To finish the proof of the GCD problem we need to show $\dsup(A) \leq \dsup(R_0 \times R_1)$.

Set $U = R_0 \times R_1$ and $V = R_2$ in Lemma 9, and we are done!

---

Now let's look at a fun corollary:

> **Corollary 1.** Let $\mathbb P_k$ be the set of integers with at most $k$ prime factors.  
> Then $\dnat(\mathbb P_k) = 0$ for all $k$. In particular, the primes have density zero.

_Proof._ This is clearly true for $k = 0$, for which $\mathbb P_0 = \{1\}$.

It's time for induction. Suppose $\dnat(\mathbb P_{k-1}) = 0$.  
The GCD of any two naturals in $\mathbb P_k$ has strictly less than $k$ prime factors, and is therefore in $\mathbb P_{k-1}$.  
A bit more thinking shows that if $A = \mathbb P_k$, then $G = \mathbb P_{k-1}$.  
Since $\dnat(G) = 0$, we have $\dnat(A) = 0$. $\proofqed$

This was essentially my motivation for this problem and for working with density at all. I had started playing with this corollary and trying to find ways to prove it relying as heavily on density as I could during late high school, and eventually found this proof structure.

Well actually, I attempted to use the following conjecture:

> **Conjecture 1.** Suppose $A \perp B$. Then $\dsup(A) \leq H(B)^{-1}$.  
> When $H(B) = \infty$, the conclusion is $\dsup(A) = 0$.

Note the similarity to Lemma 5.

It was just too elegant not to try to prove. As of now I haven't seen a proof that works in all cases.

The GCD problem as we saw followed from the $A \perp \mathbb N$ case.  
The astute reader will notice that, in fact, we proved the conjecture whenever $B$ was the set of divisors of some integer, or more generally whenever we can come up with a set $U$ with disjoint $B$-dilations satisfying $U \times B = \mathbb N$ and $\dnat(U)H(B) = 1$. These have been the easiest cases to prove.

Future blog posts will dig into some other special cases of this conjecture, using nice geometric ideas and probability theory. Anyone able to prove the conjecture for any interesting $B$ should contact me!

---

## Alternate Proof

The following proof of [the original GCD problem](#gcd-problem) is due to [Project Euler][2] user [tb65536][4].  

<!-- We need the following lemma about prime numbers:

> **Lemma 10.** For all $n$, we have
> 
$$\prod_{p \leq n} \left(1 + \frac{1}{p}\right) \geq \sum_{p \leq n} \frac{1}{p}$$
> 
> And as $n$ tends to infinity, so does $\prod_{p \leq n} \left(1 + \frac{1}{p}\right)$. -->

<!-- It's pretty simple to prove this, especially if you assume that the sum of reciprocals of primes diverges. There are quite a few nice proofs of this fact which you can read about [on Wikipedia][3]. The inequality there is obvious if you expand out the product: $1/p$ appears as a term for every prime $p$. -->

It proceeds by contrapositive. We will assume that $\dsup(A) > 0$ and prove that $\dsup(G) > 0$.

We're going to be putting all of the integers in $A$ into buckets such that there are asymptotically very many buckets, and that many buckets will give rise to unique elements of $G$.

We will use some of the same setup as the first proof:

Pick your favorite large integer $k$ and let $R_0$ be the set of all the naturals coprime to everything up to $k$.  
Factor $k! = p_1^{e_1} p_2^{e_2} \ldots p_j^{e_j}$, where $j = \pi(k)$.  
Let $R_1$ be the set of all the naturals whose $p_i$-exponent is divisible by $e_i+1$.  
Let $R_2$ be the set of all the divisors of $k!$.

Suppose that we have an element $a$ of $A$. Since $R_0 \times R_1 \times R_2 = \mathbb N$, there is a unique integer $r \in R_0 \times R_1$ such that the dilation $r R_2$ contains $a$. This value $r$ will be the bucket representative for $a$.

Recall from Lemma 8 that the density of $R_0 \times R_1$, the set of bucket representatives, is $H(R_2)^{-1}$.  
Therefore, the number of bucket representatives up to $n$ is asymptotically

$$n \cdot \prod_{p \leq T} \left(1 + \frac{1}{p}\right)^{-1}$$

We have one last property of this setup to verify.

> **Lemma 12.** Bucket membership is closed under $\gcd$:  
> If $a_1$ and $a_2$ are in the same bucket, then $\gcd(a_1, a_2)$ would be in that bucket too.

_Proof._ There is a bucket representative $r \in R_0 \times R_1$ so that $a_1, a_2 \in r R_2$.  
Write $a_1 = r t_1$ and $a_2 = r t_2$ for $t_1, t_2 \in R_2$.  
Then $\gcd(a_1, a_2) = r \gcd(t_1, t_2)$ is also a member of $r R_2$, since $\gcd(t_1, t_2)$ divides $k!$. $\proofqed$

We're ready to prove the GCD problem now.

Choose a value of $k$ large enough so that $H(R_2)^{-1} < \dsup(A)$.  
This is possible by Lemma 10.

Let's write $\delta = H(R_2)^{-1}$.

The number of bucket representatives up to $n$ is asymptotically $\delta n$.  
Also, each bucket contains at most $|R_2| = \sigma_0(k!)$ elements of $A$.[^2]

Now pick any $\varepsilon > 0$, and assume that $n$ is an arbitrarily large integer such that $A(n) \geq (\dsup(A)-\varepsilon)n$.  
The goal is to prove that $\limsup G(n)/n > 0$.

Consider the set of buckets which contain only a single element of $A$ up to $n$.  
Pick $n$ large enough so that there are at most $(\delta+\varepsilon)n$ bucket representatives.  
Then the number of elements outside these buckets is at asymptotically at least

$$A(n) - (\delta+\varepsilon) n \geq (\dsup(A) - \delta - 2\varepsilon)n$$

Pick $\varepsilon$ small enough so that $\dsup(A) - \delta - 2\varepsilon > 0$.

All the rest of these elements have to be in buckets which are not singletons.  
How many buckets must there be?  
Since each one has at most $\sigma_0(k!)$ elements, the number of such buckets is at least

$$\frac{\dsup(A)-\delta-2\varepsilon}{\sigma_0(k!)}n$$

In each such bucket, we can pick two distinct $a_1, a_2 \leq n$ and produce $\gcd(a_1, a_2) \in G$.  
These GCDs we're generating are no greater than $n$.  
Thanks to Lemma 12, they are also all distinct, and so we have

$$G(n) \geq \frac{\dsup(A)-\delta-2\varepsilon}{\sigma_0(k!)}n$$

Remember that this is not for all $n$ but only those $n$ satisfying $A(n) \geq (\dsup(A)-\varepsilon)n$.

We immediately have 

$$\dsup(G) \geq \frac{\dsup(A)-\delta-2\varepsilon}{\sigma_0(k!)} > 0$$

which completes the proof. $\proofqed$



[1]: https://en.wikipedia.org/wiki/Natural_density
[2]: https://projecteuler.net/about
[3]: https://en.wikipedia.org/wiki/Divergence_of_the_sum_of_the_reciprocals_of_the_primes
[4]: https://math.berkeley.edu/~tb65536/index.html
[5]: http://catb.org/jargon/html/E/exercise--left-as-an.html

[^1]: Check this yourself: examine the $p_i$ exponent in the prime factorization of numbers in $n$. If $i \leq j$, it follows from taking the quotient and remainder of the exponent mod $e_i + 1$.

[^2]: Here, $\sigma_0(k!)$ is the number of divisors of $k!$.