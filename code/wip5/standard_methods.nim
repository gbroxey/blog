import ../utils/[eutil_timer, iops], math

proc D(n: int64): int64 =
  ##Computes d(1) + ... + d(n) in O(n^(1/2)) time.
  var nsqrt = isqrt(n)
  for k in 1..nsqrt:
    result += 2*(n div k)
  result -= nsqrt*nsqrt

proc R(n: int64): int64 =
  var nsqrt = isqrt(n)
  #do x = 0 first
  result = 1 + 2*nsqrt
  var y = nsqrt
  for x in 1..nsqrt:
    while x*x + y*y > n: 
      dec y #y--
    #do x and -x at once
    result += 2 + 4 * y

timer: echo R(1e18.int64)