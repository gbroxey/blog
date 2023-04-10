import ../utils/[iops, eutil_timer]


#==== Interesting stuff is below here ====

type FIArray = object
  ##Given x, stores a value at each distinct (x div n).
  x: int64
  isqrt: int64
  arr: seq[int64]

proc newFIArray(x: int64): FIArray =
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc `[]`(S: FIArray, v: int64): int64 =
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`(S: var FIArray, v: int64, z: int64) =
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

proc pi(x: int64): FIArray =
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