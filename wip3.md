---
title: "Calculating (1/2)! by Lattice Point Counting"
---

> **Abstract.** Here we'll define $z! = \Gamma(z+1)$ which is standard practice.  
> We'll start with an analytical lemma relating a function's power series coefficient asymptotics to the values of the function itself. We'll apply that to a function which is related to lattice points inside a circle, and then asymptotics on those will finish the proof.

---

> **Lemma.** Suppose $a_0, a_1, \ldots$ is a sequence of real numbers, and write $A(t) = \sum_{n \leq t} a_n$.  
> Assume that for some $r > -1$, we have $A(t) = O(t^r)$.  
> Then the function $a(x) = \sum a_n x^n$ converges absolutely for all $|x| < 1$, and
> 
$$\liminf_{t \to \infty} \frac{A(t)}{t^r} \leq \liminf_{x \to 1^-} \frac{(1-x)^r}{r!} a(x) \leq \limsup_{x \to 1^-} \frac{(1-x)^r}{r!} a(x) \leq \limsup_{t \to \infty} \frac{A(t)}{t^r}$$

_Proof._ We'll recall the definition of $r!$ here as we'll need it in a second.

$$r! = \Gamma(1+r) = \int_0^\infty u^r e^{-u} du$$

To prove the lemma, it suffices to show only the inequality involving the lim sups, since the other inequalities are an easy consequence of that one.

So let $\varepsilon > 0$ be arbitrary and write $\delta$ for the quantity $\limsup A(t)/t^r$.  
Then there exists $t_0 \geq 0$ so that for all $t \geq t_0$, we have $A(t) \leq (\delta + \varepsilon) t^r$.

To relate $a(x)$ to $A(t)$, we use [Abel's summation theorem][abel] to obtain

$$a(x) = -\log(x) \int_0^\infty A(t)x^t dt$$

which is valid for $0 < x < 1$. We can immediately relate this to $\delta, \varepsilon$:

$$\begin{align*}
a(x) &= \left\lbrack-\log(x) \int_0^{t_0} A(t)x^tdt\right\rbrack + \left\lbrack- \log(x) \int_{t_0}^\infty A(t)x^tdt\right\rbrack\\
&\leq \left\lbrack-\log(x) \int_0^{t_0} A(t)dt\right\rbrack + \left\lbrack- \log(x) \int_{t_0}^\infty (\delta+\varepsilon)t^r x^tdt\right\rbrack
\end{align*}$$

We can bound the second term as

$$\begin{align*}
- \log(x) \int_{t_0}^\infty (\delta+\varepsilon)t^r x^tdt &\leq - \log(x) \int_{0}^\infty (\delta+\varepsilon)t^r x^tdt\\
&= (\delta+\varepsilon) \cdot \left\lbrack -\log(x) \int_0^\infty t^r x^t dt \right\rbrack
\end{align*}$$

To continue we use the substitution $x^t = e^{-u}$, obtaining

$$\begin{align*}
(\delta+\varepsilon) \cdot \left\lbrack -\log(x) \int_0^\infty (-u/\log(x))^r e^{-u} \cdot \frac{du}{-\log(x)} \right\rbrack &= (\delta+\varepsilon) \cdot \int_0^\infty (-u/\log(x))^r e^{-u} du\\
&= (\delta+\varepsilon) \cdot (-\log(x))^{-r} \int_0^\infty u^r e^{-u} du\\
&= (\delta+\varepsilon) \cdot (-\log(x))^{-r} r!
\end{align*}$$

Now using $-\log(x) \sim 1-x$ as $x$ tends to zero from below, we have the following:

$$\begin{align*}
\frac{(1-x)^r}{r!} a(x) &\leq O((1-x)^{r+1}) + (\delta + \varepsilon)(1 + o(1))
\end{align*}$$

Because $r > -1$ we have the desired inequalities as $x \to 1$ from below. $\newcommand{\proofqed}{\quad\quad\quad\square} \proofqed$



[abel]: https://en.wikipedia.org/wiki/Abel%27s_summation_formula