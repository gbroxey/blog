---
title: "Convex Hulls Title WIP"
tags: [algorithms]
date: 1970-01-01
---

> **Abstract.** Several number theoretic sums, primarily $\sum r_2(n)$ and $\sum d(n)$, can be dealt with using straightforward methods in relatively little time. By turning these into geometric problems involving lattice points in convex sets, it's possible to do these sums much faster. This is a fairly standard technique, but it can be difficult to visualize.

---

The first thing I'd like to do here is briefly discuss the two main examples we'll be dealing with.

### Sum of Squares Function $r_2$

The function $r_2(n)$ tells you how many ways an integer $n$ can be written as a sum of two squares, $n = x^2 + y^2$.  
The integers $x, y$ are allowed to be positive, negative, or zero.  
I will write the summatory function as

$$R(n) = \sum_{0 \leq k \leq n} r_2(k)$$

where I will be taking care not to use my personally preferred variable $x$ as a summation limit.[^1]

It is possible to determine $r_2(k)$ given the prime factorization of $k$ (see [A004018][oeisa004018], or [Wikipedia][wikipedia-sum-sq]).  
Because of those formulas, it's technically possible to compute $R(n)$ using multiplicative function techniques, but it's totally unnecessary, so [let's not do that](#addendum).

Instead, we'll do something more sensible. Actually, I've been somewhat misleading in my presentation so far because this is just the number of lattice points in a circle of radius $\sqrt n$.

Each lattice point $(x, y)$ is inside of a circle with radius $r$ if and only if $x^2 + y^2 \leq r^2$.  
Here, $r^2 = n$, and summing over all possible integer values of $x^2 + y^2$ gives us $R(n)$.  

This gives us a very simpleminded way to calculate $R(n)$, which is just to sum over the $O(\sqrt{n})$ different values of $x$ that are allowed. Rather than taking an integer square root and evaluating $\lfloor \sqrt{n-x^2} \rfloor$ to get this bound, we'll maintain the bound as $y$ and decrease it as $x$ increases. We can do it without any extra bells and whistles since we decrease the bound $y$ at most $\sqrt{n}$ times. It ends up being way faster than doing square roots. Here it is in Nim:

```nim
proc R(n: int64): int64 =
  var nsqrt = isqrt(n)
  #do x = 0 first
  result = 1 + 2*nsqrt
  var y = nsqrt
  for x in 1..nsqrt:
    #do x and -x at once
    while x*x + y*y > n: 
      dec y #y--
    result += 2 + 4 * y
```

This takes about 1 sec to compute `R(10^18) = 3141592653589764829`.

### Divisor Count Summatory Function

We considered in [summing multiplicative functions 1][mult1] how to compute the partial sums of the function $d(n)$, defined as the number of divisors of $n$. The summatory function is written as

$$D(n) = \sum_{1 \leq k \leq n} d(k)$$

This is the standard application of the Dirichlet Hyperbola Method, which I described in detail [last time][mult1].

The idea is simple. The function $d(k)$ counts positive integer pairs $(x, y)$ with $xy = k$, and so summing over $k \leq n$ will give us the count of all integer pairs $(x, y)$ with $xy \leq n$. This region forms a hyperbola, hence the name hyperbola method. The important formula comes from exploiting the symmetry of the hyperbola, very quickly counting the lattice points in a small section of the hyperbola, and computing the total count from that.

I included a diagram last time, but since this post is going to have a lot of diagrams and I want stylistic consistency, I've made a new one.[^2] Here's what the hyperbola method is doing:

<center><img src="/blog/docs/assets/images/wip/hyperbola_chunks.png"></center>
<br>

The red area on the left contains $\sum_{x \leq \sqrt{n}} \left\lfloor\frac{n}{x}\right\rfloor$ lattice points.  
Because of symmetry, that's the same number of lattice points as in the blue area on the bottom.  
To get the total count, we can add those two together, so long as we subtract the number of points in the purple square, since those ones get counted twice.

This gives the answer as

$$D(n) = 2\sum_{k \leq \sqrt{n}} \left\lfloor \frac{n}{k} \right\rfloor - \lfloor\sqrt{n}\rfloor^2$$

which is by itself a perfectly good algorithm to compute $D(n)$, in $O(\sqrt{n})$ time:

```nim
proc D(n: int64): int64 =
  ##Computes d(1) + ... + d(n) in O(n^(1/2)) time.
  var nsqrt = isqrt(n)
  for k in 1..nsqrt:
    result += 2*(n div k)
  result -= nsqrt*nsqrt
```

For small values of $n$, this simple algorithm is certainly all you need. Even at $n = 10^{17}$ it is perfectly good at only a bit over two seconds to compute the answer.  
But if we want to push it to something like $n = 10^{24}$, which is more around the range we're interested in today, we will need to do something more involved.[^3]

### Bigger Integers

Oh, right, so the thing is, we want to have our inputs and outputs much larger than $10^{19}$ which is roughly the limit of a 64-bit signed integer. If you're doing this in something like Python where bigger integers are handled for you automatically then skip this section I guess.

The language I've been using so far, Nim, does not have a built in BigInt or Int128 type, which is what we'd love to be using for this. Because of that, we need to find a third party solution, or implement our own. Given that this article isn't about how to implement fast bigger integer data types, we would opt for something third party. What I found works best is [nint128][nint128], which is a package I use in my own Project Euler library. So, if you're using Nim and want to run these functions for the large inputs they're really built for, you can modify the code that is to follow so that it uses whatever package you choose.

## Convex Hulls

Let's look at the set of points in the positive quarter circle that we want to count.

<center><img src="/blog/docs/assets/images/wip/circ_points.png"></center>
<br>

I've also decided to attach a black rubber band at the top left and bottom right points, and then allowed it to stretch tightly over the lattice points inside the circle. The polygon formed by the points touching this rubber band is known as the convex hull of the points inside the circle. The remainder of this article is about how we can exploit these convex hulls to count the lattice points inside a shape like this.

Let's first pretend that we have a way to obtain the points on the convex hull extremely quickly, and see how it is possible to count the number of lattice points inside the shape.

### Using the Convex Hull

The simplest case, really, is when there are only one or two points on the convex hull.  
It could look something like this:

<center><img src="/blog/docs/assets/images/wip/large_small_circ_trapezoids.png"></center>
<br>

As I've indicated, the most natural thing to do to this polygon is to break it into trapezoids[^4]. We obviously don't want to be counting any lattice points twice, which would happen where the trapezoids border each other. Therefore we throw out the points on the left boundary of each trapezoid so they can slot together. Because of that, we have to count the points on the $y$-axis separately.

A general trapezoid is defined by its upper left convex hull point $(x, y)$, and the vector $(dx, -dy)$ to the next convex hull point.[^5] Given these values, is it easy to count the number of lattice points in the trapezoid?  

Of course! The below trapezoid has $(x, y) = (0, 6)$, and $(dx, -dy) = (3, -2)$:

<center><img src="/blog/docs/assets/images/wip/trapezoid_points_large.png"></center>
<br>

We have a rectangle with $(dx+1)(y-dy)$ points, a triangle, and the left border of $y+1$ points.  

We deal with the triangle in the standard way, more symmetry:

<center><img src="/blog/docs/assets/images/wip/large_triangle_half_rectangle.png"></center>
<br>

The number of lattice points in the triangle is $\frac{(dx+1)(dy+1)}{2} + 1$, since we don't want to split those two vertices on the hypotenuse equally, we want both of them on one triangle. Notice that we're taking advantage of $\gcd(dx, dy) = 1$, so that there are no more points on the hypotenuse of the triangle. Let's write the trapezoid point counter now:

```nim
proc trapezoid(x0, y0, dx, dy: int64): int64 =
  ##The number of lattice points (x, y) inside the trapezoid
  ##whose points are (x0, y0), (x0+dx, y0-dy), (x0+dx, 0), (x0, 0),
  ##and such that x0 < x (so we are not counting the left border).
  result = (dx + 1) * (y0 - dy) #rectangle
  result += (((dx + 1) * (dy + 1)) shr 1) + 1 #triangle
  result -= y0 + 1 #left border
```

Now we are convinced that, given the points of the convex hull of a shape, we can count the lattice points inside. Here's how a positive quarter circle looks, broken up into trapezoids:

<center><img src="/blog/docs/assets/images/wip/circ_trapezoids.png"></center>
<br>

### Wait, a Hyperbola Does Not Make a Convex Set

Oops. Okay, but helpfully, we are allowed to count whatever points we want, so instead we'll count the points outside of the hyperbola. We can rotate everything around like this:

<center><img src="/blog/docs/assets/images/wip/hyperbola_flip.png"></center>
<br>

For the hyperbola $xy \leq n$, we mapped $(x, y) \to (n+1-x, n+1-y)$. It happens that we have a nice convex shape now, except we want to count points above the shape instead of inside the shape. That's not so bad:

```nim
proc upperTrapezoid(x0, y0, dx, dy, n: int64): int64 =
  ##The number of lattice points (x, y) inside the trapezoid
  ##whose points are (x0, y0), (x0+dx, y0-dy), (x0+dx, n), (x0, n),
  ##and such that x0 < x (so we are not counting the left border).
  result = (dx + 1) * (n - y0 - dy) #rectangle
  result += (((dx + 1) * (dy + 1)) shr 1) + 1 #triangle
  result -= (n - y0) + 1 #left border
```


## Finding the Convex Hull

This is the really important part of this algorithm. All of the stuff with trapezoids is completely useless if we can't quickly find them! This section is about how we can efficiently jump from one chull point to the next.

At this point is when I'd like to introduce this problem more generally.

We have a function $f$ defined on some interval $[x_0, x_1]$ which takes non-negative real values.  

Additionally, we assume that $f$ has nonpositive derivative and second derivative on the interior of the interval, so that the set of points $(x, y)$ with $x_0 \leq x \leq x_1$ and $0 \leq y \leq f(x)$ forms a convex set. In the previous examples, we had $f(x) = \sqrt{n - x^2}$ on the interval $[0, \sqrt{n}]$ and then $f(x) = n/x$ on the interval $[1, n]$.

We want to be able to handle this for whatever $f$ we give it, so I'll phrase it in general when I can, but the diagrams from here on will mostly be the circle case, since that one is nicer.

---

Let's suppose we are at a convex hull point $(x, y)$ and want to find the next.

<center><img src="/blog/docs/assets/images/wip/blob_slopes.png"></center>
<br>

Generally there will be lots of options for vectors $(dx, -dy)$ to choose to get to the next point. In the above, we should clearly prefer the vector $(5, -3)$ over the vector $(3, -2)$ since the former is shallower[^6]. The next point on the convex hull will be at $(x+dx, y-dy)$ where $(dx, -dy)$ is the shallowest vector such that the resulting point fits in the blob we are considering. So the question becomes, how can we quickly find this shallowest $(dx, -dy)$?

### Stern-Brocot Binary Search Tree

TODO :)


## How Many Trapezoids?

---

## Addendum

What if we did want to compute the sum $R(n)$ with multiplicative functions?  
I only just started writing this article and I'm already distracted, oh no.

Anyways, for $k > 0$, $r_2(k)$ actually is $4$ times a multiplicative function in $k$.  
I'll go ahead and write $r_2(k) = 4g(k)$ for $k > 0$.

It happens that $g(k)$ is the number of divisors of $k$ which are $1$ mod $4$ minus the number of divisors which are $3$ mod $4$. We can write this as $g(k) = \sum_{d \mid k} \chi(d)$, where $\chi$ is the nontrivial Dirichlet character modulo 4. In other words, $\chi$ is the periodic function whose values begin as $1, 0, -1, 0$, and so on repeating.

This is not actually so hard to work with, since now

$$R(n) = 1 + 4\left[\sum_{k \leq \sqrt{n}} X(n/k) + \sum_{k \leq \sqrt{n}} X(k) \left\lfloor \frac{n}{k} \right\rfloor - X(\sqrt{n})\lfloor \sqrt{n}\rfloor\right]$$

where $X(n) = \sum_{k \leq n} \chi(n)$ is also periodic, whose values begin as $1, 1, 0, 0$ and so on.  
If you wanted to, you could implement this in $O(\sqrt n)$ time as

```nim
proc R(n: int64): int64 =
  let sqrtn = isqrt(n)
  for k in 1..sqrtn:
    result += [0, 1, 1, 0][(n div k) mod 4]
    result += [0, 1, 0, -1][k mod 4] * (n div k)
  result -= [0, 1, 1, 0][sqrtn mod 4] * sqrtn
  return 1 + 4*result
```

You can think about this longer and eventually get $\frac{\pi}{4} = 1 - \frac{1}{3} + \frac{1}{5} - \frac{1}{7} + \ldots$ if you want.

---

Hi

[oeisa004018]: https://oeis.org/A004018
[wikipedia-sum-sq]: https://en.wikipedia.org/wiki/Sum_of_squares_function
[mult1]: /blog/2023/04/30/mult-sum-1.html
[nint128]: https://github.com/rockcavera/nim-nint128
[aseprite]: https://www.aseprite.org/

[^1]: Obviously the reason is that we are using $(x, y)$ as coordinates on a grid, and I would rather avoid the confusion. So from here on, we will be using $n$ as our summation limit, and $k$ as the free variable in the summation. The letters $x, y$ will always be used to refer to some sort of coordinates.

[^2]: I made all the diagrams on this page by hand in [Aseprite][aseprite]. The hyperbola is a Bézier curve with points at $(1, 16), (2, 3), (3, 2), (16, 1)$.

[^3]: Unless you're extremely patient. For $n = 10^{24}$ I estimated something like over two hours runtime for this more basic algorithm. It is pretty parallelizable though, if you're exceptionally lazy, since it has no memory requirement.

[^4]: Or into trapeziums if you're British.

[^5]: Actually you probably don't need $x$, but later you might be counting points of a specific form inside the trapezoid for which you may want information about the $x$ value.

[^6]: We can consider $(0, -1)$ to be the steepest vector, and $(1, 0)$ to be the shallowest. So really we're finding $(dx, -dy)$ such that $dy/dx$ is as low as possible, and such that $(x+dx, y-dy)$ fits in the blob.