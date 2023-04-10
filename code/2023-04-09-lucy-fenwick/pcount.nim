import ../utils/iops, math

type FIArray = object
  ##Given x, stores a value at each distinct (x div n).
  x: int64
  isqrt: int64
  arr: seq[int64]

proc newFIArray(x: int64): FIArray =
  ##Initializes a new FIArray with result[v] = 0 for all v.
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc `[]`(S: FIArray, v: int64): int64 =
  ##Accesses S[v].
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`(S: var FIArray, v: int64, z: int64) =
  ##Sets S[v] = z.
  if v <= S.isqrt: S.arr[v-1] = z
  else: S.arr[^(S.x div v).int] = z

iterator keysInc(S: FIArray): int64 =
  ##Iterates over the key values of S in increasing order.
  for v in 1..S.isqrt: yield v
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for n in countdown(S.isqrt - 1, 1):
    yield S.x div n

iterator keysDec(S: FIArray): int64 =
  ##Iterates over the key values of S in decreasing order.
  for n in 1..(S.isqrt - 1):
    yield S.x div n
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for v in countdown(S.isqrt, 1): yield v

#==== Algorithm (Lucy) ====

proc lucy(x: int64): FIArray =
  var S = newFIArray(x)
  for v in S.keysInc:
    S[v] = v-1
  for p in 2..S.isqrt:
    if S[p] == S[p-1]: continue
    #p is prime
    for v in S.keysDec:
      if v < p*p: break
      S[v] = S[v] - (S[v div p] - S[p-1])
  return S

#==== Fenwick Trees ====

type Fenwick[T] = object
  arr: seq[T]

proc newFenwick[T](len: int): Fenwick[T] =
  ##Initializes a fenwick tree with a zero array, f[i] = 0 for all i.
  result.arr.newSeq(len)

proc newFenwick[T](len: int, default: T): Fenwick[T] =
  ##Initializes a fenwick tree with a constant array, f[i] = default for all i.
  result.arr.newSeq(len)
  for i in 0..<len:
    result.arr[i] = default
  for i in 1..len:
    var j = i + (i and (-i))
    if j<=len: 
      result.arr[j-1] += result.arr[i-1]

proc len[T](f: Fenwick[T]): int = f.arr.len

proc sum[T](f: Fenwick[T], i: SomeInteger): T =
  ##Returns f[0] + f[1] + ... + f[i]. Time O(log i).
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii>0:
    result += f.arr[ii-1]
    ii -= (ii and (-ii))

proc addTo[T](f: var Fenwick[T], i: SomeInteger, c: T) =
  ##Adds c to a single element of the base array. O(log i)
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii<=f.arr.len:
    f.arr[ii-1] += c
    ii += (ii and (-ii))

proc `[]`[T](f: Fenwick[T], i: SomeInteger): T =
  ##Accesses a single element of the base array. O(log i)
  if i==0: return f.sum(0)
  return f.sum(i) - f.sum(i-1)

proc `[]=`[T](f: var Fenwick[T], i: SomeInteger, x: T) =
  ##Sets a single element of the base array. O(log i)
  f.addTo(i, x-f[i])

#==== Lucy+Fenwick ====

proc lucyFenwick*(n: int64, c: int = -1): FIArray =
  ##Returns (pi(n/v)) for all distinct values of floor(n/v).
  ##Runs in time n/sqrt(c) and space c.
  ##Defaults to c = n^(2/3) for optimal time = O(n^(2/3))
  ##For large n, c is capped at 3e8 due to memory concerns.
  var c = c
  var sqrtn: int = isqrt(n).int
  if c == -1:
    c = round(pow(n.float64, 2.0/3.0) / pow(ln(n.float64), 3.0/3.0)).int
    c = min(c, 4e9.int)
    c = max(sqrtn+1, c)
    if n <= 1e4.int:
      c = n.int
  var sieveRaw: seq[bool] #true iff it has been sieved out already
  newSeq(sieveRaw, c+1)
  var sieve = newFenwick[int](c+1, 1) #initialized to 1
  sieve[1] = 0
  sieve[0] = 0
  
  var pi = newFIArray(n)
  for v in 1..pi.isqrt:
    pi.arr[v-1] = v-1
  for v in 1..pi.isqrt-1:
    pi.arr[^v.int] = (n div v) - 1

  proc getVal(x: int64): int64 =
    if x<=c: return sieve.sum(x.int)
    return pi[x]
    
  for p in 2..sqrtn:
    if not sieveRaw[p]:
      #right now: sieveRaw contains true if it has been removed before sieving out p
      var sp = sieve.sum(p-1)
      var lim = min(n div c, n div (p*p))
      for i in 1..lim:
        pi.arr[^i.int] -= getVal(n div (i*p)) - sp
        
      var j = p*p
      var t = p*(1 + (p and 1))
      while j<=c:
        if not sieveRaw[j]:
          sieveRaw[j] = true
          sieve.addTo(j, -1)
        j += t

  for v in pi.keysInc:
    if v>c: break
    pi[v] = sieve.sum(v.int)
  return pi

import ../utils/eutil_timer

const n = 1e14.int64
timer: echo lucyFenwick(n)[n]
timer: echo lucy(n)[n]