---
title: "Summing Multiplicative Functions"
---

> **Abstract.** I'll exhibit a ton of different method for computing partial sums of multiplicative functions. Knowledge of how to sum more basic functions is assumed. We'll use the square root trick constantly, as well as some basic number theory. This is another long one.

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

This idea was also used in [my post][lucyfenwick] about the Lucy\_Hedgehog algorithm. We will usually pick $\alpha = \beta = \sqrt{x}$ but sometimes it helps to be able to balance the break point based on how hard $f$ and $g$ are to sum individually. Let's see what happens for $u*u = d$.

In this case, we have $F(x) = G(x) = \lfloor x \rfloor$, so pick $\alpha = \beta = \sqrt{x}$.

$$\begin{align*}
\sum_{n \leq x} d(n) &= \sum_{n \leq \sqrt{x}} u(n) \left \lfloor \frac{x}{n} \right \rfloor + \sum_{n \leq \sqrt{x}} \left \lfloor \frac{x}{n} \right \rfloor u(n) - \left \lfloor \sqrt{x} \right \rfloor^2\\
&= 2\sum_{n \leq \sqrt{x}} \left \lfloor \frac{x}{n} \right \rfloor - \left \lfloor \sqrt{x} \right \rfloor^2
\end{align*}$$

Immediately we have an algorithm to compute $D(x)$ in $O(\sqrt{x})$ time! Here it is in Nim.

```nim
proc divisorSummatory(x: int64): int64 =
  ##Computes d(1) + ... + d(x) in O(x^(1/2)) time.
  var xsqrt = isqrt(x)
  for n in 1..xsqrt:
    result += 2*(x div n)
  result -= xsqrt*xsqrt
```

For $D(x)$, it's possible to do it in about $O(x^{1/3})$ time, but I'll cover that in a later post because it's much more complicated and uses a very different technique.

So with this, if we're able to sum $f$ and $g$ in a reasonable amount of time, we're able to sum $f*g$ as well. This will be a crucial feature of the more complex methods.

### Tangent: Linear Sieving

In the future we're going to use what I think are generally referred to as "sieving techniques" to compute the values of arithmetic functions $f(n)$ over short intervals $n \leq y$.

Let's try doing this for the function $f(n) = d(n)$.

The most naive method for doing it looks like this:

```nim
var d = newSeq[int](y+1)
#indexed from 0 to y, but just ignore 0
for n in 1..y:
  for k in 1..n:
    if n mod k == 0: #k is a divisor of n
      inc d[n] #increment
  #now d[n] is correct
```

This runs in $O(y^2)$ time which is awful. The reason why is that it's hard to pick out the divisors of an integer without knowing anything about it. So instead what we can do is iterate over the divisors `k` first, and then over all `n` divisible by `k`. Here's how that looks:

```nim
var d = newSeq[int](y+1)
for k in 1..y:
  #increment d[k*j] for all multiples k*j <= y
  for j in 1..(y div k):
    inc d[k*j]
```

Now this runs in about $O\left(\sum_{k \leq y} \frac{y}{k}\right) = O\left(y \log y\right)$ time, which is just barely above linear. For most purposes this will be perfectly fine.

Let's take a look at how it looks if we do a very basic sieve for $\varphi$.

The idea here is that, if $p$ is a prime not dividing $m$, then $\varphi(m p^e) = \varphi(m) p^{e-1}(p-1)$. So what we're going to do is initialize `phi[n] = n` for all `n`, and then fix the contribution of each prime factor separately.

To recognize when we have a prime, we're going to check whether `phi[n]` has been modified yet. We can just check if `phi[p] == p` - if it is, `p` is a prime, and we fix the contributions of `p`.

```nim
var phi = newSeq[int](y+1)
for k in 1..y: phi[k] = k
#initialized
for p in 2..y:
  if phi[p] == p:
    for k in 1..(y div p):
      phi[p*k] = (phi[p*k] div p) * (p-1)
```

Nice and easy! This now takes $O\left(\sum_{p \leq y} \frac{y}{p}\right)$ time, which is $O\left(y \log \log y\right)$, so slightly faster than the basic one for the divisor function. Generally those functions that only need their prime factor contributions fixed can be done in this way.

Along this line of thinking, for basically any multiplicative function, we can do this calculation in a flat $O(y)$ time. This generally offers a good speedup to the summation methods I'll be detailing later. The best explanation I've found on this is in [this CodeForces blog post][linearsieve] by Nisiyama_Suzune. I am going to refrain from explaining how it works in depth because the implementation of this subroutine doesn't intersect the implementation of the later methods much at all. That is, I can use this as a black box which we will just avoid looking at for too long. So let's move on!

### Summing Generalized Divisor Functions

This section is about a function we haven't yet seen. Here's how it's defined.

The generalized divisor function $d_k(n)$ is the function with the Dirichlet series $\zeta(s)^k$.  
In other words, $d_1(n) = u(n) = 1$ for all $n$, and $d_k = u * d_{k-1}$, so $d_k(n) = \sum_{a \mid n} d_{k-1}(a)$.

In the previous section we figured out how to sum $d = d_2$ quickly, but how about.. $d_5$ for example?

If we attempted to just use the hyperbola method over and over again with no modifications we would get worse and worse runtime, as follows.

We know $d_1$ can be summed (with summatory function $D_1$) in constant time, and that $d_2$ can be summed in $O(x^{1/2})$ time. How about $d_3$?

Brainlessly apply the hyperbola method. We obtain

$$D_3(x) = \sum_{n \leq \alpha} D_2\left(\frac{x}{n}\right) + \sum_{n \leq \beta} d_2(n) \left\lfloor \frac{x}{n}\right\rfloor - \left\lfloor\alpha\right\rfloor D_2(\beta)$$

The last term takes $O(\beta^{1/2})$ time of course. The first one takes $O\left(\sqrt{x*\alpha}\right)$ time, and the second takes $O(\beta)$ time if we sieve $d_2$ in linear time. If we optimize $\alpha$ and $\beta$ we choose $\alpha = x^{1/3}$ and $\beta = x^{2/3}$, for a total runtime of $O(x^{2/3})$.

If we repeat this analysis for $D_4$ you'll end up choosing $\alpha = x^{1/4}$ and $\beta = x^{3/4}$ for a total runtime of $x^{3/4}$. Also notice that we also require $x^{3/4}$ space for this, which is getting pretty large.

By induction, we can compute $D_k(x)$ in about $x^{1 - 1/k}$ time, which as $k$ gets large is probably even worse than linear just due to a growing constant factor which I've ignored. Here we're going to show how we can cap the runtime to $O(k x^{2/3})$ while using $O(x^{2/3})$ space.

The key idea here is essentially from [my last post][lucyfenwick].

We're going to pick some $\sqrt{x} \leq y \leq x$ to be specified later and compute $D_k(v)$ for the key values $v \leq y$ by linear sieving, which will take $O(y)$ time. The rest of them will be done using the hyperbola method, using $\alpha = \beta = \sqrt{x}$. Here's a slightly more specific layout of the ideas:

#### Algorithm (Computing $D_k$(x) Iteratively)
> 1. Set $y \approx x^{2/3}$.  
>    Set an array `small` of length $y$ to store $D_1(k)$ for $k \leq y$.  
>    Set an array `big` of length $x/y$ to store $D_1(x / k)$ for $k < x/y$.
> 2. For $j$ from $2$ to $k$, we'll update our arrays to reflect $D_j$ instead:  
>     2a. Update `big` values first, using  
> 
$$D_j(v) = \sum_{n \leq \sqrt{v}} D_{j-1}\left(\frac{v}{n}\right) + \sum_{n \leq \sqrt{v}} d_{j-1}(n) \left \lfloor \frac{v}{n} \right \rfloor - D_{j-1}(\sqrt{v})\left\lfloor\sqrt{v}\right\rfloor$$
>   
>     2b. Update `small` values by sieving in $O(y)$.

How much time do we dedicate to updating the big array? They take

$$O\left(\sum_{k < x/y} \sqrt{x/k}\right) = O\left(\int_1^{x/y} \sqrt{\frac{x}{k}}dk \right) = O\left(x/\sqrt{y}\right)$$

If we want to minimize the total time to update both arrays, $O\left(y + x/\sqrt{y}\right)$, we need to pick $y$ to be on the order of $x^{2/3}$. The resulting time (and space) complexity is $O\left(x^{2/3}\right)$. Since we have to update it $k$ times, the runtime is $O\left(kx^{2/3}\right)$ in the end!

You'll have to poke at the constant coefficient on $y$ in your implementation.

The following is a lazy Nim implementation that doesn't use linear sieving. Because of that, the sieving step takes $O(y \log y)$ time instead of $O(y)$ time, and so we'll pick $y = x^{2/3} / \log(x)^{1/3}$ instead. The final runtime is actually going to be $O\left(k x^{2/3} \log(x)^{1/3}\right)$.

```nim
proc genDivisorSummatory(x: int64, k: int, m: int64): int64 =
  ##Computes d_k(1) + ... + d_k(x) mod m in O(k x^(2/3)) time.
  var y = (0.55*pow(x.float, 2.0/3.0) / pow(ln(x.float), 1.0/3.0)).int64
  var small = newSeq[int64](y+1)
  var big = newSeq[int64]((x div y) + 1)
  #initialize them to D_1, sum of u(n) = 1
  for i in 1..y: small[i] = i mod m
  for i in 1..(x div y): big[i] = (x div i) mod m
  #iteration time!
  for j in 2..k:
    #update big first
    for i in 1..(x div y):
      let v = x div i
      let vsqrt = isqrt(v)
      var bigNew = 0'i64
      for n in 1..vsqrt:
        #add D_{j-1}(v/n) = D_{j-1}(x/(i*n))
        if v div n <= y: bigNew += small[v div n]
        else: bigNew += big[i*n]
        #add d_{j-1}(n) floor(v/n)
        #to do so, grab d_{j-1}(n) from small = sum d_{j-1}
        bigNew += (small[n] - small[n-1]) * (v div n)
        bigNew = bigNew mod m
      bigNew -= small[vsqrt]*vsqrt
      big[i] = bigNew mod m
    #update small using sieving
    #be lazy...
    #convert small from summation to just d_{j-1}, convolve, then convert back
    for i in countdown(y, 1):
      small[i] -= small[i-1]
      for u in 2..(y div i):
        small[i*u] += small[i]
        small[i*u] = small[i*u] mod m
    for i in 1..y:
      small[i] = (small[i] + small[i-1]) mod m
  if big[1] < 0: big[1] += m
  return big[1]
```

The important thing to learn from this section is that, when we're dealing with summations of multiplicative functions, we should probably store sieved values up to about $x^{2/3}$ and then the sums up to larger $\lfloor x/k \rfloor$. If we have this data for two functions $f$ and $g$, then we can spend $O(x^{2/3})$ time to generate the same data for $f*g$.

### Summing $\mu$ and $\varphi$

First notice that $\varphi = \mu * N$ so that if we can sum $\mu$, we can also sum $\varphi$.

The summatory function of $\mu$ is called the Mertens function. It's been studied in detail by a lot of people because it's a very important function. We write it as $M(x) = \sum_{n \leq x} \mu(n)$. The prime number theorem is equivalent to $M(x)/x \to 0$ as $x$ goes to infinity (read Apostol's book if you want to see why).

The first thing we should do is review sieving methods. If you're familiar, skip to [the next section](#computing-in-sublinear-time)

#### Sieving $\mu$

#### Computing $M(x)$ in Sublinear Time

The key idea here is again similar to the one in [my post about prime counting][lucyfenwick], in that we'll use the "square root trick" again. 

Let's start with the formula $\mu*u = I$, which when plugged into the hyperbola method gives the following for all $v \geq 0$:

$$\sum_{n \leq \sqrt{v}} \mu(n)\left \lfloor \frac{v}{n}\right\rfloor + \sum_{n \leq \sqrt{v}} M\left(\frac{v}{n}\right) - \lfloor \sqrt{v} \rfloor M\left(\sqrt{v}\right) = 1$$

We can suppose we've sieved at least the first $\sqrt{x}$ values of $\mu$. Let's also assume we've computed $M\left(\frac{x}{n}\right)$ for $n > 1$. Then we'd have

$$M(x) = 1 - \sum_{n \leq \sqrt{x}} \mu(n)\left \lfloor \frac{x}{n}\right\rfloor - \sum_{2 \leq n \leq \sqrt{x}} M\left(\frac{x}{n}\right) + \lfloor \sqrt{x} \rfloor M\left(\sqrt{x}\right)$$

Notice that if we plug in $x = 1$ we get $M(x)$ again in the right hand side, so we should just set $M(1) = 1$ manually to avoid issues.

Then if we know the values of $M(x/n)$ for $n > 1$, we can compute $M(x)$ in about $O(\sqrt{x})$ time.  
This sort of structure is going to be very similar for a lot of the functions we'll sum.

Now, we know from before that the distinct values of $\lfloor x/n \rfloor$ are all of the integers up to $\sqrt{x}$ and then every $\lfloor x/n \rfloor$ for $n > \sqrt{x}$. This means that we can use the `FIArray` from the [last post][lucyfenwick] to store these values easily. It's just a container - read the relevant section of that post if you want clarification.

The algorithm for computing $M(x)$ will proceed as follows:

#### Algorithm (Mertens in $O(x^{3/4})$)
> 1. Sieve $\mu(n)$ for $n \leq \sqrt{x}$.  
> 2. For each key value $v$ in increasing order, set
> 
$$M(v) = 1 - \sum_{n \leq \sqrt{v}} \mu(v)\left\lfloor \frac{v}{n}\right\rfloor - \sum_{2 \leq n \leq \sqrt{v}} M\left(\frac{v}{n}\right)$$

The first step takes $O(\sqrt{x})$ time. How about the rest?

The lower key values take a total time of

$$O\left(\sum_{v \leq \sqrt{x}} \sqrt{v}\right) = O\left(\sqrt{x} \sqrt{\sqrt{x}}\right) = O\left(x^{3/4}\right)$$

The upper key values $v = \lfloor x/k \rfloor$ for $k < \sqrt{x}$ contribute about

$$O\left(\sum_{k \leq \sqrt{x}} \sqrt{\frac{x}{k}}\right) = O\left(\int_1^{\sqrt{x}} \sqrt{\frac{x}{k}}dk\right) = O\left(x^{3/4}\right)$$

So this easy algorithm only takes $O(x^{3/4})$ time and $O(x^{1/2})$ space.  
Here's a Nim implementation:

```nim
proc mertens(x: int64): FIarray =
  ##Computes mu(1) + ... + mu(x) in O(x^(3/4)) time.
  var M = newFIArray(x)
  var mu = mobius(x.isqrt.int+1)
  for v in M.keysInc:
    if v == 1:
      M[v] = 1
      continue
    var muV = 1'i64
    var vsqrt = isqrt(v)
    for i in 1..vsqrt:
      muV -= mu[i]*(v div i)
      muV -= M[v div i]
    muV += M[vsqrt]*vsqrt
    M[v] = muV
  return M
```

This takes 7 seconds to compute $M(10^{12}) = 62366$ on my laptop, which is pretty good!

The way we make this faster is yet again very similar to how we made the Lucy_Hedgehog prime counting algorithm faster in the [last post][lucyfenwick] - read it if you haven't yet!

TODO TODO REMOVE
We're going to pick some $\sqrt{x} \leq y \leq x$ to be specified later and compute $M(v)$ for the key values $v \leq y$ by sieving, which will take $O(y)$ time. The rest of them will be done in the way described previously.

How about the remaining key values $v = \lfloor x/k \rfloor > y$? They take

$$O\left(\sum_{k < x/y} \sqrt{x/k}\right) = O\left(\int_1^{x/y} \sqrt{x/k}dk \right) = O\left(x/\sqrt{y}\right)$$

If we want to minimize the total time $O\left(y + x/\sqrt{y}\right)$, we need to pick $y$ to be on the order of $x^{2/3}$. The resulting time (and space) complexity is $O\left(x^{2/3}\right)$ which is better.

In your implementation, you should try different constants to see which one looks like it works the best. For me, choosing $y = 0.25x^{2/3}$ looked alright. You should also cap it by some limit based on how much memory you have available.

Here's how this could look in Nim:

```nim
proc mertensFast(x: int64): FIarray =
  ##Computes mu(1) + ... + mu(x) in O(x^(2/3)) time.
  var M = newFIArray(x)
  var y = (0.25*pow(x.float, 2.0/3.0)).int
  y = min(y, 1e8.int) #adjust this based on how much memory you have
  var smallM = mobius(y+1)
  #we're actually going to store mu(1) + ... + mu(k) instead
  #so accumulate
  for i in 2..y: smallM[i] += smallM[i-1]
  #now smallM[i] = mu(1) + ... + mu(i)
  for v in M.keysInc:
    if v <= y: 
      M[v] = smallM[v]
      continue
    var muV = 1'i64
    var vsqrt = isqrt(v)
    for i in 1..vsqrt:
      muV -= (smallM[i] - smallM[i-1])*(v div i)
      muV -= M[v div i]
    muV += M[vsqrt]*vsqrt
    M[v] = muV
  return M
```

Now we get $M(10^{12})$ in less than 2 seconds on my laptop!

#### Doing It For $\varphi$?

Before, we computed the Mertens function without calling notice to its size - generally it's very small. In the case of the totient summatory function $\Phi(x) = \sum_{n \leq x} \varphi(x)$, it will be quite large. To calculate it then, I'll include a modulus `m` in the functions. If you are using Python or something where you don't have to worry about overflows, then there's no real need for that aside from memory concerns.

Like I said before though, we can compute the totient summatory function $\Phi(x)$ in $O(\sqrt{x})$ further time by using the hyperbola theorem (using $\varphi = \mu * N$) as follows:

```nim
proc sumN(x: int64, m: int64): int64 =
  ##Sum of n from 1 to x, mod m.
  var x = x mod (2*m) #avoid overflows
  if x mod 2 == 0:
    return ((x div 2) * (x+1)) mod m
  else:
    return (((x+1) div 2) * x) mod m

proc totientSummatoryFast1(x: int64, m: int64): int64 =
  ##Computes Phi(x) mod m in O(x^(2/3)) time.
  ##Does NOT compute any other Phi(x/n).
  var M = mertensFast(x)
  #phi = mu * N
  var xsqrt = M.isqrt
  for n in 1..xsqrt:
    result += (M[n] - M[n-1]) * sumN(x div n, m)
    result = result mod m
    result += n * M[x div n]
    result = result mod m
  result -= sumN(xsqrt, m)*M[xsqrt]
  result = result mod m
  if result < 0: result += m #this can happen
```

And just like that we have the totient summatory function in $O(x^{2/3})$ time.  
It computes $\Phi(10^{12}) \equiv 804025910 \bmod 10^9$ in about 2.9 seconds on my laptop.

Alternatively, we could apply the logic from our Mertens function directly, by using the relation $\varphi * u = N$ and the exact same partial-sieving trick as before. Here's how that looks:

```nim
proc totientSummatoryFast2(x: int64, m: int64): FIarray =
  ##Computes phi(1) + ... + phi(x) mod m in O(x^(2/3)) time.
  var Phi = newFIArray(x)
  var y = (0.5*pow(x.float, 2.0/3.0)).int
  y = min(y, 1e8.int) #adjust this based on how much memory you have
  var smallPhi = totient[int64](y+1)
  #again store phi(1) + ... + phi(k) instead
  #so accumulate
  for i in 2..y: 
    smallPhi[i] = (smallPhi[i] + smallPhi[i-1]) mod m
  #now smallPhi[i] = phi(1) + ... + phi(i)
  for v in Phi.keysInc:
    if v <= y: 
      Phi[v] = smallPhi[v]
      continue
    var phiV = sumN(v, m)
    var vsqrt = isqrt(v)
    for i in 1..vsqrt:
      phiV -= ((smallPhi[i] - smallPhi[i-1])*(v div i)) mod m
      phiV -= Phi[v div i]
      phiV = phiV mod m
    phiV += Phi[vsqrt]*vsqrt
    phiV = phiV mod m
    if phiV < 0: phiV += m
    Phi[v] = phiV
  return Phi
```

This runs barely slower than the method to compute a single $\Phi(x)$ from the Mertens values - probably it's just easier to store the Mertens values because they're so small.  
It computes $\Phi(10^{12})$ in about 3.5 seconds.

So, this previous method will work nicely whenever we want to sum a function $f$ such that we have easily summable functions $g, h$ with $f*g = h$, and such that $f$ can be sieved in linear (or approximately linear) time. This is a very wide selection of functions, but there are others yet we can't deal with.

### Min-25 Sieve

### Black Algorithm

### Powerful Number Trick





[totient]: https://en.wikipedia.org/wiki/Euler%27s_totient_function
[mobius]: https://en.wikipedia.org/wiki/M%C3%B6bius_function
[zeta]: https://en.wikipedia.org/wiki/Riemann_zeta_function
[characters]: https://en.wikipedia.org/wiki/Dirichlet_character
[lucyfenwick]: /blog/2023/04/09/lucy-fenwick.html
[baihacker]: https://baihacker.github.io/main/
[linearsieve]: https://codeforces.com/blog/entry/54090