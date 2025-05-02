import ../utils/iops

iterator chull(x0, y0: int64, 
              x1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): (int64, int64, int64, int64) =
  ##Finds the convex hull of integer points
  ##with xInit <= x, and 0 <= y <= f(x).
  ##Yields (x, y, dx, dy), 
  ##where the next edge is from (x, y) to (x+dx, y-dy).
  ##A point is in the shape iff inside(x, y).
  ##The function inside() also enforces the maximum x coordinate.
  ##Also provide prune(x, y, dx, dy) which returns whether f'(x) <= -dy/dx.
  ##This works for f'(x) <= 0 and f''(x) <= 0.
  #---
  var (x, y) = (x0, y0)
  var stack = @[(0'i64, 1'i64), (1'i64, 0'i64)]
  #stack of slopes (dx, dy) = -dy/dx
  #always kept in order of steepest slope to shallowest slope
  #adjacent values form slope search intervals
  while true:
    var (dx1, dy1) = stack.pop()
    #(dx1, dy1) is the shallowest possible slope in the convex hull
    if dx1 == 0: #going straight down
      #no need to make any silly looking chull points
      break
    #use the slope -dy1/dx1 as much as possible
    while x + dx1 <= x1 and inside(x + dx1, y - dy1):
      yield (x, y, dx1, dy1)
      x += dx1
      y -= dy1
    #test if we are at the end already..
    if y == 0: break

    #get current slope search interval
    var (dx2, dy2) = (dx1, dy1)
    while stack.len != 0:
      (dx1, dy1) = stack[^1]
      #here, [dy2/dx2, dy1/dx1] forms the shallowest slope search interval
      if x + dx1 <= x1 and inside(x + dx1, y - dy1):
        break #by requirement 1, this interval contains the next slope
      #otherwise it is useless, so we discard the interval,
      #while maintaining the steeper endpoint
      discard stack.pop
      (dx2, dy2) = (dx1, dy1)
    if stack.len == 0: break #probably unecessary to add this here

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
  for (x, y, dx, dy) in chull(x0, y0, x1, inside, prune):
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

proc convexLatticeCount(x0, y0: int64, 
              x1, y1: int64,
              inside: (proc (x, y: int64): bool),
              prune: (proc (x, y, dx, dy: int64): bool)): int64 =
  ##Uses the chull edges to find the number of lattice points
  ##under a decreasing convex function.
  ##This is for f' <= 0 and f'' >= 0.
  ##Does NOT include points at the border with x = xInit.
  proc inBounds(x, y: int64): bool =
    x0 <= x and x <= x1 and y1 <= y and y <= y0 + 1
  proc insideFlipped(x, y: int64): bool = 
    inBounds(x1 - x, 1 + y0 - y) and (not inside(x1 - x, 1 + y0 - y))
  proc pruneFlipped(x, y, dx, dy: int64): bool = 
    (not inBounds(x1 - x, 1 + y0 - y)) or prune(x1 - x, 1 + y0 - y, dx, dy)
  for (x, y, dx, dy) in chull(0, y0 - y1, x1, insideFlipped, pruneFlipped):
    result += trapezoid(x1 - x - dx, 1 + y0 - y + dy, dx, dy) - 1

proc hyperbolaLatticePointCountBad(n: int64): int64 =
  let nrt = isqrt(n)
  var x0 = 1'i64
  var y0 = n div x0
  var x1 = nrt
  var y1 = n div x1
  proc inside(x, y: int64): bool =
    return x*y <= n
  proc prune(x, y, dx, dy: int64): bool =
    return dx * y >= dy * x
  var L = convexLatticeCount(x0, y0, x1, y1, inside, prune)
  L += 1 + y0 #add in the points on the left boundary
  L -= x1 #get rid of the points on the x-axis
  return 2*L - nrt*nrt

proc hyperbolaLatticePointCount(n: int64): int64 =
  let nrt = isqrt(n)
  var x0 = iroot(2*n, 3)
  var y0 = n div x0
  var x1 = nrt
  var y1 = n div x1
  proc inside(x, y: int64): bool =
    return x*y <= n
  proc prune(x, y, dx, dy: int64): bool =
    return dx * y >= dy * x
  var L = convexLatticeCount(x0, y0, x1, y1, inside, prune)
  for i in 1..x0: #add in the points with x <= x0
    L += (n div i) + 1
  L -= x1 #get rid of the points on the x-axis
  return 2*L - nrt*nrt

import ../utils/eutil_timer
timer: echo hyperbolaLatticePointCount(1e17.int64)