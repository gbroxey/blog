---
title: "Summing Multiplicative Functions"
---

A function $f(n)$ which maps the naturals to the set of complex numbers is called "multiplicative" if $f(mn) = f(m)f(n)$ for any $m, n$ such that $\gcd(m, n) = 1$. There are a few obvious examples and a few less obvious examples:

- $I(1) = 1$ and $I(n) = 0$ for $n > 1$
- $u(n) = 1$ for all $n$
- $N(n) = n$ for all $n$
- $d(n)$, the number of divisors of $n$
- $\sigma_\alpha(n)$, the sum of $d^\alpha$ over all divisors $d$ of $n$
- $\mu(n)$, the [Möbius function][mobius]
- $\varphi(n)$, the [totient function][totient]

Some of these are also completely multiplicative, meaning that $f(mn) = f(m)f(n)$ even if $\gcd(m, n) > 1$. This is true of $u$ and $N$ but not of the rest.

One operation which is incredibly helpful in the context of multiplicative functions is Dirichlet convolution, defined as

$$(f*g)(n) = \sum_{ab=n} f(a)g(b)$$

This convolution has some nice properties:

- The function $I$ is an identity: $I*f = f$ for all $f$
- $\mu$ and $u$ are inverses: $u*\mu = I$
- If $f$ and $g$ are multiplicative, then so is $f*g$

For more context about this convolution and its properties read the first few chapters of Apostol's book Intro to Analytic Number Theory.

We'll treat these functions as coefficients of a Dirichlet series:

$$L_f(s) = \sum_{n \geq 1} \frac{f(n)}{n^s}$$

The reason to do this is clear when we realize that 

$$L_f(s) L_g(s) = L_{f*g}(s)$$

This immediately gets us the Dirichlet series representations for a few functions:

$$\begin{align*}
L_I(s) &= 1\\
L_u(s) &= \zeta(s)\\
L_\mu(s) &= 1/\zeta(s)\\
L_N(s) &= \zeta(s-1)\\
L_\varphi(s) &= \zeta(s-1)/\zeta(s)\\
L_d(s) &= \zeta(s)^2
\end{align*}$$

Very frequently things will be expressed in terms of the [Riemann zeta function][zeta] as you can see. Other times, especially when there is some sort of dependence on remainders mod a small value, you'll see the series for [Dirichlet characters][characters] pop up as well.

A computational problem which pops up a lot is computing the partial sum $F(x) = \sum_{n \leq x} f(n)$ for a given multiplicative function $f$. In general this is difficult, but there are techniques we can use depending on the function given to us.

---

## Techniques

I'm going to avoid spending time on explaining how to compute summations of functions like $u$ or $N$, since those are doable in constant time. If you don't know how to do those you should look that up elsewhere first before moving forward.

The easiest function I've mentioned so far, other than those, is the divisor count $d(n)$.

### Dirichlet Hyperbola Method

Our goal is to compute $D(x) = \sum_{n \leq x} d(n)$, hopefully in time faster than $O(x)$.  
This is essentially explained in Apostol's book, and enables us to figure out $D(x)$ in $O(\sqrt{x})$ time.

This technique supposes that we have functions $f$ and $g$ so that we want to sum $f\ast g$. In this first case we have $f=g=u$ so that $f\ast g = u\ast u = d$. Now set $\alpha\ast\beta = x$, and write

$$\begin{align*}
\sum_{n \leq x} (f*g)(n) &= \sum_{n \leq x} \sum_{ab = n} f(a)g(b)\\
&= \sum_{ab \leq x} f(a)g(b)\\
&= \sum_{a \leq \alpha} \sum_{b \leq x/a} f(a)g(b) + \sum_{b \leq \beta} \sum_{a \leq x/b} f(a)g(b) - \sum_{\substack{a \leq \alpha\\ b \leq \beta}} f(a)g(b)\\
&= \sum_{a \leq \alpha} f(a)G(x/a) + \sum_{b \leq \beta} F(x/b)g(b) - F(\alpha)G(\beta)
\end{align*}$$

This manipulation can be explained by noticing that we are summing $f(a)g(b)$ over all points $(a, b)$ under the hyperbola $ab = x$. We sum over $a \leq \alpha$ first, then over $b \leq \beta$, and then we have to subtract the sum over any points we've double counted. This is illustrated in the following picture:

_**No picture yet.**_

This idea was also used in [my post](/blog/2023/04/09/lucy-fenwick.html) about the Lucy\_Hedgehog algorithm. We will usually pick $\alpha = \beta = \sqrt{x}$ but sometimes it helps to be able to balance the break point based on how hard $f$ and $g$ are to sum individually. Let's see what happens for $u*u = d$.

In this case, we have $F(x) = G(x) = \lfloor x \rfloor$, so pick $\alpha = \beta = \sqrt{x}$.

$$\begin{align*}
\sum_{n \leq x} d(n) &= \sum_{n \leq \sqrt{x}} u(n) \left \lfloor \frac{x}{n} \right \rfloor + \sum_{n \leq \sqrt{x}} \left \lfloor \frac{x}{n} \right \rfloor u(n) - \left \lfloor \sqrt{x} \right \rfloor^2\\
&= 2\sum_{n \leq \sqrt{x}} \left \lfloor \frac{x}{n} \right \rfloor - \left \lfloor \sqrt{x} \right \rfloor^2
\end{align*}$$

Immediately we have an algorithm to compute $D(x)$ in $O(\sqrt{x})$ time!

[totient]: https://en.wikipedia.org/wiki/Euler%27s_totient_function
[mobius]: https://en.wikipedia.org/wiki/M%C3%B6bius_function
[zeta]: https://en.wikipedia.org/wiki/Riemann_zeta_function
[characters]: https://en.wikipedia.org/wiki/Dirichlet_character