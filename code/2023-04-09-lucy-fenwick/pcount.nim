import ../utils/fiarrays, math

#FIArray code moved to util class

#==== Algorithm (Lucy) ====

proc lucy(x: int64): FIArray =
  var S = newFIArray(x)
  var V = keysFI(x)
  for i, v in V.pairs:
    S.arr[i] = v-1 #set S[v] = v-1
  for p in 2..S.isqrt:
    #since p is small we have
    #S[p] = S.arr[p-1], S[p-1] = S.arr[p-2]
    if S.arr[p-1] == S.arr[p-2]: continue
    #p is prime
    let sp = S.arr[p-2] #= S[p-1]
    for i in countdown(V.len - 1, 0):
      let v = V[i]
      if v < p*p: break
      #S[v] = S[v] - (S[v div p] - S[p-1])
      S.arr[i] = S.arr[i] - (S[v div p] - sp)
  return S

import ../utils/fenwick

#==== Lucy+Fenwick ====

proc lucyFenwick(x: int64): FIArray =
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y: int
  if x == 1: y = 1
  else: 
    y = round(0.35*pow(xf, 2.0/3.0) / pow(ln(xf), 2.0/3.0)).int
    y = min(y, 4e9.int) #upper bound - set this depending on how much ram you have
    y = max(S.isqrt.int+1, y) #necessary lower bound
  var sieveRaw = newSeq[bool](y+1)
  var sieve = newFenwick[int](y+1, 1) #initialized to 1
  sieveRaw[1] = true
  sieveRaw[0] = true
  sieve[1] = 0
  sieve[0] = 0

  let V = keysFI(x)
  for i, v in V.pairs:
    S.arr[i] = v-1

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
  for i, v in V.pairs:
    if v>y: break
    S.arr[i] = sieve.sum(v)
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
  let V = keysFI(n)
  for i in 0..cop.high:
    pis[i] = newFIArray(n)
    for j, v in V.pairs:
      pis[i].arr[j] = (v - cop[i] + k) div k
      if i == 0: pis[i].arr[j] = pis[i].arr[j] - 1

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
    let pmodk = p mod k
    #p is prime if any of the pis[i][p] > pis[i][p-1]
    var isPrime = false
    for i in 0..<pis.len:
      if pis[i].arr[p-1] > pis[i].arr[p-2]:
        isPrime = true
        break
    if not isPrime: continue
    var sp = newSeq[int64](cop.len) #pis[i][p-1]
    for i in 0..cop.high:
      sp[i] = pis[ci[(cop[i]*minv[p mod k]) mod k]].arr[p-2]
    for i in countdown(V.len - 1, 0):
      let v = V[i]
      if v < p*p: break
      let vdivp = v div p
      let vdivp_idx = pis[0].indexOf(vdivp)
      for j in 0..cop.high:
        var index = ci[(cop[j]*minv[pmodk]) mod k]
        var eliminated = pis[index].arr[vdivp_idx] - pis[index].arr[p-2]
        pis[j].arr[i] = pis[j].arr[i] - eliminated
  return pis

#==== Further Optimization ====

proc lucyFenwickFast(x: int64): int64 =
  ##Identical to lucyFenwick except for a slightly changed Lucy update
  var S = newFIArray(x)
  #compute y
  var xf = x.float64
  var y: int
  if x == 1: y = 1
  else:
    var y = round(0.35*pow(xf, 2.0/3.0) / pow(ln(xf), 2.0/3.0)).int
    y = min(y, 4e9.int) #upper bound - set this depending on how much ram you have
    y = max(S.isqrt.int+1, y) #necessary lower bound
  var sieveRaw = newSeq[bool](y+1)
  var sieve = newFenwick[int](y+1, 1) #initialized to 1
  sieveRaw[1] = true
  sieveRaw[0] = true
  sieve[1] = 0
  sieve[0] = 0

  let V = keysFI(x)
  for i, v in V.pairs:
    S.arr[i] = v-1

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