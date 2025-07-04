import ../utils/iops

iterator chullConcave(x0, y0: int64, 
              x1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): (int64, int64, int64, int64) =
  ##Finds the convex hull of integer points
  ##with xInit <= x <= x1, and 0 <= y <= f(x), where f is concave.
  ##Yields (x, y, dx, dy), 
  ##where the next edge is from (x, y) to (x+dx, y-dy).
  ##(x0, y0) is the top left point of the hull.
  ##A point is in the shape iff inside(x, y).
  ##Also provide prune(x, y, dx, dy) which returns whether f'(x) <= -dy/dx.
  ##This works for f'(x) <= 0 and f''(x) <= 0.
  #---
  var (x, y) = (x0, y0)
  var stack = newSeq[(int64, int64)]()
  #stack of slopes (dx, dy) = -dy/dx
  #always kept in order of steepest slope to shallowest slope
  #adjacent values form slope search intervals

  #deal with slope 0/1 first
  while inside(x+1, y):
    yield (x, y, 1'i64, 0'i64)
    inc x
  
  #now determine the first interval sequence
  #1/0, 1/1, 1/2, 1/3, ..., 1/k
  #you can do this by binary search if you care
  var k = 0'i64
  while x + k + 1 <= x1 and inside(x + k + 1, y - 1): inc k
  
  while true:
    var dx1, dy1: int64
    if stack.len == 0:
      if k <= 0: break #no need to process this slope
      (dx1, dy1) = (k, 1)
      dec k
    else: 
      (dx1, dy1) = stack.pop()
    #(dx1, dy1) is the shallowest possible slope in the convex hull
    #use the slope -dy1/dx1 as much as possible
    while x + dx1 <= x1 and inside(x + dx1, y - dy1):
      yield (x, y, dx1, dy1)
      x += dx1
      y -= dy1
    #test if we are at the end already..
    if y == 0: break

    #get current slope search interval
    var (dx2, dy2) = (dx1, dy1)
    while k >= 0:
      if stack.len == 0:
        (dx1, dy1) = (k, 1)
      else: 
        (dx1, dy1) = stack[^1]
      #here, [dy2/dx2, dy1/dx1] forms the shallowest slope search interval
      if x + dx1 <= x1 and inside(x + dx1, y - dy1):
        break #by requirement 1, this interval contains the next slope
      #otherwise it is useless, so we discard the interval,
      #while maintaining the steeper endpoint
      if stack.len == 0:
        dec k
      else:
        discard stack.pop
      (dx2, dy2) = (dx1, dy1)
    #the shallowest slope is somewhere in [dy2/dx2,dy1/dx1]
    while true:
      var (mx, my) = (dx1 + dx2, dy1 + dy2) #interval mediant
      if x + mx <= x1 and inside(x + mx, y - my):
        (dx1, dy1) = (mx, my) 
        stack.add (mx, my)
        #stack has the intervals [my/mx, dy1/dx1], [dy1/dx1, ..], ...
        #active interval is [dy2/dx2, my/mx]
      else:
        if x + mx > x1 or prune(x + mx, y - my, dx1, dy1):
          #slope search prune condition
          #the intervals [(dy2+n*dy1)/(dx2+n*dx1), dy1/dx1] never work
          #fully discard dy2/dx2 and therefore the interval [dy2/dx2,dy1/dx1]
          break
        #refine the search to [my/mx, dy1/dx1]
        (dx2, dy2) = (mx, my)
    #the search is over
    #top of the stack contains the next active search interval

proc trapezoid(x0, y0, dx, dy: int64): int64 =
  ##The number of lattice points (x, y) inside the trapezoid
  ##whose points are (x0, y0), (x0+dx, y0-dy), (x0+dx, 0), (x0, 0),
  ##and such that x0 < x (so we are not counting the left border).
  result = (dx + 1) * (y0 - dy) #rectangle
  result += (((dx + 1) * (dy + 1)) shr 1) + 1 #triangle
  result -= y0 + 1 #left border

proc concaveLatticeCount(x0, y0: int64, 
              x1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): int64 =
  ##Uses the chull edges to find the number of lattice points
  ##under a decreasing concave function.
  ##This is for f' <= 0 and f'' <= 0.
  ##Does NOT include points at the border with x = xInit.
  ##The point (x0, y0) is the top left point satisfying y0 <= f(x0).
  for (x, y, dx, dy) in chullConcave(x0, y0, x1, inside, prune):
    result += trapezoid(x, y, dx, dy)

proc circleLatticePointCount(n: int64): int64 =
  let sqrtn = isqrt(n)
  proc inside(x, y: int64): bool =
    return x*x + y*y <= n and y >= 0
  proc prune(x, y, dx, dy: int64): bool =
    if x > sqrtn or y <= 0: return true
    return dx * x >= dy * y
  var L = concaveLatticeCount(0, sqrtn, sqrtn, inside, prune)
  return 4*L + 1

proc circleLatticePointCount2(n: int64): int64 =
  let sqrtn = isqrt(n)
  proc inside(x, y: int64): bool =
    return x*x + y*y <= n and y >= 0
  proc prune(x, y, dx, dy: int64): bool =
    if x > sqrtn or y <= 0: return true
    return dx * x >= dy * y
  var x1 = isqrt(n div 2)
  var L = 1 + sqrtn + concaveLatticeCount(0, sqrtn, x1, inside, prune)
  L = (2*L - (1+x1)*(1+x1)) - sqrtn - 1
  return 4*L + 1

proc R(n: int64): int64 =
  var nsqrt = isqrt(n)
  #do x = 0 first
  result = 1 + 2*nsqrt
  var y = nsqrt
  for x in 1..nsqrt:
    while x*x + y*y > n: 
      dec y #y--
    #do x and -x at once
    result += 2 + 4 * y

iterator chullConvex(x0, y0: int64, 
              x1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): (int64, int64, int64, int64) =
  ##Finds the convex hull of integer points
  ##with xInit <= x <= x1, and f(x) < y, where f is convex.
  ##Yields (x, y, dx, dy), 
  ##where the next edge is from (x, y) to (x+dx, y-dy).
  ##(x0, y0) is the top left point of the hull, and satisfies f(x0) < y0.
  ##A point is in the shape iff inside(x, y).
  ##Also provide prune(x, y, dx, dy) which returns whether f'(x) >= -dy/dx.
  ##Note the order of the above inequality compared to chullConcave.
  ##This works for f'(x) <= 0 and f''(x) >= 0.
  #---
  var (x, y) = (x0, y0)
  var stack = newSeq[(int64, int64)]()
  #stack of slopes (dx, dy) = -dy/dx
  #always kept in order of shallowest slope to steepest slope
  #adjacent values form slope search intervals
  
  #no need to deal with the slope 1/0, since
  #we assume (x0, y0) is the top left point of the hull
  #and therefore inside(x0, y0-1) == true
  assert inside(x0, y0-1) #if you please
  
  #now determine the first interval sequence
  #0/1, 1/1, 2/1, 3/1, ..., k/1
  #you can do this by binary search if you care
  var k = 0'i64
  while not inside(x + 1, y - k - 1): inc k

  while true:
    var dx1, dy1: int64
    if stack.len == 0:
      if k < 0: break
      (dx1, dy1) = (1, k)
      dec k
    else: 
      (dx1, dy1) = stack.pop()
    #(dx1, dy1) is the steepest possible slope in the convex hull
    #dx1 == 0 should never happen in the case we deal with
    #use the slope -dy1/dx1 as much as possible
    while x + dx1 <= x1 and not inside(x + dx1, y - dy1):
      yield (x, y, dx1, dy1)
      x += dx1
      y -= dy1
    #test if we are at the end already..
    #again this is not going to happen for the case we deal with
    if y == 0: break

    #get current slope search interval
    var (dx2, dy2) = (dx1, dy1)
    while k >= 0:
      if stack.len == 0:
        (dx1, dy1) = (1, k)
      else: 
        (dx1, dy1) = stack[^1]
      #here, [dy1/dx1, dy2/dx2] forms the steepest slope search interval
      if x + dx1 <= x1 and not inside(x + dx1, y - dy1):
        break #by requirement 1, this interval contains the next slope
      #otherwise it is useless, so we discard the interval,
      #while maintaining the shallower endpoint
      if stack.len == 0:
        dec k
      else:
        discard stack.pop
      (dx2, dy2) = (dx1, dy1)

    #the steepest slope is somewhere in [dy1/dx1,dy2/dx2]
    while true:
      var (mx, my) = (dx1 + dx2, dy1 + dy2) #interval mediant
      if x + mx <= x1 and not inside(x + mx, y - my):
        (dx1, dy1) = (mx, my) 
        stack.add (mx, my)
        #stack has the intervals ..., [..., dy1/dx1], [dy1/dx1, my/mx]
        #active interval is [my/mx, dy2/dx2]
      else:
        if x + mx > x1 or prune(x + mx, y - my, dx1, dy1):
          #slope search prune condition
          #the intervals [dy1/dx1, (dy2+n*dy1)/(dx2+n*dx1)] never work
          #fully discard dy2/dx2 and therefore the interval [dy1/dx1, dy2/dx2]
          break
        #refine the search to [dy1/dx1, my/mx]
        (dx2, dy2) = (mx, my)
    #the search is over
    #top of the stack contains the next active search interval

proc convexLatticeCount(x0, y0: int64, 
              x1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): int64 =
  ##Uses the chull edges to find the number of lattice points
  ##under a decreasing convex function.
  ##This is for f' <= 0 and f'' >= 0.
  ##Does NOT include points at the border with x = xInit.
  ##The point (x0, y0) is the top left point satisfying f(x0) < y0.
  for (x, y, dx, dy) in chullConvex(x0, y0, x1, inside, prune):
    result += trapezoid(x, y, dx, dy) - 1

proc hyperbolaLatticePointCount(n: int64): int64 =
  let nrt = isqrt(n)
  var x0 = iroot(2*n, 3)
  var y0 = n div x0
  var x1 = nrt
  proc inside(x, y: int64): bool =
    return x*y <= n
  proc prune(x, y, dx, dy: int64): bool =
    return dx * y <= dy * x
  var L = convexLatticeCount(x0, y0 + 1, x1, inside, prune)
  for i in 1..x0: #add in the points with x <= x0
    L += (n div i) + 1
  L -= x1 #get rid of the points on the x-axis
  return 2*L - nrt*nrt

proc D(n: int64): int64 =
  ##Computes d(1) + ... + d(n) in O(n^(1/2)) time.
  var nsqrt = isqrt(n)
  for k in 1..nsqrt:
    result += 2*(n div k)
  result -= nsqrt*nsqrt

echo hyperbolaLatticePointCount(1e17.int64)