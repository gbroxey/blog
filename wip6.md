---
title: "Solving the Basel Problem by Jacobi Four-Square Theorem and Lattice Point Counting"
tags: [analysis,number theory]
date: 2023-10-12
---

> **Abstract.** There is an easy connection between sums-of-two-squares and sums-of-four-squares. The Jacobi four-square theorem allows us to get an asymptotic on the sum of $r_4(n)$ up to $x$ in terms of $\zeta(2)$, and then we relate this to the number of lattice points in a quarter-circle in the same way as one of my older blog posts.

---

I have recently been pretty busy with writing things for work. Between that and various life events I haven't really had a lot of time to do much for this blog. I do actually have a really cool post in the works, but that's going to be a huge endeavor and take a long time to finish.

A lot of you are aware that I'm heavily involved as an admin in the Project Euler Community Discord server (see my resources page for a link). A friend of mine, hacatu, recently boosted the server, whatever that means, and so we unlocked server tags - exciting! We decided on $\pi^2/6$ as the little text that appears next to your username if you have chosen the PE Discord as your tag of choice, and someone asked where it came from.

The expression comes from the very famous [Basel problem][basel-wikipedia]:

$$\sum_{n=1}^\infty \frac{1}{n^2} = 1 + \frac{1}{4} + \frac{1}{9} + \frac{1}{16} + \ldots = \frac{\pi^2}{6}$$

The expression on the left hand side is the value $\zeta(2)$ of the Riemann zeta function (better known in relation to a certain hypothesis). This result was proved by Euler in 1734, and there are about a hundred really cool proofs out there.  I think the first one I really understood well was the proof using Fourier series and Parseval's identity, which is particularly straightforward. When I was asked about the $\pi^2/6$ thing I tried to think if I had a convenient proof using any of the cool math tricks I like. I realized that, if I allowed myself some high-power machinery, then I had a proof! Neat. Let's do it.

---

First, you probably should read [this blog post from 2023][older-post] where I used a nice lattice point counting idea to show that $(1/2)!$ must equal $\frac{\sqrt{\pi}}{2}$. We will, in fact, be using almost the exact same setup here.

Define, for $\lvert x \rvert < 1$,

$$a(x) = \sum_{n \geq 0} x^{n^2}$$

and recall from before that

$$\lim_{x \to 1} (1-x)a(x)^2 = \frac{\pi}{4}$$

by counting the lattice points inside a quarter-circle and using the analytical lemma. So far this is all the same as last time.

Define

$$\theta(x) = \sum_{n \in \mathbb Z} x^{n^2}$$

which is (related to) the Jacobi theta function. We care about it because the $x^n$ coefficient of $\theta^k$ is $r_k(n)$, the number of representations of $n$ as a sum of $k$ integer squares.

This differs only slightly from our $a(x)$ - the coefficient of $x^n$ in $a(x)^k$ is the number of representations of $n$ as a sum of $k$ _non-negative_ integers squared.

For $\theta(x)^2$, the coefficient of $x$ is $4$, from the representations

$$\begin{align*}
1 &= 1^2 + 0^2\\
&= (-1)^2 + 0^2\\
&= 0^2 + 1^2\\
&= 0^2 + (-1)^2
\end{align*}$$

For $a(x)^2$ though, the coefficient of $x$ is $2$, from $1 = 1^2 + 0^2 = 0^2 + 1^2$.

The lattice point counting ideas from [before][older-post] work exactly the same when analyzing $\theta(x)^2$ near $1$, except we work on a whole circle instead of a quarter circle (which is more natural). We get the limit

$$\lim_{x \to 1} (1-x)\theta(x)^2 = \pi$$

which is quite nice to look at.

Our next step is obviously to ask ourselves where $\pi^2$ could possibly come from, and the answer is of course from squaring $\pi$. So, we'll have to think about the coefficients of $\theta(x)^4$ and then use

$$\lim_{x \to 1} \frac{(1-x)^2}{2} \theta(x)^4 = \frac{\pi^2}{2}$$

which I got from squaring the previous limit and dividing by two.

In order to use the analytical lemma from last time, we need to analyze partial sums of the coefficients $r_4(n)$ in the series for $\theta(x)^4$. It turns out a really smart guy called Jacobi already did that for us, so we'll borrow his work.

According to the [Jacobi four-square theorem][four-square], $r_4(n)$ is equal to $8$ times the sum of divisors of $n$ not divisible by $4$. It's a really cool formula and very useful in lots of situations. We can just use it ungratefully but I had a little fun looking into the various different ways it can be proved.

The "standard" place to start is apparently the Jacobi triple product:

$$\prod_{n \geq 1} (1-x^{2n})(1+x^{2n-1}z^2)\left(1+\frac{x^{2n-1}}{z^2}\right) = \sum_{m \in \mathbb Z} x^{m^2} z^{2m}$$

It frankly boggles the mind but you can find an elementary proof [on its Wolfram MathWorld page][triple-product-mw]. Clearly this is related to $\theta(x)$ given the right hand side, and you can get to the four-square theorem from here.

Another cool way to prove the four-square theorem is with the theory of modular forms, but that's obviously really complicated and machinery-heavy.

It can also be proved using quaternions (which makes sense, because quaternions are $4$-tuples or whatever). I don't really have quite enough algebra experience to understand [what this guy on mathoverflow is saying][quat-mo] but it looks pretty cool, and if you like abstract algebra you'll probably enjoy reading it.

Another proof which appears elsewhere in that mathoverflow thread is elementary and appears in section 2.4 of the book "Elementary Number Theory, Group Theory, and Ramanujan Graphs" by Davidoff, Sarnak, and Valette. You can find that online if you want.

Okay, so, the version I'll be using is the following, where $\sigma(n)$ is the sum of all divisors of $n$:

$$r_4(n) = 8\sigma(n) - 32\sigma(n/4)$$

where the second term is taken to be zero when $n/4$ is a fraction.

Let 

$$S(n) = \sum_{k \leq n} \sigma(k)$$

Then

$$R(n) = \sum_{k \leq n} r_4(k) = 8S(n) - 32S(n/4)$$

The reason we care about this is that, by the analytical lemma on $\theta(x)^4$, we have

$$\liminf_{n \to \infty} \frac{R(n)}{n^2} \leq \liminf_{x \to 1^-} \frac{(1-x)^2}{2} \theta(x)^4 \leq \limsup_{x \to 1^-} \frac{(1-x)^2}{2} \theta(x)^4 \leq \limsup_{n \to \infty} \frac{R(n)}{n^2}$$

We need to get asymptotics on $R(n)$, which will be instantly related to $\frac{\pi^2}{2}$ by using the limit we got earlier with $\theta(x)^4$.

This is very easy (the following analysis is from Theorem 3.4 from Apostol's Introduction to Analytic Number Theory):

$$\begin{align*}
S(n) &= \sum_{k \leq n} \sigma(k) = \sum_{k \leq n} \sum_{q \mid n} q\\
&= \sum_{qd \leq n} q = \sum_{d \leq n} \sum_{q \leq n/d} q\\
&= \sum_{d \leq n} \left[ \frac{1}{2} \left(\frac{n}{d}\right)^2 + O\left(\frac{n}{d}\right)\right]\\
&= \frac{n^2}{2} \sum_{d \leq n} \frac{1}{d^2} + O\left(n \sum_{d \leq n} \frac{1}{d}\right)
\end{align*}$$

The error-term is of the order $n \log n$ and so is negligible, and the sum $\sum \frac{1}{d^2}$ will converge to $\zeta(2)$. So

$$S(n) = \frac{1}{2} \zeta(2) n^2 + o(n^2)$$

Plugging this into $R(n) = 8S(n) - 32S(n/4)$ and simplifying, we get

$$R(n) = 3\zeta(2)n^2 + o(n^2)$$

which shows

$$\lim_{x \to 1} \frac{(1-x)^2}{2} \theta(x)^4 = 3 \zeta(2)$$

Now, we just set this equal to the $\frac{\pi^2}{2}$ we got from lattice point counting on $\theta(x)^2$ earlier, and divide by $3$ to obtain

$$\zeta(2) = \frac{\pi^2}{6}$$

---

[older-post]: https://gbroxey.github.io/blog/2023/06/21/lattice-points.html
[basel-wikipedia]: https://en.wikipedia.org/wiki/Basel_problem
[four-square]: https://en.wikipedia.org/wiki/Jacobi%27s_four-square_theorem
[triple-product-mw]: https://mathworld.wolfram.com/JacobiTripleProduct.html
[quat-mo]: https://mathoverflow.net/questions/84897/proofs-of-jacobis-four-square-theorem/87272#87272