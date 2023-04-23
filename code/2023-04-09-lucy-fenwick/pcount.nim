import ../utils/[iops, fiarrays], math

#FIArray code moved to util class

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

proc lucyFenwick(x: int64): FIArray =
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y = round(1.70*pow(xf, 2.0/3.0) / pow(2.0*ln(xf)*ln(ln(xf)), 2.0/3.0)).int
  y = min(y, 4e9.int) #upper bound - set this depending on how much ram you have
  y = max(S.isqrt.int+1, y) #necessary lower bound
  if x <= 10000:
    y = x.int #if x is too small, easier to sieve the whole thing

  var sieveRaw = newSeq[bool](y+1)
  var sieve = newFenwick[int](y+1, 1) #initialized to 1
  sieve[1] = 0
  sieve[0] = 0
  
  for v in S.keysInc:
    S[v] = v-1

  proc S0(v: int64): int64 =
    #returns sieve.sum(v) if v <= y, otherwise S[v].
    if v<=y: return sieve.sum(v.int)
    return S[v]
    
  for p in 2..S.isqrt:
    if not sieveRaw[p]:
      #right now: sieveRaw contains true if it has been removed before sieving out p
      var sp = sieve.sum(p-1) #compute it only once
      var lim = min(x div y, x div (p*p))
      for i in 1..lim:
        S.arr[^i.int] -= S0(x div (i*p)) - sp
        #here, S.arr[^i] = S[x div i] is guaranteed due to the size of i.
      var j = p*p
      while j <= y:
        if not sieveRaw[j]:
          sieveRaw[j] = true
          sieve.addTo(j, -1)
        j += p

  for v in S.keysInc:
    if v>y: break
    if sieveRaw[v]:
      S[v] = S[v-1]
    else: 
      S[v] = S[v-1] + 1
  return S

#==== Lucy+Progressions ====

proc lucyAP(n: int64, k: int): seq[FIArray] =
  #find reduced residues
  var cop: seq[int] = @[]
  var ci = newSeq[int](k) #ci[v] = index of v in cop if gcd(v, k) = 1
  for i in 1..k-1:
    if gcd(i, k)==1:
      cop.add(i)
      ci[i] = cop.high
  #cop has size phi(k)

  var pis = newSeq[FIArray](cop.len)
  for i in 0..cop.high:
    pis[i] = newFIArray(n)
    for v in pis[i].keysInc:
      pis[i][v] = (v - cop[i] + k) div k
      if i == 0: pis[i][v] = pis[i][v] - 1

  var minv = newSeq[int](k) #mod inverse of i mod k
  for i in 1..<k:
    if gcd(i, k) == 1: 
      #compute mod inverse of i by brute force
      for j in 1..<k:
        if (i*j) mod k == 1:
          minv[i] = j
          break
  for p in 2..pis[0].isqrt:
    if gcd(p, k)>1: continue
    #p is prime if any of the pis[i][p] > pis[i][p-1]
    var isPrime = false
    for i in 0..<pis.len:
      if pis[i][p] > pis[i][p-1]:
        isPrime = true
        break
    if not isPrime: continue
    var sp = newSeq[int64](cop.len) #pis[i][p-1]
    for i in 0..cop.high:
      sp[i] = pis[ci[(cop[i]*minv[p mod k]) mod k]][p-1]
    for v in pis[0].keysDec:
      if v < p*p: break
      for i in 0..cop.high:
        var index = ci[(cop[i]*minv[p mod k]) mod k]
        var eliminated = pis[index][v div p] - pis[index][p-1]
        pis[i][v] = pis[i][v] - eliminated
  return pis

#==== Further Optimization ====

proc lucyFenwickFast(x: int64): int64 =
  ##Identical to lucyFenwick except for a slightly changed Lucy update
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y = round(1.7*pow(xf, 2.0/3.0) / pow(2.0*ln(xf)*ln(ln(xf)), 2.0/3.0)).int
  y = min(y, 4e9.int) #upper bound - set this depending on how much ram you have
  y = max(S.isqrt.int+1, y) #necessary lower bound
  if x <= 10000:
    y = x.int #if x is too small, easier to sieve the whole thing

  var sieveRaw = newSeq[bool](y+1)
  var sieve = newFenwick[int](y+1, 1) #initialized to 1
  sieve[1] = 0
  sieve[0] = 0
  
  for v in S.keysInc:
    S[v] = v-1

  proc S0(v: int64): int64 =
    #returns sieve.sum(v) if v <= y, otherwise S[v].
    if v<=y: return sieve.sum(v.int)
    return S[v]
  for p in 2..S.isqrt:
    if not sieveRaw[p]:
      #right now: sieveRaw contains true if it has been removed before sieving out p
      var sp = sieve.sum(p-1) #compute it only once
      var lim = min(x div y, x div (p*p))
      #===THIS SECTION IS DIFFERENT
      S.arr[^1] -= S0(x div p) - sp
      for i in p..lim:
        if sieveRaw[i]: continue
        S.arr[^i.int] -= S0(x div (i*p)) - sp
        #here, S.arr[^i] = S[x div i] is guaranteed due to the size of i.
      #===
      var j = p*p
      while j <= y:
        if not sieveRaw[j]:
          sieveRaw[j] = true
          sieve.addTo(j, -1)
        j += p
  return S[x]
