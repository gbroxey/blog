proc isqrt(x:int64): int64 =
  ##Simple procedure for floor(sqrt x)
  if x==1: return 1
  var a: int64 = x shr 1
  var b: int64 = x
  while a<b:
    var c = (a + (x div a)) shr 1
    (a, b) = (c, a)
  return b

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

proc `[]`(S: var FIArray, v: int64): var int64 =
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

