import ../utils/[eutil_timer, iops, fiarrays, sieves], math

#see 2023-04-09-lucy-fenwick/pcount.nim
proc lucy(x: int64, g: proc(p: int): int64, G: proc(v: int64): int64, modulus: int64 = 0): FIArray =
  ##Modified standard Lucy algorithm.
  ##Computes sums of g(p) over primes.
  ##Given is g(p) for primes p, and G(v) = sum g(n) over 1 < n <= v.
  ##Optional modulus.
  var S = newFIArray(x)
  var V = keysFI(x)
  for i, v in V.pairs:
    S.arr[i] = G(v)
  for p in eratosthenes(S.isqrt.int+1):
    #since p is small we have
    let sp = S.arr[p-2] #= S[p-1]
    for i in countdown(V.len - 1, 0):
      let v = V[i]
      if v < p*p: break
      S.arr[i] -= g(p)*(S[v div p] - sp)
      if modulus > 0: S.arr[i] = S.arr[i] mod modulus
  return S

proc unlucy(S: var FIArray, f: proc(p: int, e: int): int64, modulus: int64 = 0): void =
  ##Unsieves all of the primes. Second phase of Min-25 algorithm.
  ##Computes sums of f(n) over 1 < n <= v.
  ##Given is S[v] = sum of f(p) over primes p <= v, and f(p, e) = f(p^e).
  ##Optional modulus.
  let x = S.x
  var V = keysFI(x)
  let primes = eratosthenes(S.isqrt.int+1)
  for k in countdown(primes.high, 0):
    let p = primes[k]
    #since p is small we have
    let sp = S.arr[p-1] #= S[p]
    for idx in countdown(V.high, 0):
      let v = V[idx]
      if v < p*p: break
      #iterate over p^(i+1) <= v with i >= 1
      var i = 1
      var u = v div p # = v//p^i
      while u >= p: #p^(i+1) <= v
        S.arr[idx] += f(p, i) * (S[u] - sp) + f(p, i+1)
        if modulus > 0: S.arr[idx] = S.arr[idx] mod modulus
        inc i
        u = u div p

proc example_one() =
  proc g(p: int): int64 = 1
  proc G(v: int64): int64 = v-1
  proc f(p: int, e: int): int64 = e

  let x = 1e12.int64
  var timer = startTimer()
  var S = lucy(x, g, G)
  unlucy(S, f)
  echo S[x]
  timer.stop

proc example_one_old_way() =
  ##Sums the function f(p) = 1 and f(p^e) = e for e > 1.
  ##Uses the old method - powerful numbers trick.
  ##We obtain sum x // n over powerful n.
  ##Use n = a^2 * b^3 where a is anything and b is squarefree.
  let x = 1e18.int64
  let cbrtx = 1e6.int
  var timer = startTimer()
  var not_sqfr = newSeq[bool](cbrtx+1)
  for i in 2..cbrtx:
    if i*i > cbrtx: break
    for j in countup(i*i, cbrtx, i*i):
      not_sqfr[j] = true
  var total = 0'i64
  for b in 1'i64..cbrtx:
    if not_sqfr[b]: continue
    let a_max = isqrt(x div (b*b*b))
    for a in 1..a_max:
      total += x div (a*a*b*b*b)
  echo total
  timer.stop

#copied from 2023-04-09-lucy-fenwick/pcount.nim
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

proc example_two() =
  let x = 1e12.int64
  var timer = startTimer()
  var S = lucyAP(x, 4)[0] #counts of primes = 1 mod 4
  timer.mark "Lucy step completed."
  proc f(p: int, e: int): int64 = 
    if p mod 4 != 1: return 0
    else: return e
  unlucy(S, f)
  timer.mark "Unlucy step completed."
  echo S[x]
  timer.stop