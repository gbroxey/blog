##Integer operations

proc isqrt*(x:int64): int64 =
  ##Simple procedure for floor(sqrt x)
  if x==1: return 1
  var a: int64 = x shr 1
  var b: int64 = x
  while a<b:
    var c = (a + (x div a)) shr 1
    (a, b) = (c, a)
  return b