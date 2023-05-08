#==== Fenwick Trees ====

type Fenwick*[T] = object
  arr*: seq[T]

proc newFenwick*[T](len: int): Fenwick[T] =
  ##Initializes a fenwick tree with a zero array, f[i] = 0 for all i.
  result.arr.newSeq(len)

proc newFenwick*[T](len: int, default: T): Fenwick[T] =
  ##Initializes a fenwick tree with a constant array, f[i] = default for all i.
  result.arr.newSeq(len)
  for i in 0..<len:
    result.arr[i] = default
  for i in 1..len:
    var j = i + (i and (-i))
    if j<=len: 
      result.arr[j-1] += result.arr[i-1]

proc len*[T](f: Fenwick[T]): int = f.arr.len

proc sum*[T](f: Fenwick[T], i: SomeInteger): T =
  ##Returns f[0] + f[1] + ... + f[i]. Time O(log i).
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii>0:
    result += f.arr[ii-1]
    ii -= (ii and (-ii))

proc addTo*[T](f: var Fenwick[T], i: SomeInteger, c: T) =
  ##Adds c to a single element of the base array. O(log i)
  var ii = i+1 #uses 1-indexing for bit tricks
  while ii<=f.arr.len:
    f.arr[ii-1] += c
    ii += (ii and (-ii))

proc `[]`*[T](f: Fenwick[T], i: SomeInteger): T =
  ##Accesses a single element of the base array. O(log i)
  if i==0: return f.sum(0)
  return f.sum(i) - f.sum(i-1)

proc `[]=`*[T](f: var Fenwick[T], i: SomeInteger, x: T) =
  ##Sets a single element of the base array. O(log i)
  f.addTo(i, x-f[i])