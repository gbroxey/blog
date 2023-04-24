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

proc powMod*(x: int64, y: int64, m: int64): int64 =
  ##Computes x^y mod m, where y >= 0.
  if y == 0: return 1
  if y == 1: return x
  result = 1
  var xPow = x
  var ySh = y
  while ySh>0:
    if ySh mod 2 == 1:
      result = (result * xPow) mod m
    ySh = ySh shr 1
    xPow = (xPow * xPow) mod m