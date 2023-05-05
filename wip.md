---
title: "Summing Multiplicative Functions (Pt. 2)"
tags: [number theory, algorithms, prime counting]
---

> **Abstract.** We will examine and implement the Black Algorithm and the Min-25 sieve.

---

[Last time][mult1] we learned some tricks and techniques for computing partial sums of multiplicative functions. This time we're going to dedicate some attention to the Black Algorithm and the related Min-25 sieve. These algorithms, as mentioned in the previous post, reduce the problem of summing a multiplicative function to the problem of summing the same function over primes. We already know how to accomplish this (see [my post on Lucy's algorithm][lucyfenwick]) in $O(x^{2/3} (\log x)^{1/3})$ time. These algorithms will build off of Lucy's algorithm, and knowledge of how Fenwick trees are used in this context is required to obtain a runtime at least as good as the one given by the powerful numbers trick.

In fact, I think most (any?) cases summable by the Black Algorithm and Min-25 type algorithms can be done perfectly well using the powerful numbers trick, usually in a flat $O(x^{2/3})$ time (or better!).

The functions that these algorithms aim to sum are those multiplicative $f(n)$ such that $f(p)$ has a nice form at prime numbers. Specifically they assume $f(p) = g(p)$ is a polynomial with low degree.

Suppose $g(p)$ has degree $k$, and $g(p) = \sum_{i \leq k} a_i p^i$.  
Writing $N_i$ for the multiplicative function $N_i(n) = n^i$, we can do the powerful numbers trick by approximating $f(n)$ by the function $(N_0)^{a_0} \ast (N_1)^{a_1} \ast \ldots \ast (N_k)^{a_k}$, where by $(N_0)^{a_0}$ for example I'm referring to the $a_0$-fold convolution of $N_0$ - that is, $N_0 \ast N_0 \ast \ldots \ast N_0$, where there are $a_0$ copies. I'll assume here that $a_i$ are integers. If they are negative, you just convolve the Dirichlet inverse of $N_i$ instead of $N_i$ itself. 

For example, if $g(p) = (p-1)^2 = p^2 - 2p + 1$, we could perform the powerful numbers trick, approximating $f$ by 

$$N_2 \star N^{-1} \star N^{-1} \star u$$

In general, with linear sieving techniques we finish in time

$$O\left(x^{2/3} \sum_{i \leq k} \vert a_i \vert\right)$$

So now that I've explained that you probably don't even need to implement the following methods, I'm going to spend a week writing about how they work and how to implement them.

Partially I'm motivated here by the fact that the existing documentation on these methods is a little bit lacking. It is slightly hard to locate, and usually in Chinese or Japanese. There are English articles, but I didn't find any that actually explain how to use Fenwick trees with these methods (unsurprisingly). Given that the use of those is critical in obtaining the fastest version of these algorithms, it's quite frustrating to not have a good resource on this. Hopefully this post will serve as a good overview, and also as a resource allowing you to implement these (if you want to).

The following exposition of these methods is based on the following articles (copied from [the last post][mult1]):
- [This post][black-baihacker] by baihacker about the Black Algorithm, which itself contains reference to [a post][bohang] by Bohang Zhang, in Chinese, describing another summation algorithm,
- [This post][min-25-original] from Min-25's blog, in Japanese, encased in amber (the internet archive) due to its having been deleted a while back,
- [This post][min-25-chinese] on a Chinese wiki about some version of Min-25's algorithm, and
- [This CodeForces blog post][box-min-25] by box, also explaining a version of Min-25's sieve. This one is maybe the easiest to follow, especially for those who don't speak Chinese or Japanese.

Some parts will be my own ideas, and I won't claim to have detailed a perfect implementation of these algorithms, but I will be doing my best to show how these methods work.

In all of the following algorithms, $f(n)$ will be the multiplicative function we want to sum.  
We will write $F(x) = \sum_{n \leq x} f(n)$, and also $F_{\mathbb P}(x) = \sum_{p \leq x} f(p)$ for the sum over only primes. The key ideas in the algorithms here will be to compute $F_{\mathbb P}$ and then to somehow obtain $F$.

---

### Computing $F_{\mathbb P}(x)$

In fact we will usually need to know $F_{\mathbb P}(v)$ for all distinct values of $v = \left\lfloor \frac{x}{n}\right\rfloor$, referred to as "key values" in my previous posts on these topics ([Lucy's Algorithm][lucyfenwick] and [Multiplicative Sums 1][mult1]). We will not be talking so much on this topic here since I've covered in the first of those - see the section "Sums of Primes, Primes Squared, ..." which naturally extends to sums of any polynomial over primes. The total runtime for such a problem is $O(x^{2/3} (\log x)^{1/3})$.

To make this more concrete, from here onwards we're going to be summing the example function $f(n) = d(n^2)$.  
We handled this function [previously][mult1], and it's a function for which other methods work extremely nicely.  
Nonetheless it's a solid example case, not boring, and not too complicated to work with.

In that case, $f(p) = d(p^2) = 2p+1$ is a linear polynomial in $p$, so $F_{\mathbb P}(v)$ can be computed for all key values $v$ in a total time of $O(x^{2/3} (\log x)^{1/3})$.

### The Black Algorithm

This is the simplest version of these ideas.

I think generally the starting point here is similar to Lucy's Algorithm.

In the following, we let
- $\pi(x)$ be the number of primes up to $x$
- $p_k$ be the $k$-th prime number (so $p_1 = 2$, $p_2 = 3$, ...)
- $\newcommand{lpf}{\text{lpf}}\lpf(n)$ be the smallest prime factor of $n$, with $\lpf(1) := \infty$
- $F_k(x) := \sum_{n \leq x} \left\lbrack\lpf(n) \geq p_k\right\rbrack\cdot f(n)$   
  In other words, the sum of $f(n)$ over all $n \leq x$ with no prime factors below $p_k$

The function $F_k(x)$ is similar looking to the sieve-ish function in the standard Lucy setup.

The goal is to calculate $F(x) = F_1(x)$.  
We have $F_{\pi(\sqrt{x})}

Let's first write a bit of code to generate tuples $(t, q)$ where $tq \leq x$ and $q$ is the largest prime factor of $t$. This way, we generate one member of each class of integers up to $x$, and so all the integers up to $x$ can be written as $tp$ where $p$ is a prime such that $p \geq q$ and $tp \leq x$. We're going to write it in a very similar way to generating powerful numbers up to $x$ - notice that since $q$ must be the greatest prime factor of $t$, and $tq \leq x$, that we must have $q^2 \leq x$, so there are not many prime factors to consider here.

### Min-25 Sieve

This method is specialized to summing multiplicative $f(n)$, taking the value $f(p^k) = g(p, k)$ at prime powers, such that $f(p) = g(p, 1)$ is a polynomial of low degree, and so that we can calculate each $g(p, k)$ in $O(1)$ time. This [CodeForces article by box][box-min-25] gives a good exposition of this. There's also [this article][min-25-chinese] which happens to be in Chinese, but probably the best reference is Min-25's original blog post which has unfortunately been deleted. Fortunately it exists on the Internet Archive [here][min-25-original], and this is what you should follow if you want to try implementing it. I'll just be giving a short overview here.

Following Min-25's notation let's write $g(p, 1) = g(p)$ as well. They claim the algorithm will produce $F(x) = \sum_{n \leq x} f(n)$ in $O(x^{2/3})$ time and $O(x^{1/2})$ space. I think it's easier to do it in $O(x^{2/3} \log(x)^{1/3})$ time and about $O(x^{2/3} / \log(x)^{2/3})$ space. This is basically because the first step of the algorithm is to use a Fenwick tree based Lucy_Hedgehog algorithm as described in [my last post][lucyfenwick] which, if you haven't read it already, is still extremely relevant.


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

---

## Code

The code for this blog post is available nowhere.

[mult1]: /blog/2023/04/30/mult-sum-1.html
[lucyfenwick]: /blog/2023/04/09/lucy-fenwick.html
[box-min-25]: https://codeforces.com/blog/entry/92703
[min-25-chinese]: https://oi-wiki.org/math/number-theory/min-25/
[min-25-original]: https://web.archive.org/web/20211009144526/https://min-25.hatenablog.com/entry/2018/11/11/172216
[black-baihacker]: http://baihacker.github.io/main/2020/The_prefix-sum_of_multiplicative_function_the_black_algorithm.html
[bohang]: https://zhuanlan.zhihu.com/p/33544708

---