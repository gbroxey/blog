import ../utils/[eutil_timer, iops]

proc R(n: int64): int64 =
  let sqrtn = isqrt(n)
  for k in 1..sqrtn:
    result += [0, 1, 1, 0][(n div k) mod 4]
    result += [0, 1, 0, -1][k mod 4] * (n div k)
  result -= [0, 1, 1, 0][sqrtn mod 4] * sqrtn
  return 1 + 4*result

timer: echo R(1e16.int64)