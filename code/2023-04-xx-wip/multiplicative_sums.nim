import ../utils/[iops, fiarrays, sieves], math

proc divisorSummatory(x: int64): int64 =
  ##Computes d(1) + ... + d(x) in O(x^(1/2)) time.
  var xsqrt = isqrt(x)
  for n in 1..xsqrt:
    result += 2*(x div n)
  result -= xsqrt*xsqrt

proc linearSieveProdUnit(f: seq[int64], m: int64): seq[int64] =
  #Returns the dirichlet product of f and u in linear time.
  #Assumes f[1] = 1 and that f is multiplicative.
  #m is modulus.
  #linear sieves - https://codeforces.com/blog/entry/54090
  let y = f.len
  newSeq(result, y)
  var composite: seq[bool]
  var pow = newSeq[int](y) #power of leastprimefactor(n) in n
  newSeq(composite, y)
  var prime = newSeq[int]()
  result[1] = 1
  for i in 2..<y:
    if not composite[i]:
      prime.add i
      result[i] = f[i] + 1 #i is prime
      pow[i] = i
    for j in 0..<prime.len:
      if i*prime[j]>=y: break
      composite[i*prime[j]] = true
      if i mod prime[j] == 0:
        pow[i*prime[j]] = pow[i] * prime[j]
        var v = i div pow[i]
        if v != 1:
          result[i*prime[j]] = (result[v] * result[prime[j] * pow[i]]) mod m
        else:
          var coef = 0'i64
          var A = 1
          var B = pow[i] * prime[j]
          while B > 0:
            coef += f[A]
            coef = coef mod m
            A *= prime[j]
            B = B div prime[j]
          result[i*prime[j]] = coef
        break
      else:
        result[i*prime[j]] = result[i]*result[prime[j]]
        pow[i*prime[j]] = prime[j]
    
proc genDivisorSummatory(x: int64, k: int, m: int64): FIArray =
  ##Computes d_k(1) + ... + d_k(x) mod m in O(k x^(2/3)) time.
  var y = (0.55*pow(x.float, 2.0/3.0)).int64
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
    small = linearSieveProdUnit(small, m)
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

iterator powerfulExt(x: int64, h: proc (p, e: int64): int64, m: int64): (int64, int64) =
  ##Returns (n, h(n) mod m) where n are the O(sqrt x) powerful numbers up to x, 
  ##and h is any multiplicative function.
  var nrt = isqrt(x).int
  var res = @[(1'i64, 1'i64, 0)]
  var ps = eratosthenes(nrt+1)
  while res.len > 0:
    var (n, hn, i) = res.pop
    let p = ps[i].int64
    if i >= ps.len or p*p > x div n:
      yield (n, hn)
      continue
    res.add (n, hn, i+1)
    var pp = p*p
    var e = 2
    while pp <= x div n:
      res.add (n*pp, (hn*h(p, e)) mod m, i+1)
      if pp > (x div n) div p: break
      pp *= p
      e += 1

proc sumPowerfulPart(x: int64, m: int64): int64 =
  ##Sums the function f(p) = 1 and f(p^e) = p^e for e > 1.
  #make function h to pass forward
  proc h(p, e: int64): int64 =
    if e == 0: return 1
    if e == 1: return 0
    if e == 2: return (p*p - 1) mod m
    return (powMod(p, e, m) - powMod(p, e-1, m) + m) mod m
  for (n, hn) in powerfulExt(x, h, m):
    result += hn * ((x div n) mod m)
    result = result mod m

proc linearCoefficient*(inputs, outputs: seq[int64], m: int64): int64 =
  var p0 = outputs
  var p1 = newSeq[int64](inputs.len)
  for i in 1..inputs.high:
    for j in 0..inputs.high - i:
      #p_{j, j+i}
      p0[j] = (inputs[j]*p0[j+1]-inputs[j+i]*p0[j]) mod m
      p0[j] = (p0[j]*modInv(m - inputs[j+i] + inputs[j], m)) mod m
      p1[j] = (p0[j] - inputs[j+i]*p1[j] - p0[j+1] + inputs[j]*p1[j+1]) mod m
      p1[j] = (p1[j]*modInv(m - inputs[j+i] + inputs[j], m)) mod m
  return p1[0]

proc primePi(x: int64, m: int64): int64 =
  ##Computes pi(x) mod m in O(x^(2/3) log x) time.
  ##See genDivisorSummatory.

  var y = (0.55*pow(x.float, 2.0/3.0)).int64
  y = max(y, isqrt(x))
  var small = newSeq[int64](y+1)
  var big = newSeq[int64]((x div y) + 1)
  #initialize them to D_1, sum of u(n) = 1
  for i in 1..y: small[i] = i mod m
  for i in 1..(x div y): big[i] = (x div i) mod m

  var k = 1
  while (1'i64 shl (k+1)) <= x: inc k
  #we need F_j(x) for j from 0 to k
  var F = newSeq[int64](k+1)
  F[0] = 1
  F[1] = (x mod m)
  #we need binomial coefficients up to k
  var binoms = newSeq[seq[int64]](k+1)
  binoms[0] = @[1'i64]
  for i in 1..k:
    binoms[i] = newSeq[int64](k+1)
    binoms[i][0] = 1
    binoms[i][i] = 1
    for j in 1..i-1:
      binoms[i][j] = (binoms[i-1][j] + binoms[i-1][j-1]) mod m
  #now compute all of the h_j(p^e).
  #only need them for j >= 2.
  var hVals = newSeq[seq[int64]](k+1)
  for j in 2..k:
    hVals[j] = newSeq[int64](k+1)
    for i in 0..j:
      var jPow = 1'i64
      if i mod 2 == 1: jPow = -1
      for e in i..k:
        #jPow = (-1)^i j^(e-i)
        hVals[j][e] += binoms[j][i] * jPow
        hVals[j][e] = hVals[j][e] mod m
        jPow = (j * jPow) mod m
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
        bigNew += (small[n] - small[n-1]) * ((v div n) mod m)
        bigNew = bigNew mod m
      bigNew -= small[vsqrt]*vsqrt
      big[i] = bigNew mod m
    #update small using sieving
    #be lazy...
    #convert small from summation to just d_{j-1}, convolve, then convert back
    for i in countdown(y, 1):
      small[i] -= small[i-1]
    small = linearSieveProdUnit(small, m)
    for i in 1..y:
      small[i] = (small[i] + small[i-1]) mod m
    #new part starts here - we need to use the powerful numbers trick
    #create h(p, e) to pass on
    proc h(p, e: int64): int64 = hVals[j][e]
    for (n, hn) in powerfulExt(x, h, m):
      if (x div n) <= y:
        F[j] += hn * small[x div n]
      else:
        F[j] += hn * big[n]
      F[j] = F[j] mod m
  var inputs = newSeq[int64](k+1)
  for i in 0..k: inputs[i] = i
  result = linearCoefficient(inputs, F, m)
  if result < 0: result += m
