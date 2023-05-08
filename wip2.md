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
Read [Density and GCDs][density1] and [Nearly Disjoint Dilations: Primes][density2] first.

Here is the conjecture we continue to contemplate:

> **Conjecture 1.** Suppose $A \perp B$. Then $\dsup(A) \leq H(B)^{-1}$.  
> When $H(B) = \infty$, the conclusion is $\dsup(A) = 0$.

At this point I'll assume you're familiar with my choice of notation.  
If you're not, then reference the previous two posts.

Our goal for today is to prove this conjecture in the case $B = \lbrace 1, 2, 3\rbrace$.[^0]  
Here we have $H(B) = 11/6$, and so we need to prove $\dsup(A) \leq 6/11$.

The first thing to notice is that thanks to [Lemma 15][density2], we can reduce the study of the case $A \perp \lbrace 1, 2, 3\rbrace$ to the case $A, 2A, 3A$ disjoint. From here on we'll assume this stronger condition.

## Upper Density

We will not skip straight to my proof. Instead I'll first invite you to try to prove it yourself.

I think that most attempts at a proof for this case will slightly fall short of the desired bound. It's strange how elusive it seems to be, which is even stranger when you see my proof, which provides an even stronger bound than needed. That's actually another interesting aspect here, but not so surprising if you think about it[^1].

The first thing we could notice is that if $A \perp \lbrace 1, 2, 3 \rbrace$, then naturally $A \perp \lbrace 1, 2\rbrace$. This case is quite easy! We can for example let $U$ be the set of all $4^i * j$ for $i \geq 0$ and $j$ odd, after which $U \times \lbrace 1, 2 \rbrace = \NN$ and [Lemma 9][density1] kicks in - we get $\dsup(A) \leq \frac{2}{3}$. The details here are not hard to fill in, [Lemma 7][density1] being especially helpful.

Unfortunately though this is quite far from our desired bound. 

A next attempt can be made by using the counting function $A(x) = \left\vert A \cap \lbrace 1, 2, \ldots, \lfloor x \rfloor\rbrace\right\vert$.

Write $R = A\cup 2A \cup 3A$, so that $R(x) = A(x) + A(x/2) + A(x/3)$.

We'll start with the bound $R(x) - R(x/2) \leq \frac{x}{2} + 1$. Expanding the function,

$$\begin{align*}
R(x) - R(x/2) &\leq \frac{x}{2} + 1\\
A(x) + A\left(\frac{x}{2}\right) + A\left(\frac{x}{3}\right) - A\left(\frac{x}{2}\right) - A\left(\frac{x}{4}\right) - A\left(\frac{x}{6}\right) &\leq \frac{x}{2} + 1
\end{align*}$$

Since $\frac x3 > \frac x4$, the term $A(x/3) - A(x/4)$ is nonnegative and can be removed from the left hand side:

$$A(x) - A\left(\frac{x}{6}\right) \leq \frac{x}{2} + 1$$

Now substituting $x/6$:

$$A\left(\frac{x}{6}\right) - A\left(\frac{x}{6^2}\right) \leq \frac{x}{2 \cdot 6} + 1$$

And then substituting $x/6$ again, and so on, until $x/6^n < 1$, we obtain

$$\begin{align*}
A(x) &= \left\lbrack A(x) - A\left(\frac x6\right)\right\rbrack + \left\lbrack A\left(\frac x6\right) - A\left(\frac{x}{6^2}\right)\right\rbrack + \ldots + \left\lbrack A\left(\frac{x}{6^{n-1}}\right) - A\left(\frac{x}{6^n}\right)\right\rbrack\\
&\leq \left\lbrack \frac{x}{2} + 1\right\rbrack + \left\lbrack \frac{x}{2 \cdot 6} + 1\right\rbrack + \left\lbrack \frac{x}{2 \cdot 6^2} + 1\right\rbrack + \ldots + \left\lbrack \frac{x}{2 \cdot 6^{n-1}} + 1\right\rbrack\\
&\leq n + \left(\sum_{k \geq 0} \frac{1}{2 \cdot 6^k}\right)x\\
&\leq n + \frac{3}{5}x
\end{align*}$$

We only needed to simplify a geometric series to get this result. We have $n = O(\log(x))$, so

$$A(x) \leq \frac{3}{5}x + O(\log(x))$$

Thus immediately $\dsup(A) \leq \frac{3}{5} = 0.6$, which is better than $2/3$ but worse than $6/11 = 0.54\ldots$ which still is out of reach. Maybe there's some way to modify this telescoping method to get a tighter bound. Clearly there was some loss when we threw out $A(x/3) - A(x/4)$.

---

The best way that I have found to prove the desired result relies on the following idea.

> **Lemma 18.** If $S \cup T = \NN$ then $\dsup(A) \leq \dsup(A \cap S) + \dsup(A \cap T)$.

_Proof._ This is a consequence of subadditivity of lim sup (see [Lemma 2](density1)). $\proofqed$

> **Lemma 19.** If $S_1 \cup S_2 \cup \ldots = \NN$, and $\lim_{n \to \infty} \dsup(S_{n+1} \cup S_{n+2} \cup \ldots) = 0$, then
>
$$\dsup(A) \leq \sum_{k \geq 1} \dsup(A \cap S_k)$$

_Proof._ This is intuitive but actually seems subtle so I am going to give it real thought.  
Lemma 18 can be extended to families $S_1, S_2, \ldots, S_n$ without thinking by just applying it $n-1$ times.  
Now notice that

$$\NN - (S_1 \cup S_2 \cup \ldots \cup S_n) \subseteq S_{n+1} \cup S_{n+2} \cup \ldots$$

so that by Lemma 18, we have

$$\dsup(A) \leq \sum_{k \leq n} \dsup(A \cap S_k) + \dsup(S_{k+1} \cup S_{k+2} \cup \ldots)$$

If any partial sum for a given $n$ exceeds $1$ then we are trivially done. Otherwise it is bounded, and by monotonicity the sum converges to some constant $c = \sum_{k \geq 1} \dsup(A \cap S_k)$. We then have

$$\dsup(A) \leq c + \dsup(S_{k+1} \cup S_{k+2} \cup \ldots) \to c$$

and therefore that $\dsup(A) \leq \sum_{k \geq 1} \dsup(A \cap S_k)$ as desired. $\proofqed$

We will rewrite the inequality as follows when all $\dnat(S_k)$ exist:

$$\dsup(A) \leq \sum_{k \geq 1} \frac{\dsup(A \cap S_k)}{\dnat(S_k)} \cdot \dnat(S_k)$$

The conceptual reason for this may be clear.

The quantity $\frac{\dsup(A \cap S_k)}{\dnat(S_k)}$ can be interpreted as the relative density of $A$ in $S_k$.  
The strategy for the following proof is to select $S_k$ as a nice partition of $\NN$ (so that $\sum \dnat(S_k) = 1$).  
We also want the relative density of $A$ in $S_k$ to be at most $\delta \leq \frac{6}{11}$, at which point

$$\dsup(A) \leq \sum_{k \geq 1} \frac{\dsup(A \cap S_k)}{\dnat(S_k)} \cdot \dnat(S_k) \leq \sum_{k \geq 1} \delta \cdot \dnat(S_k) = \delta \cdot \sum_{k \leq 1} \dnat(S_k) = \delta \leq \frac{6}{11}$$

The problem of choosing the family of sets $S_k$ is now our focus.

It happens that the structure of these sets can be very regular.

> **Lemma 20.** Suppose $S, T_1, T_2$ are sets such that $S \perp T_1$, $S \perp T_2$, and such that $\dnat(S) > 0$ exists. Then
> 
$$\frac{\dnat(S \times T_1)}{\dnat(S \times T_2)} = \frac{\dnat(S) H(T_1)}{\dnat(S) H(T_2)} = \frac{H(T_1)}{H(T_2)}$$

_Proof._ The fact that $\dnat(S \times T_1)$ and $\dnat(S \times T_2)$ exist is guaranteed by [Lemma 7][density1].  
The rest is just calculation using Lemma 7. $\proofqed$



bla bla more connective text

The most obvious choice for a set in this family would look like $\lbrace 1, 2, 3 \rbrace$. Aside from the fact that this has zero density (which we'll ignore for a second), the densest looking subset $A$ of $\lbrace 1, 2, 3 \rbrace$, such that $A, 2A, 3A$ are disjoint, is $A = \lbrace 1 \rbrace$ or something. None of that means anything until we actually realize that we should include all of the different possible factors other than $2$ or $3$.

A set in this family then looks like $\lbrace 1, 2, 3 \rbrace \times \lbrace k \mid \gcd(k, 6) = 1 \rbrace$.  
The densest subset $A$ of this set, again with $A, 2A, 3A$ disjoint, is $\lbrace 1 \rbrace \times \lbrace k \mid \gcd(k, 6) = 1 \rbrace = \lbrace k \mid \gcd(k, 6) = 1 \rbrace$.  
This subset has relative density $\frac{1}{1 + \frac{1}{2} + \frac{1}{3}} = \frac{6}{11}$. Looks good!

Unfortunately, we are unable to create a partition of $\NN$ using sets of this shape.

---

## Lower Density

Perhaps surprisingly, we can prove a very good upper bound on the lower density of $S$ when $S \perp \lbrace 1, 2, 3 \rbrace$. This section is dedicated to providing a proof that $\dinf(S) \leq \frac{1}{2}$ in this case.

To do so, we need to introduce the concept of logarithmic density.

$$\newcommand{\ldnat}{\mathrm \delta}
\newcommand{\ldsup}{\overline{\mathrm \delta}}
\newcommand{\ldinf}{\underline{\mathrm \delta}}\begin{align*}
\ldsup(A) &= \limsup_{x \to \infty} \frac{\sum_{n \leq x,\, n \in A} \frac{1}{n}}{\log(x)}
\ldinf(A) &= \liminf_{x \to \infty} \frac{\sum_{n \leq x,\, n \in A} \frac{1}{n}}{\log(x)}
\end{align*}$$

and obviously we define $\ldnat(A) = \ldsup(A) = \ldinf(A)$ if the limit exists.

The reason for $\log(x)$ as the denominator is that it is asymptotic to $\sum_{n \leq x} \frac{1}{n}$. So logarithmic density is really just a weighted version of regular density.

Another way to think about this is in terms of random variables, which I like a lot.  
In the case of regular natural density, we're looking at uniform random variables $X$ on $\lbrace 1, 2, 3, \ldots, \lfloor x \rfloor \rbrace$, and then $\dsup(A) = \limsup \text{Pr}(X \in A)$ for example.  
For logarithmic density, instead of a uniform distribution, we have $\text{Pr}(X = n) \propto \frac{1}{n}$ for each $n \leq x$, so the variable is skewed more towards being smaller. This dampens the effects of oscillations in the set $A$, so (for example) the set $A$ of integers with an odd number of binary bits *does* have a logarithmic density, equal to $1/2$[^2].

One key property of logarithmic density we're going to use is the following:

> **Lemma TODO.** We have $\dinf(A) \leq \ldinf(A)$. Consequently, also $\dsup(A) \geq \ldsup(A)$.

---

## Code

The code for this blog post is available nowhere.

[density1]: /blog/2023/04/13/density-gcds.html
[density2]: /blog/2023/04/18/dilations-primes.html


[^0]: We actually hope to find a proof for all $B = \lbrace 1, p, q \rbrace$ where $1 < p < q$.
[^1]: In the previous entries in this series, we've seen that if we have $A \times B = \NN$ such that every product $ab$ is unique (referred to by Erdős and Saffari as $A$ and $B$ being "direct factor pair"), and such that this construction is nice enough in some way, then we have $\dnat(A) = H(B)^{-1}$ exactly (see for example the analysis of $R_0 \times R_1$ in [Lemma 8 of the first post][density1], or the setup with $U$ and $V$ in [Lemma 9 of the second post][density2]). If $B$ was nicer, like $\lbrace 1, 2, 3, 6\rbrace$, then we would have an equivalently nice set $U$ so that $U \times B = \NN$ with density $H(B)^{-1}$ which would make the proof easy. Here, we should notice that $B = \lbrace 1, 2, 3 \rbrace$ does not permit such a construction. A hypothetical setup with $U \times \lbrace 1, 2, 3 \rbrace = \NN$ would force $1 \in U$, and also then $4 \in U$, but then we find it impossible to include $6 \in U$. This, in other words, is caused by the simple fact that there is no perfect tiling of a quarter plane by the L triomino.
[^2]: See the first section of [Density and GCDs][density1].
---
