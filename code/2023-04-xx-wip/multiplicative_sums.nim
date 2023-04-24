import ../utils/[iops, fiarrays, sieves], math

proc divisorSummatory(x: int64): int64 =
  ##Computes d(1) + ... + d(x) in O(x^(1/2)) time.
  var xsqrt = isqrt(x)
  for n in 1..xsqrt:
    result += 2*(x div n)
  result -= xsqrt*xsqrt

proc genDivisorSummatory(x: int64, k: int, m: int64): FIArray =
  ##Computes d_k(1) + ... + d_k(x) mod m in O(k x^(2/3)) time.
  var y = (0.55*pow(x.float, 2.0/3.0) / pow(ln(x.float), 1.0/3.0)).int64
  y = max(y, isqrt(x))
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
  #shove them all into an FIArray for easy use
  var Dk = newFIArray(x)
  for v in Dk.keysInc:
    if v <= y: Dk[v] = small[v]
    else: Dk[v] = big[x div v]
  return Dk
    

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

proc sumDn2(x: int64, m: int64): int64 =
  ##Computes d(1^2) + d(2^2) + d(3^2) + ... + d(x^2) in O(x^(2/3)) time.
  var D3 = genDivisorSummatory(x, 3, m)
  var xsqrt = D3.isqrt.int #isqrt(x)
  var mu = mobius(xsqrt+1)
  for n in 1..xsqrt:
    result += mu[n]*D3[x div (n*n)]
    result = result mod m
  if result < 0: result += m
  return result

iterator powerfulExt*(x: int64, h: proc (p, e: int64): int64): (int64, int64) =
  ##Returns (n, h(n)) where n are the O(sqrt x) powerful numbers up to x, 
  ##and h is any multiplicative function.
  var nrt = isqrt(x).int
  var res = @[(1'i64, 1'i64)]
  for p in eratosthenes(nrt):
    var resultNext = newSeq[(int64, int64)]()
    while res.len > 0:
      var (n, hn) = res.pop
      if p*p > x div n:
        yield (n, hn)
        continue
      resultNext.add (n, hn)
      var pp = p*p
      var e = 2
      while pp <= x div n:
        resultNext.add (n*pp, hn*h(p, e))
        if pp > (x div n) div p: break
        pp *= p
        e += 1
    res = resultNext
  #yield any we haven't given yet
  for (n, hn) in res:
    yield (n, hn)

proc sumPowerfulPart(x: int64, m: int64): int64 =
  ##Sums the function f(p) = 1 and f(p^e) = p^e for e > 1.
  #make function h to pass forward
  proc h(p, e: int64): int64 =
    if e == 0: return 1
    if e == 1: return 0
    if e == 2: return (p*p - 1) mod m
    return (powMod(p, e, m) - powMod(p, e-1, m) + m) mod m
  for (n, hn) in powerfulExt(x, h):
    result += hn * ((x div n) mod m)
    result = result mod m




import ../utils/eutil_timer
timer: echo sumPowerfulPart(1e12.int64, 1e9.int64)