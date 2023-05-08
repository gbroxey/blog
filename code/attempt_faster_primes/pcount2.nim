#==== Lucy+Fenwick ====
import ../utils/[eutil_timer, fiarrays, fenwick], math

proc newFenwick*[T](default: seq[T]): Fenwick[T] =
  ##Converts the seq into a fenwick tree in O(default.len) time.
  result.arr = default
  for i in 1..default.len:
    var j = i + (i and (-i))
    if j<=default.len: result.arr[j-1] += result.arr[i-1]

proc lucyFenwick(x: int64): int64 =
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y = pow(xf * ln(xf) * 0.5, 1.0 / 2.0).int
  if y > 4e9.int: echo "Lowering memory."
  y = min(y, 4e9.int) #upper bound - set this depending on how much ram you have
  if x <= 10000:
    y = x.int #if x is too small, easier to sieve the whole thing

  var A2 = pow(xf, 1.0 / 2.0).int
  # var y = round(0.35*pow(xf, 2.0/3.0) / pow(ln(xf), 2.0/3.0)).inty = max(S.isqrt.int+1, y) #necessary lower bound
  
  var sieveRaw = newSeq[bool](y+1)
  # for i in 2..y: sieveRaw[i] = 1
  
  for v in S.keysInc:
    S[v] = v-1

  
  # for p in 2..A1:
  #   if sieveRaw[p] == 1:
  #     for v in S.keysDec:
  #       if v < p*p: break
  #       S[v] = S[v] - (S[v div p] - S[p-1])
  #     var j = p*p
  #     while j <= y:
  #       sieveRaw[j] = 0
  #       j += p
  var sieve = newFenwick(y+1, 1)
  sieve[0] = 0
  sieve[1] = 0
  proc S0(v: int64): int64 =
    #returns sieve.sum(v) if v <= y, otherwise S[v].
    if v<=y: return sieve.sum(v.int)
    return S[v]
  for p in 2..A2:
    if not sieveRaw[p]:
      #right now: sieveRaw contains true if it has been removed before sieving out p
      var sp = sieve.sum(p-1) #compute it only once
      var lim = min(x div y, x div (p*p))
      S.arr[^1] -= S0(x div p) - sp
      for i in p..lim:
        if sieveRaw[i]: continue
        S.arr[^i.int] -= S0(x div (i*p)) - sp
        #here, S.arr[^i] = S[x div i] is guaranteed due to the size of i.
      var j = p*p
      while j <= y:
        if not sieveRaw[j]:
          sieveRaw[j] = true
          sieve.addTo(j, -1)
        j += p
  # result = S0(x) - S0(S.isqrt) + S0(A2)
  # for p in A2+1..S.isqrt:
  #   if not sieveRaw[p]:
  #     result -= S.arr[^p.int] - sieve.sum(p)
  return S0(x)

proc lucyFenwickFast(x: int64): int64 =
  ##Identical to lucyFenwick except for a slightly changed Lucy update
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y = round(0.35*pow(xf, 2.0/3.0) / pow(ln(xf), 2.0/3.0)).int
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

const n = 1e14.int64
timer: echo lucyFenwick(n)
timer: echo lucyFenwickFast(n)