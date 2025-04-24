iterator chull(xInit, yInit: int64, 
              inside: (proc (x, y: int64): bool),
              cut: (proc (x, y, dx, dy: int64): bool)): (int64, int64, int64, int64) =
  ##Finds the convex hull of integer points
  ##with xInit <= x, and 0 <= y <= f(x).
  ##Yields (x, y, dx, dy), 
  ##where the next edge is from (x, y) to (x+dx, y-dy).
  ##A point is in the shape iff inside(x, y).
  ##The function inside() also enforces the maximum x coordinate.
  ##Also provide cut(x, y, dx, dy) which returns whether f'(x) <= -dy/dx.
  ##This works for f'(x) <= 0 and f''(x) <= 0.
  #---
  var (x, y) = (xInit, yInit)
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
    while inside(x+dx1, y-dy1):
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
      if inside(x+dx1, y-dy1):
        break #by requirement 1, this interval contains the next slope
      #otherwise it is useless, so we discard the interval,
      #while maintaining the steeper endpoint
      discard stack.pop
      (dx2, dy2) = (dx1, dy1)
    if stack.len == 0: break #probably unecessary to add this here

    #the shallowest slope is somewhere in [dy2/dx2,dy1/dx1]
    while true:
      var (mx, my) = (dx1 + dx2, dy1 + dy2) #interval mediant
      if inside(x + mx, y - my):
        (dx1, dy1) = (mx, my) 
        stack.add (mx, my)
        #stack has the intervals [my/mx, dy1/dx1], [dy1/dx1, ..], ...
        #active interval is [dy2/dx2, my/mx]
      else:
        if cut(x+mx, y-my, dx1, dy1):
          #slope search cut condition
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

proc upperTrapezoid(x0, y0, dx, dy, n: int64): int64 =
  ##The number of lattice points (x, y) inside the trapezoid
  ##whose points are (x0, y0), (x0+dx, y0-dy), (x0+dx, n), (x0, n),
  ##and such that x0 < x (so we are not counting the left border).
  result = (dx + 1) * (n - y0 - dy) #rectangle
  result += (((dx + 1) * (dy + 1)) shr 1) + 1 #triangle
  result -= (n - y0) + 1 #left border

proc convexLatticeCount(xInit, yInit: int64, 
              inside: (proc (x, y: int64): bool),
              cut: (proc (x, y, dx, dy: int64): bool)): int64 =
  ##Uses the chull edges to find the number of lattice points
  ##under a decreasing convex function.
  ##Does NOT include points at the border with x = xInit.
  for (x, y, dx, dy) in chull(xInit, yInit, inside, cut):
    result += trapezoid(x, y, dx, dy)

proc concaveLatticeCount(xInit, yInit: int64, 
              inside: (proc (x, y: int64): bool),
              cut: (proc (x, y, dx, dy: int64): bool),
              maxCoord: int64): int64 =
  ##Uses the chull edges to find the number of lattice points
  ##under a decreasing concave function, like y = n/x.
  ##This needs a max
  for (x, y, dx, dy) in chull(xInit, yInit, inside, cut):
    result += trapezoid(x, y, dx, dy)

import ../utils/iops
const N = 1e18.int64

proc inside(x, y: int64): bool =
  return x*x + y*y <= N and y >= 0

proc cut(x, y, dx, dy: int64): bool =
  if x >= N or y <= 0: return true
  return dx * x >= dy * y

const v = 0'i64
const u = isqrt(N)

var test = convexLatticeCount(v, u, inside, cut)
echo 4*test + 1