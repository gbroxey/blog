---
title: "Another WIP Page"
---

Let's first write a bit of code to generate tuples $(t, q)$ where $tq \leq x$ and $q$ is the largest prime factor of $t$. This way, we generate one member of each class of integers up to $x$, and so all the integers up to $x$ can be written as $tp$ where $p$ is a prime such that $p \geq q$ and $tp \leq x$. We're going to write it in a very similar way to generating powerful numbers up to $x$ - notice that since $q$ must be the greatest prime factor of $t$, and $tq \leq x$, that we must have $q^2 \leq x$, so there are not many prime factors to consider here.

### Min-25 Sieve

This method is specialized to summing multiplicative $f(n)$, taking the value $f(p^k) = g(p, k)$ at prime powers, such that $f(p) = g(p, 1)$ is a polynomial of low degree, and so that we can calculate each $g(p, k)$ in $O(1)$ time. This [CodeForces article by box][box-min-25] gives a good exposition of this. There's also [this article][min-25-chinese] which happens to be in Chinese, but probably the best reference is Min-25's original blog post which has unfortunately been deleted. Fortunately it exists on the Internet Archive [here][min-25-original], and this is what you should follow if you want to try implementing it. I'll just be giving a short overview here.

Following Min-25's notation let's write $g(p, 1) = g(p)$ as well. They claim the algorithm will produce $F(x) = \sum_{n \leq x} f(n)$ in $O(x^{2/3})$ time and $O(x^{1/2})$ space. I think it's easier to do it in $O(x^{2/3} \log(x)^{1/3})$ time and about $O(x^{2/3} / \log(x)^{2/3})$ space. This is basically because the first step of the algorithm is to use a Fenwick tree based Lucy_Hedgehog algorithm as described in [my last post][lucyfenwick] which, if you haven't read it already, is still extremely relevant.

In the following, we let
- $\pi(x)$ be the number of primes up to $x$
- $p_k$ be the $k$-th prime number (so $p_1 = 2$, $p_2 = 3$, ...)
- $\newcommand{lpf}{\text{lpf}}\lpf(n)$ be the smallest prime factor of $n$, with $\lpf(1) := \infty$
- $F_{\text{prime}}(x) := \sum_{p \leq x} f(p)$ is the sum of $f(p)$ over primes up to $x$
- $F_k(x) := \sum_{n \leq x} \left\lbrack\lpf(n) \geq p_k\right\rbrack\cdot f(n)$   
  In other words, the sum of $f(n)$ over all $n \leq x$ with no prime factors below $p_k$

Notice that $F_1(x) = \sum_{n \leq x} f(n)$ is the sum we're after.

In Min-25's article, they define $V(f, x)$ to be essentially the set of all pairs $(v, f(v))$ over all distinct $v = \lfloor x/n \rfloor$. This is just being very explicit about using the square root trick discussed previously. Using the same language in [my Lucy_Hedgehog post][lucyfenwick], we're going to refer to these values $v$ as the "key values" from now on.

The strategy as described by Min-25 is as follows:
1. Determine $F_{\text{prime}}(v)$ for all key values $v$ in $O(x^{2/3})$ (?) time.
2. Determine $F_{\pi(\sqrt[3]{x})+1}(v)$ for all key values $v$ in a further $O(x^{2/3}/\log(x))$ time.
3. Determine $F_{\pi(\sqrt[6]{x})+1}(v)$ for all key values $v$ in a further $O(x^{2/3})$ time.
4. Finally determine $F_1(v)$ for all key values $v$ in a further $O(x^{2/3}/\log(x))$ time.

The total time complexity would be $O(x^{2/3})$.

The first step is achieved using the extended Lucy_Hedgehog algorithm as described in [my post I've referenced maybe 100 times so far][lucyfenwick]. If you haven't read that, and you want to implement the Min-25 sieve, you're going to have to learn how to do the fast Lucy_Hedgehog algorithm first, because the Min-25 sieve is basically an extension of it. Because of this, Min-25 just chooses not to explain this section of the algorithm.

The rest of the algorithm proceeds by factoring all of the missing prime factors in all the numbers we want to sum. Step 2 does this essentially by cases, since numbers with no prime factors below $\sqrt[3]{x}+1$ must be $1$, prime, or a product of two primes.

For step 3, Min-25 recommends the use of a Fenwick tree but I don't think they say exactly how to use it. Referencing the [CodeForces article][box-min-25] and my explanation on how to use Fenwick trees in this context I think it should be not impossible to work out how to apply them here. We can get away with avoiding the use of a Fenwick tree though if we only want $O(x^{3/4})$ ish runtime. Check out that CodeForces article for how to do this, they set up a nice recurrence there that works fine.