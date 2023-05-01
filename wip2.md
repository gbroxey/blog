---
title: "Nearly Disjoint Dilations: {1, 2, 3}"
---

> **Abstract.** Returning to density, I'll prove that if $A, 2A, 3A$ are disjoint, then $\newcommand{\NN}{\mathbb N}
\newcommand{\PP}{\mathbb P}
\newcommand{\dnat}{\mathrm d}
\newcommand{\dsup}{\overline{\mathrm d}}
\newcommand{\dinf}{\underline{\mathrm d}}
\newcommand{\proofqed}{\quad\quad\quad\square}\dsup(A) \leq 6/11$.  
This proof will extend to a bound for $\lbrace 1, p, q\rbrace$ for any $1 < p < q \leq p^2$.

---

This is the third post in a series on density.  
Read [Density and GCDs][density1] and the [Nearly Disjoint Dilations: Primes][density2] first.

Here is the conjecture we continue to contemplate:

> **Conjecture 1.** Suppose $A \perp B$. Then $\dsup(A) \leq H(B)^{-1}$.  
> When $H(B) = \infty$, the conclusion is $\dsup(A) = 0$.

At this point I'll assume you're familiar with my choice of notation.  
If you're not, then reference the previous two posts.

Our goal for today is to prove this conjecture in the case $B = \lbrace 1, 2, 3\rbrace$.  
Here we have $H(B) = 11/6$, and so we need to prove $\dsup(A) \leq 6/11$.

The first thing to notice is that thanks to [Lemma 15][density2], we can reduce the study of the case $A \perp \lbrace 1, 2, 3\rbrace$ to the case $A, 2A, 3A$ disjoint. From here on we'll assume this stronger condition.

---

We will not skip straight to my proof. Instead I'll first invite you to try to prove it yourself.

I think that most attempts at a proof for this case will slightly fall short of the desired bound. It's strange how elusive it seems to be, which is even stranger when you see my proof, which proves an even stronger bound than needed. That's actually another interesting aspect here, but not so surprising if you think about it[^1].

The first thing we could notice is that if $A \perp \lbrace 1, 2, 3 \rbrace$, then naturally $A \perp \lbrace 1, 2\rbrace$. This case is quite easy! We can for example let $U$ be the set of all $4^i * j$ for $i \geq 0$ and $j$ odd, after which $U \times \lbrace 1, 2 \rbrace = \NN$ and [Lemma 9][density1] kicks in - we get $\dsup(A) \leq \frac{2}{3}$. The details here are not hard to fill in, [Lemma 7][density1] being especially helpful.

Unfortunately though this is quite far from our desired bound. 

## Section Header

This is some [writing][reference].

---

## Code

The code for this blog post is available nowhere.[^1]

[density1]: /blog/2023/04/13/density-gcds.html
[density2]: /blog/2023/04/18/dilations-primes.html


[^1]: In the previous entries in this series, we've seen that if we have $A \times B = \NN$ such that every product $ab$ is unique (referred to by Erdős and Saffari as $A$ and $B$ being "direct factor pair"), and such that this construction is nice enough in some way, then we have $\dnat(A) = H(B)^{-1}$ exactly (see for example the analysis of $R_0 \times R_1$ in [Lemma 8 of the first post][density1], or the setup with $U$ and $V$ in [Lemma 9 of the second post][density2]). If $B$ was nicer, like $\lbrace 1, 2, 3, 6\rbrace$, then we would have an equivalently nice set $U$ so that $U \times B = \NN$ with density $H(B)^{-1}$ which would make the proof easy. Here, we should notice that $B = \lbrace 1, 2, 3 \rbrace$ does not permit such a construction. A hypothetical setup with $U \times \lbrace 1, 2, 3 \rbrace = \NN$ would force $1 \in U$, and also then $4 \in U$, but then we find it impossible to include $6 \in U$. This, in other words, is caused by the simple fact that there is no perfect tiling of a quarter plane by the L triomino.

---
