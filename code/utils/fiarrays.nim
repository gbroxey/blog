import iops
type FIArray* = object
  ##Given x, stores a value at each distinct (x div n).
  x*: int64
  isqrt*: int64
  arr*: seq[int64]

proc newFIArray*(x: int64): FIArray =
  ##Initializes a new FIArray with result[v] = 0 for all v.
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc `[]`*(S: FIArray, v: int64): int64 =
  ##Accesses S[v].
  if v <= 0: return 0
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`*(S: var FIArray, v: int64, z: int64) =
  ##Sets S[v] = z.
  if v <= S.isqrt: S.arr[v-1] = z
  else: S.arr[^(S.x div v).int] = z

iterator keysInc*(S: FIArray): int64 =
  ##Iterates over the key values of S in increasing order.
  for v in 1..S.isqrt: yield v
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for n in countdown(S.isqrt - 1, 1):
    yield S.x div n

iterator keysDec*(S: FIArray): int64 =
  ##Iterates over the key values of S in decreasing order.
  for n in 1..(S.isqrt - 1):
    yield S.x div n
  if S.isqrt != S.x div S.isqrt: 
    yield S.x div S.isqrt
  for v in countdown(S.isqrt, 1): yield v