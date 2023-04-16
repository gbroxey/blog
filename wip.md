---
title: "Nearly Disjoint Dilations: Primes"
tags: [number theory, density]
---

> **Abstract.** I'll prove that if $A$ has nonzero upper density, there are primes $p < q$ so that the intersection $pA \cap qA$ has nonzero upper density. We can also choose $p$ and $q$ to be very close to each other in some specific ways. The proof will be probabilistic.

---

[Last time](/blog/2023/04/13/density-gcds.html), we defined upper and lower density and some of its nice properties. You should read that post before this one because at least a few ideas will be repeated here.

Recall that we defined $A \perp B$ to mean that, for any distinct $b_1, b_2$ in $B$, the intersections $b_1A \cap b_2A$ always have density zero. In other words, $A$ has nearly disjoint $B$-dilations.  
We also defined $H(B)$ to be the sum $\sum 1/b$, or $H(B) = \infty$ if the sum diverges.  

The important conjecture of the previous post was the following:

> **Conjecture 1.** Suppose $\newcommand{\NN}{\mathbb N}
\newcommand{\PP}{\mathbb P}
\newcommand{\dnat}{\mathrm d}
\newcommand{\dsup}{\overline{\mathrm d}}
\newcommand{\dinf}{\underline{\mathrm d}}
\newcommand{\proofqed}{\quad\quad\quad\square}A \perp B$. Then $\dsup(A) \leq H(B)^{-1}$.  
> When $H(B) = \infty$, the conclusion is $\dsup(A) = 0$.

We proved the conjecture in the case that $B$ was the set of divisors of some integer, which also implied by a limiting argument the case $B = \NN$. Many cases remain unclear.

Today we'll prove the conjecture assuming that $H(B) = \infty$ and that the elements of $B$ are pairwise coprime. Pretty clearly the case $B = \PP$ follows.

It's interesting to notice that this case can be worded as follows:

> **Corollary.** Suppose $\dsup(A) > 0$.  
> Then there are primes $p < q$ so that $\dsup(pA \cap qA) > 0$.  
> In other words, the equation $pa_1=qa_2$ has many, many solutions with $a_1, a_2 \in A$, so many that the set of $a_1$-values which work form a subset of $A$ with nonzero upper density.

It seems very interesting. How could we prove this?

Let's look at Lemma 9 from the previous post.

> **Lemma 9.** Suppose $U$ and $V$ are sets of naturals such that $U \times V = \mathbb N$, where $V$ is finite. Then, if $A \perp V$, we have $\dsup(A) \leq \dsup(U)$.

In the case of the primes, we'd want $U \times \PP = \NN$ for a set $U$ of exceptionally low density.  
Is something like that possible?

Suppose that we pick $\varepsilon > 0$ and look at a generic set $U$ with density $\varepsilon$.  
What's the probability an integer $n$ is included in $U \times \PP$?  
If $n$ has $k$ prime factors, it'd be something like $1-(1-\varepsilon)^k$.  
Only a density zero subset of the naturals have less than $k$ prime factors (see [Corollary 1](/blog/2023/04/13/density-gcds.html) near the end), so we can pick a really big $k$ and then $U \times \PP$ should have density close to $1$.

Aside from handwaving away almost every important detail in the proof, this approach works!  
The biggest issue here is of course the idea of picking a random set of naturals with a certain density. The infiniteness of the naturals makes things very ugly for us.

Instead, the plan will be to look at large prefixes of $A$ and finding a nice random looking prefix of $U$ which has low density, but such that $U \times \PP$ has density near $1$. That way we can hopefully rely on nice finite probability distributions.

The second biggest issue is that Lemma 9 only applies to finite sets $V$, and unfortunately the set of primes is infinite. The fix here is to take as $V$ large subsets of the primes and be careful with our estimates.

---

For the following, $B$ is a set of pairwise coprime naturals such that $H(B) = \infty$.

We're going to start with some lemmas which will assist us with using only finitely many primes.  
To avoid confusion with the lemmas we'll reference from the previous post we'll start numbering with..

> **Lemma 13.** For any set of naturals $S$, we have
> 
$$\prod_{x \in S} \frac{x-1}{x} \leq \exp[-H(S)]$$

_Proof._ Use $1+y \leq e^y$ applied to $y = -\frac{1}{x}$. $\proofqed$

> **Lemma 14.** Suppose $S$ is a finite set of pairwise coprime naturals, not containing $1$.  
If $\NN_k^S$ is the set of integers divisible by exactly $k$ members of $S$, then  
> 
$$\dnat(\NN_k^S) \leq (H(S) + 1)^k \exp \lbrack -H(S) \rbrack$$

_Proof._ That this density exists follows from easy applications of lemmas we've used in the previous post - if you're uneasy about this try it yourself.  
We'll show the bound by direct algebraic manipulation.

Let $K$ vary over the subsets of $S$ of size $k$. Add the proportion of integers divisible by all the elements of $K$ and none of the elements of $S-K$:

$$\begin{align*}
\dnat(\NN_k^S) &= \sum_{\substack{K \subseteq S \\ |K| = k}} \prod_{x \in K} \frac{1}{x} \prod_{x \in (S - K)} \frac{x-1}{x}\\
&= \sum_{\substack{K \subseteq S \\ |K| = k}} \prod_{x \in K} \frac{1}{x-1} \prod_{x \in S} \frac{x-1}{x}\\
&= \left(\sum_{\substack{K \subseteq S \\ |K| = k}} \prod_{x \in K} \frac{1}{x-1}\right)\left(\prod_{x \in S} \frac{x-1}{x}\right) \\
&\leq \left(\sum_{x \in S} \frac{1}{x-1}\right)^k\left(\prod_{x \in S} \frac{x-1}{x}\right) \leq \left(H(S) + 1\right)^k \exp\left[-H(S)\right] 
\end{align*}$$

The second line follows by inspection.  
The first inequality in the last line follows from noting that when expanding the product, $\prod_{x \in K} \frac{1}{x-1}$ appears as a term for each $|K| = k$. The second inequality follows from

$$\sum_{x \in S} \frac{1}{x-1} = \sum_{x \in S} \frac{1}{x} + \sum_{x \in S} \frac{1}{x(x-1)} \leq H(S) + 1$$

and Lemma 13. $\proofqed$

This is in general a terrible upper bound on $\dnat(\NN_k^S)$, usually providing no nontrivial information. However, it does provide nice results as $H(S)$ becomes extremely large:

Fix $k$ and pick large finite subsets $S$ of $B$. Then since $H(S) \to \infty$ and since $(1+y)^k e^{-y} \to 0$ as $y$ tends to infinity, as $H(S)$ gets extremely large we will have $\dnat(\NN_k^S) \to 0$.

We can deduce $\dnat(\NN_k^B) = 0$ by writing $\NN_{\leq k}^S = \bigcup_{j \leq k} \NN_j^S$ for the set of integers divisible by at most $k$ distinct members of $S$. Then since $\NN_{\leq k}^B \subseteq \NN_{\leq k}^S$ for all $S \subseteq B$, and since for each fixed $k$ we have

$$\dnat(\NN_{\leq k}^S) \leq \sum_{j \leq k} \dnat(\NN_j^S) \to 0$$

we must have $\dnat(\NN_{\leq k}^B) = \dnat(\NN_k^B) = 0$.

Before we proceed we should make clear a reduction we've used before.

> **Lemma 15.** Suppose $A \perp S$ for some finite $S$.  
> Then there exists a set $A' \subseteq A$ with $\dsup(A) = \dsup(A')$ such that $A'$ has disjoint $S$-dilations.
> Therefore if we only care about bounding the upper or lower density of $A$, we are safe to assume that every product $a*s$ for $a \in A$ and $s \in S$ is unique.

_Proof._ The logic we use here was used in Lemma 9. I'll repeat it here.

Let $A'$ be the set

$$A' = A - \bigcup_{\substack{u_1, u_2 \in V \\ u_1 \neq u_2}}\frac{1}{u_1}\left(u_1 A \cap u_2 A\right)$$

Intuitively, we look at all of the intersections $u_1 A \cap u_2 A$ and throw out the offending elements of $A$.

Since $\dnat(u_1 A \cap u_2 A) = 0$, we have $\dsup(A) = \dsup(A')$. $\proofqed$

Now we can come to the most important lemma:

> **Lemma 16.** Assume $A \perp S$, where $S$ is a finite set of naturals.  
Also let $\varepsilon > 0$ and $0 \leq k \leq |S|$ be arbitrary. Then
> 
$$\dsup(A) \leq 2\varepsilon + \left(1-\frac{\varepsilon^2}{2}\right)^{k+1} + \dnat(\NN_{\leq k}^S)$$

This is shown by probabilistically proving the existence of a sparse (expected density $\frac{\varepsilon^2}{2}$, but in reality we only guarantee density $\varepsilon$) set $U$ such that $U \times S$ approximately contains $A$.  
Then, by an argument similar to that in Lemma 9, we show that we can essentially divide out $S$ and that $A$ is at most as big as $U$.

This actually only accounts for the $O(\varepsilon)$ term. Errors incurred, from the fact that $U \times S$ may in fact fail to contain a significant portion of $A$, give us the other terms. Specifically the latter two terms give an upper bound on the size of the complement of $U \times S$ (an extra $\varepsilon$ is also incurred here).

The other small problem we have to get around is that we can't probabilistically construct the entire set $U$, but only prefixes. The same logic above applies, however.

When $\varepsilon$ is chosen optimally this bound behaves roughly like $O\left(\sqrt{\frac{\log(k)}{k}}\right) + \dnat(\NN_{\leq k}^S)$.

_Proof._ Write $[n]$ for the set $\{1, 2, \ldots, n\}$, and also assume by Lemma 3 that, without any loss of generality, for any $s_1 < s_2 \in S$, we have $s_1 A \cap s_2 A = 0$.

Let $U_{\leq n}$ be a a random variable whose values are subsets of $[n]$ with expected size $\frac{\varepsilon^2}{2}n$.  
More specifically[^1] each integer $x \leq n$ should be independently included with probability $\frac{\varepsilon^2}{2}$.

We can lower bound the expectation $E(\left\vert (U_{\leq n} \times S) \cap [n]\right\vert )$ by noticing that among the approximately $(1-\dnat(\NN_{\leq k}^S) - o_{k}(1))n$ integers up to $n$ which are divisible by more than $k$ distinct members of $S$, the probability of inclusion in $U_{\leq n} \times S$ is at least $1 - (1-\frac{\varepsilon^2}{2})^{k+1}$.

Therefore we have the inequality

$$\begin{align*}
E(\left\vert (U_{\leq n} \times S) \cap [n]\right\vert ) &\geq \left[1 - \left(1-\frac{\varepsilon^2}{2}\right)^{k+1}\right](1-\dnat(\NN_{\leq k}^S) - o_{k}(1))n\\
&\geq n - \left(\dnat(\NN_{\leq k}^S) + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1}\right)n - o_k(n)
\end{align*}$$

Now we need to show we can actually choose a specific set $U_{\leq n} \subseteq [n]$ (by abuse of notation) which is small and such that $U_{\leq n} \times S$ is as large as it is expected to be.

The probability $\left\vert U_{\leq n}\right\vert $ is at least $\varepsilon n$ is, by Markov's inequality, at most $(\varepsilon^2 n/2)/(\varepsilon n) = \varepsilon/2$.

Next we estimate the probability $U_{\leq n} \times S$ is large.

Write $X$ for the random variable $\vert (U_{\leq n} \times S) \cap [n]\vert $. We can't quite guarantee $U_{\leq n}$ is small and that $X$ is at least its mean, but what we can do is guarantee that $X$ can be decently close to its mean.

By Markov's inequality applied to $n-X$, we have

$$\begin{align*}
    \Pr\left(n - X \geq \frac{1}{1-\varepsilon} (n - E[X])\right) &\leq 1-\varepsilon\\
    \Pr\left(\left[1 - \frac{1}{1-\varepsilon}\right]n + \frac{1}{1-\varepsilon}E[X] \geq X\right) &\leq 1-\varepsilon\\
    \Pr\left(\left[1 - \frac{1}{1-\varepsilon}\right]n + \frac{1}{1-\varepsilon}E[X] \leq X\right) &\geq \varepsilon
\end{align*}$$

Multiply through that inequality by $1-\varepsilon$ and increase the right hand side from $(1-\varepsilon)X$ to $X$ to make later use a little simpler:
$$\Pr\left(-\varepsilon n + E[X] \leq X\right) \geq \varepsilon$$
This is where the extra $\varepsilon$ term comes from in the bound we're proving - it's a fudge factor that lets us guarantee that $U_{\leq n}$ can be small and, simultaneously, $U_{\leq n} \times S$ can be large.

The probability that the above inequality in $X$ holds AND $\vert U_{\leq n}\vert  \leq \varepsilon n$ is at least 

$$\varepsilon - \varepsilon/2 = \varepsilon/2 > 0$$

Therefore for each $n$, there must be at least one set $U_{\leq n}$ that achieves both inequalities.

So choose each $U_{\leq n}$ such that $\vert U_{\leq n}\vert  \leq \varepsilon n$ and

$$\left\vert (U_{\leq n} \times S) \cap [n]\right\vert  \geq n - \left(\varepsilon + \dnat(\NN_{\leq k}^S) + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1}\right)n - o_k(n)$$

Next we measure the degree to which $U_{\leq n} \times S$ covers $A$. We'll assume thanks to Lemma 15 that products $a*s$ are unique, where $a \in A$ and $s \in S$.

Let $A'$ be the set $A \cap (U_{\leq n} \times S) \subseteq A$. This has

$$\begin{align*}
    \vert A' \cap [n]\vert  &\geq \vert A \cap [n]\vert  - \left(n - \vert (U_{\leq n} \times S) \cap [n]\vert \right)\\
    &\geq \vert A \cap [n]\vert  - \left(\varepsilon + \dnat(\NN_{\leq k}^S) + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1}\right)n - o_k(n)
\end{align*}$$

To obtain a bound on the size of $A'$, we'll use the logic from the proof of Lemma 9 to show that it is at most as large as $U$. Suppose, for some $u \in U_{\leq n}$, the set $A' \cap uS$ contains more than one distinct element, say $us_1$ and $us_2$ are both in $A'$. Then $(us_2)s_1 = (us_1)s_2$, which implies $s_1 = s_2$ by the unique products property, so they must have been the same element to start with.

So then since each $A' \cap uS$ has at most one element, and since each element of $A'$ must correspond to at least one $u$ (because $A' \subseteq U_{\leq n} \times S$), we have the inequality $\vert A' \cap [n]\vert  \leq \vert U_{\leq n}\vert  \leq \varepsilon n$.

Putting this together with the previous inequality and taking $n \to \infty$ gives us the lemma:

$$\dsup(A) \leq 2\varepsilon + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1} + \dnat(\NN_{\leq k}^S)$$

$\proofqed$

We're now in a position to prove Conjecture 1 in the case $H(B) = \infty$ with $B$ coprime.

> **Theorem 1.** If $A \perp B$, and $B$ is a set of coprime naturals with $H(B) = \infty$, then $\dnat(A) = 0$.

_Proof._ Again let $S$ be large finite subsets of $B$, such that $\dnat(\NN_{\leq k}^{S}) \to 0$.

Then, using Lemma 16 and letting $H(S) \to \infty$, we have (for any $\varepsilon > 0$ and $k \geq 0$)

$$\dsup(A) \leq 2\varepsilon + \left(1-\frac{\varepsilon^2}{2}\right)^{k+1}$$

If $\varepsilon$ is fixed and nonzero, we can let $k \to \infty$ to get $\dsup(A) \leq 2\varepsilon$. Now just let $\varepsilon \to 0$. $\proofqed$

So, the proof of this case has ended up conceptually very similar to the previous one, but only technically much more complicated.

One thing we can notice is that, in Lemma 16, we don't really need all of the elements of $S$ to be in a single set. Here's what I mean:

> **Lemma 17.** Suppose we have a collection of $m$ sets, $S_1, \ldots, S_m$, each with $A \perp S_i$.  
> Write $S = \bigcup S_i$ for their union. Then if $\min S \geq m$, the inequality in Lemma 16 holds.  
> That is, if $\varepsilon > 0$ and $0 \leq k \leq |S|$ are arbitrary, then
> 
$$\dsup(A) \leq 2\varepsilon + \left(1-\frac{\varepsilon^2}{2}\right)^{k+1} + \dnat(\NN_{\leq k}^S)$$

We will have a slightly different construction of $U_{\leq n}$ so that the elements satisfying $u \min S > n$ are not included. This way $U_{\leq n}$ will be much smaller, but $U_{\leq n} \times S$ will still approximately contain $A$.

_Proof._ We will verify the important points of the new definition of $U_{\leq n}$ and the probability computations necessary to ensure its existence.  
Specifically, for each $u \leq n/\min(S)$, include it with probability $\frac{\varepsilon^2}{2}$.

We have $E\left(\vert U_{\leq n}\vert\right) \leq \frac{\varepsilon^2}{2} \cdot \frac{n}{\min(S)}$, and Markov says

$$\Pr(\vert U_{\leq n}\vert \geq \varepsilon \cdot \frac{n}{\min(S)}) \leq \frac{\varepsilon}{2}$$

Now, the exact same lower bound on the expectation of $\left\vert(U_{\leq n} \times S) \cap [n]\right\vert$ works, since any integer of the form $u \times s$ in the set must necessarily have $u \leq n/\min(S)$.

Following identical Markov considerations, we can produce sets $U_{\leq n} \subseteq [n/\min(S)]$ which satisfy

$$\begin{align*}
    \vert U_{\leq n}\vert &\leq \varepsilon \cdot \frac{n}{\min(S)}\\
    \left\vert(U_{\leq n} \times S) \cap [n]\right\vert &\geq n - \left(\varepsilon + \dnat(\NN_{\leq k}^S) + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1}\right)n - o_k(n)
\end{align*}$$

Again letting $A' = A \cap (U_{\leq n} \times S)$, we have as before

$$\vert A' \cap [n]\vert \geq \vert A \cap [n]\vert - \left(\varepsilon + \dnat(\NN_{\leq k}^S) + \left(1 - \frac{\varepsilon^2}{2}\right)^{k+1}\right)n - o_k(n)$$

Now, for each $1 \leq i \leq m$, let

$$A'_i = A \cap (U_{\leq n} \times S_i)$$

such that $A' \subseteq \bigcup A'_i$. Then for the reasons given in Lemma 16, we have 

$$\vert A'_i \cap [n]\vert \leq \vert U_{\leq n}\vert$$

so that $\vert A' \cap [n]\vert \leq m \vert U_{\leq n}\vert$.

Since $m \leq \min(S)$ we have $\vert A' \cap [n]\vert \leq \varepsilon n$.  
The rest of the proof is identical to the one given before. $\proofqed$

I want to put a note here that we can't actually use arbitrary singletons for $S_i$ (for which $A \perp S_i$ vacuously) and expect to produce any sort of meaningful result. The fact that we need $\min(S) \geq m$ means that we'd have $H(S) \leq \log(2)$ or so, which is insufficient to prove $\dnat(\NN_{\leq k}^S)$ is close to zero.

This does, however, allow us to prove things entirely out of reach of Lemma 16.

> **Corollary 2.** Suppose $\dsup(A) > 0$.  
> There are constants $t > 0$ and $K > 0$ so that the following holds.  
> One may find primes $p < q < p + Kp^{1-t}$ such that $\dsup(pA \cap qA) > 0$.

_Proof._ First note that the sum of $1/p$ over primes in the range $[n, n+Kn^{1-t}]$ in fact tends to zero with $n$, so Lemma 16 is utterly useless here if applied directly.

Suppose $n$ is large and consider the sets $S_n = \mathbb P \cap [n, n^c)$ where $c > 1$ is big.

Elementary considerations show $H(S_n) \to \log(c)$, but using Lemma 16 here is not quite enough to show the primes it produces are as close together as we want them to be.

Instead we split $S_n$ into $n$ sets $S_{n,1}, S_{n,2}, \ldots S_{n,n}$ in the manner

$$S_{n,j} = \mathbb P \cap [n^{c(j-1)/n}, n^{c{j/n}})$$

If $A \perp S_{n,j}$ for all $k$, then by Lemma 17 as $n \to \infty$ we would have

$$\dsup(A) \leq 2\varepsilon + \left(1-\frac{\varepsilon^2}{2}\right)^{k+1} + (H(S_n)+1)^k \exp\lbrack-H(S_n)\rbrack$$

Pick $c$ large enough so that $(H(S_n)+1)^k \exp\lbrack-H(S_n)\rbrack <  \varepsilon$ for all large $n$. Then

$$\dsup(A) \leq 3\varepsilon + \left(1-\frac{\varepsilon^2}{2}\right)^{k+1}$$

Again here we can let $k \to \infty$ first and then $\varepsilon \to 0$.

Thus for large $n$ there are $k$ and two distinct primes $p < q$ in $S_{n, k}$ with $pA \cap qA \neq \emptyset$.

Now $q/p$ is bounded above by

$$\frac{q}{p} \leq n^{c/n} = 1 + O\left(\frac{\log(n)}{n}\right) = 1 + O\left(\frac{\log(p)}{p^{1/c}}\right)$$

We can write this as $q \leq p + O(p^{1-\frac{1}{c}}\log(p)) = p + O(p^{1-\frac{1}{2c}})$, so we can take $t = \frac{1}{2c}$ in the statement of the theorem, and we're done. $\proofqed$

We should notice that the values of $t$ and $K$ depend on the upper density of $A$.


[^1]: Rigorously, define $n$ independent, set valued random variables $x_1, x_2, \ldots, x_n$ such that $x_i = \{i\}$ with probability $\frac{\varepsilon^2}{2}$ and $x_i = \emptyset$ otherwise. Then define $U_{\leq n} = \bigcup_{i \leq n} x_i$.