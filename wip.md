---
title: "A Density Problem With GCDs"
---

> **Abstract.** I describe how Lucy_Hedgehog's algorithm works, and how it can be implemented. Then I show how Fenwick trees can be used to boost its runtime without much effort.   
> The final runtime is at most $O(x^{2/3} (\log x \log \log x)^{1/3})$ to compute $\pi(x)$.  
> I also give an extension to sums of primes and to primes in arithmetic progressions.  
>The implementation gives $\pi(10^{13})$ in less than 3s.

Nothing magical is happening here quite yet, it's just incredibly helpful to have these functions set up when we actually implement Lucy's algorithm. Speaking of, we can describe and implement it now -

> ### Algorithm (Lucy)
> 1. Initialize `S[v] = v-1` for each key value `v`.
> 2. For `p` in `2..sqrt(x)`,  
>     2a. If `S[p] == S[p-1]`, then `p` is not a prime (_why?_) so increment `p` and try again.  
>     2b. Otherwise, `p` is a prime - for each key value `v` satisfying `v >= p*p`, in _decreasing order_, update the value at `v` by  `S[v] -= S[v div p] - S[p-1]`.
> 3. Return `S`. Here, `S[v]` is the number of primes up to `v` for each key value `v`.

Why, in step 2b, do we have to update the array elements in decreasing order?

This is a side effect of us using a single array `S` to store `S[v, p]` for all keys `v` and `p <= isqrt`. There is a loop invariant here: after step 2b, `S[v] = S[v, p]`. During step 2b, part of the array should be `S[v, p]` and part of it should be `S[v, p-1]`. We have to be careful that when we update `S[v]` to equal `S[v, p]` that we will not need the value `S[v, p-1]` in the future, since it will be overwritten. The natural way to make sure of this is to simply update the highest `v` first, since any `S[v, p]` will only need to access `S[w, p-1]` for `w < p`.

Nothing magical is happening here quite yet, it's just incredibly helpful to have these functions set up when we actually implement Lucy's algorithm. Speaking of, we can describe and implement it now -

### Algorithm (Lucy)
> 1. Initialize `S[v] = v-1` for each key value `v`.
> 2. For `p` in `2..sqrt(x)`,  
>     2a. If `S[p] == S[p-1]`, then `p` is not a prime (_why?_) so increment `p` and try again.  
>     2b. Otherwise, `p` is a prime - for each key value `v` satisfying `v >= p*p`, in _decreasing order_, update the value at `v` by  `S[v] -= S[v div p] - S[p-1]`.
> 3. Return `S`. Here, `S[v]` is the number of primes up to `v` for each key value `v`.

Why, in step 2b, do we have to update the array elements in decreasing order?

This is a side effect of us using a single array `S` to store `S[v, p]` for all keys `v` and `p <= isqrt`. There is a loop invariant here: after step 2b, `S[v] = S[v, p]`. During step 2b, part of the array should be `S[v, p]` and part of it should be `S[v, p-1]`. We have to be careful that when we update `S[v]` to equal `S[v, p]` that we will not need the value `S[v, p-1]` in the future, since it will be overwritten. The natural way to make sure of this is to simply update the highest `v` first, since any `S[v, p]` will only need to access `S[w, p-1]` for `w < p`.