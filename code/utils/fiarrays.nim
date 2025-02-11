import iops, tables

##Given x, store the different values floor(x/n) in increasing order
var keysTableFI = initTable[int64, seq[int64]]()

proc keysFI*(x: int64): seq[int64] =
  if keysTableFI.hasKey(x): return keysTableFI[x]
  #generate key table for the first time
  let rt = isqrt(x)
  result = @[]
  for v in 1..rt: result.add v
  if rt != x div rt: 
    result.add x div rt
  for n in countdown(rt - 1, 1):
    result.add x div n
  #save it in case we want to use these keys again later
  keysTableFI[x] = result

type FIArray* = object
  ##Given x, stores a value at each distinct (x div n).
  x*: int64
  isqrt*: int64
  arr*: seq[int64]
  #keys is accessed by keysTable[x]

proc newFIArray*(x: int64): FIArray =
  ##Initializes a new FIArray with result[v] = 0 for all v.
  result.x = x
  var isqrt = isqrt(x)
  result.isqrt = isqrt
  var L = 2*isqrt
  if isqrt == (x div isqrt): dec L
  result.arr = newSeq[int64](L)

proc indexOf*(S: FIArray, v: int64): int =
  ##Computes the index of key value v in S.arr, using a division.
  ##Try NOT to need to use this, as divisions are very slow.
  if v <= S.isqrt: return v-1
  return S.arr.len - (S.x div v)

proc `[]`*(S: FIArray, v: int64): int64 =
  ##Accesses S[v], using a division.
  if v <= 0: return 0
  if v <= S.isqrt: return S.arr[v-1]
  return S.arr[^(S.x div v).int] #equiv S.arr[L - (S.x div v)]

proc `[]=`*(S: var FIArray, v: int64, z: int64) =
  ##Sets S[v] = z, using a division.
  if v <= S.isqrt: S.arr[v-1] = z
  else: S.arr[^(S.x div v).int] = z