---
title: "The Number $\lfloor n!/e \rfloor" Is Even"
tags: [combinatorics]
---

> **Abstract.** There's a proof in [this YouTube video][yt].  
> We'll prove it combinatorially instead.

---

You should probably go watch that video first to get an idea of the proof provided by Michael Penn.  
Basically it boils down to writing down the series $\frac{1}{e} = \sum_{m \geq 0} \frac{(-1)^m}{m!}$ and going from there, doing a little algebraic manipulation which is very common especially when [coming up with a formula for the number of derangements of a set][aops]:

$$D_n = \sum_{m=0}^n \frac{n!}{m!} (-1)^m$$

We actually don't care TOO much about this formula other than the following manipulation.

$$\begin{align*} D_n &= \sum_{m=0}^n \frac{n!}{m!} (-1)^m\\
&= n! \sum_{m=0}^n \frac{(-1)^m}{m!}\\
&= n! \left(\frac{1}{e} - \sum_{m=n+1}^{\infty} \frac{(-1)^m}{m!}\right)\end{align*}$$

The last tail sum there will be vanishingly small - at most $1/(n+1)!$ in absolute value, since it's an alternating sum. If $n+1$ is even (equivalently $n$ is odd), the sum $\sum_{m=n+1}^{\infty} \frac{(-1)^m}{m!}$ will be positive, and then $D_n = \lfloor n!/e \rfloor$. If $n+1$ is even though, the sum will be negative, and so $D_n = 1 + \lfloor n!/e \rfloor$.

So the problem we care about can be expressed as follows in terms of $D_n$:

> **Problem.** If $n$ is odd, then $D_n$ is even. If $n$ is even, then $D_n$ is odd.

Michael's proof does this algebraically, which is fine, but this problem reminded me of [a nice paper][die] I read once about the usage of involutions[^1] in evaluating alternating sums using combinatorial techniques. We won't exactly follow that paper but you should go read it anyways.

We're going to write $\sigma$ for a permutation of the set $\lbrace 1, 2, \ldots, n \rbrace$.  
Derangements are those permutations $\sigma$ for which $\sigma(i) \neq i$ for all $i$.

The idea of the proof will be to construct an involution $f$ on the set of derangements of $n$. In other words, we'll be pairing up the elements we're counting in $D_n$. If $f$ has no fixed points with $f(\sigma) = \sigma$, we will have shown that $D_n$ is even, and if otherwise $f$ has an odd number of fixed points, we'll have shown that $D_n$ is odd. That's our strategy, coming up with a nice involution here is the rest of the proof.

We'll be thinking in terms of the cycles in a permutation $\sigma$, and we'll be tweaking those to make a new permutation $f(\sigma)$. Remember that we're permuting the set $\lbrace 1, 2, \ldots, n \rbrace$.

Look at the cycle containing $1$. Say it looks like $(1, 5, 3, 4)$ for example. Replace this with the cycle $(1, 4, 3, 5)$ - just reverse the whole cycle. This gives you a new permutation which is also a derangement of $n$, call this $f(\sigma)$.

When is this not defined? Well, if $1$ is in a cycle by itself, $\sigma(1) = 1$ and $\sigma$ wouldn't be a derangement. The only other issue is when the cycle containing $1$ remains the same when you reverse it, which only happens if it looks like $(1, 5)$ or something else of length two. When that happens, just pick the next smallest integer up to $n$ not represented in a cycle of length two and try again.

For example in the permutation $\sigma = (1, 5)(2, 3, 4)$ we would have $f(\sigma) = (1, 5)(2, 4, 3)$. So now we've extended the definition of our involution, but there are still issues.

What if all of the cycles have length two? First off, we'd automatically have that $n$ is even there. So if $n$ is odd, the involution is *always* defined, so $D_n$ is even. Half of the problem is finished here.

In the case that $n$ is even, we need to try to extend the definition of our involution even further.

Suppose that $1$ and $2$ are in different cycles. Then you can switch their partners to make a new derangement.  
For example, for $\sigma = (1, 5)(2, 3)(4, 6)$, we would have $f(\sigma) = (1, 3)(2, 5)(4, 6)$ and we're happy. This breaks when $1$ and $2$ are together, but then just look at $3$ and $4$ instead.

For example then for $\sigma = (1, 2)(3, 5)(4, 6)$ we would have $f(\sigma) = (1, 2)(3, 6)(4, 5)$.  
You can check that $f(f(\sigma)) = \sigma$ as we desire.

This still breaks - keep on looking at pairs $1, 2$, then $3, 4$, then $5, 6$, until you've gone up to $n-1, n$. This leads us to a single derangement for which our involution is undefined, the permutation $\sigma = (1, 2)(3, 4)\ldots(n-1, n)$. For this one we just write $f(\sigma) = \sigma$ which will be the unique fixed point of our involution.

So if $n$ is even, there is a single fixed point, and since $1$ is odd, so is $D_n$.

Here's an example for $n = 4$.

$$\begin{align*}
(1234) &\xrightarrow{f} (1432)\\
(1324) &\xrightarrow{f} (1423)\\
(1243) &\xrightarrow{f} (1342)\\
(13)(24) &\xrightarrow{f} (14)(23)\\
(12)(34) &\xrightarrow{f} (12)(34) \, \textit{(only fixed point)}
\end{align*}$$

Only the derangement $\sigma = (12)(34)$ is mapped to itself here, and the rest are set in pairs $(\sigma, f(\sigma))$. So the number of derangements $D_4$ is odd.

[^1]: An involution is a bijective map from a set to itself, which is its own inverse. In other words, it's a way to pair up elements of a set (potentially pairing an element with itself).

[yt]: https://www.youtube.com/watch?v=wrHxeHJDTk4
[aops]: https://artofproblemsolving.com/wiki/index.php/Derangement
[die]: https://scholarship.claremont.edu/cgi/viewcontent.cgi?referer=&httpsredir=1&article=1581&context=hmc_fac_pub
