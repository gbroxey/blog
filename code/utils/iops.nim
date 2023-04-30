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

proc safeMul*(x: int64, y: int64, M: int64): int64 =
  #safer to avoid overflows :)
  if M <= 0: return x*y
  #M can be at most 2^63 / 63 ~ 1.4e17
  var x = x mod M
  if x < 0: x += M
  var y = y mod M
  if y < 0: y += M
  # if y < 0: y += M
  if x shr 31 == 0 and y shr 31 == 0: return (x*y) mod M
  while x!=0:
    if x mod 2 == 1:
      result += y
    # if result >= M: result -= M
    x = x shr 1
    y = y shl 1
    if y > M: y -= M
    # if x.int == x and y.int == y: return (result + x*y) mod M
  result = result mod M
  if result < 0: result += M

proc extendedEuclidean*(x: int64, m: int64): (int64, int64, int64) =
  ##Returns integers (a, b, gcd(x, m)) with ax + by = gcd(x,m).
  var xk = x
  var mk = m
  var abcd: array[4, int64] = [1'i64, 0'i64, 0'i64, 1'i64]
  #mk = a*m + b*x
  #xk = c*m + d*x
  while xk!=0:
    var q: int64 = mk div xk
    #mk <- xk, xk <- mk-q xk
    var newC: int64 = abcd[0] - q * abcd[2]
    var newD: int64 = abcd[1] - q * abcd[3]
    abcd = [abcd[2], abcd[3], newC, newD]
    (mk, xk) = (xk, mk - q * xk)
  result = (abcd[1], abcd[0], safeMul(abcd[1], x, m))
  if result[2] < 0:
    return (-result[0], -result[1], -result[2])

proc modInv*(x: int64, m: int64): int64 =
  var x = x mod m
  var ext = extendedEuclidean(x, m)
  return ext[0] mod m