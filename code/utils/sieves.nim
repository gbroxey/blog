proc mobius*(n:int): seq[int] =
  ##Sieves the mobius function of the integers strictly below n.
  #linear sieves - https://codeforces.com/blog/entry/54090
  newSeq(result, n)
  var composite: seq[bool]
  newSeq(composite, n)
  var prime = newSeq[int]()
  result[1] = 1
  for i in 2..<n:
    if not composite[i]:
      prime.add i
      result[i] = -1 #i is prime
    for j in 0..<prime.len:
      if i*prime[j]>=n: break
      composite[i*prime[j]] = true
      if i mod prime[j] == 0:
        result[i*prime[j]] = 0
        break
      else:
        result[i*prime[j]] = -result[i]

proc totient*[T: SomeInteger](n:int): seq[T] =
  ##Sieves the euler phi function of the integers strictly below n.
  #linear sieves - https://codeforces.com/blog/entry/54090
  newSeq(result, n)
  var composite: seq[bool]
  newSeq(composite, n)
  var prime = newSeq[int]()
  result[1] = 1
  for i in 2..<n:
    if not composite[i]:
      prime.add i
      result[i] = i-1 #i is prime
    for j in 0..<prime.len:
      if i*prime[j]>=n: break
      composite[i*prime[j]] = true
      if i mod prime[j] == 0:
        result[i*prime[j]] = result[i]*prime[j]
        break
      else:
        result[i*prime[j]] = result[i]*(prime[j]-1)