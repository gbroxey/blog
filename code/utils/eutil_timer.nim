##Timer utility ripped from my Euler library

import times, terminal, strutils, math

func showDigits*(x: float, n: int): string = 
  return x.formatFloat(ffDecimal, n)

type Timer* = tuple
  ##A Timer which can give more detailed information.
  ##Use start, mark, mark, ..., stop.
  timeStart: float
  timeLastCheckpoint: float
  timePrinting: float
  threadTimeElapsed: float
  pausedAt: float
  

proc start*(t: var Timer) =
  t.timeStart = cpuTime()
  t.timeLastCheckpoint = t.timeStart

proc startTimer*(): Timer = result.start

proc mark*(t: var Timer, message: string = "") =
  ##Marks the time since last checkpoint (or since the Timer was started).
  ##You can provide an optional message, which can be any variable with a $ function implemented.
  var timeNow = cpuTime()
  if message.len > 0: echo message
  var dt = timeNow - t.timeLastCheckpoint
  if dt>0.00001:
    stdout.styledWriteLine(fgCyan):
      "   " & dt.showDigits(3) & "s since last checkpoint."
  #echo "   ", $(timeNow - t.timeStart), " seconds elapsed total."
  var timeNew = cpuTime()
  t.timePrinting += timeNew - timeNow
  t.timeLastCheckpoint = timeNew

proc mark*[T](t: var Timer, message: T) = t.mark $message
#helper to make things slightly cleaner in practice

# proc fork*(t: var Timer): Timer =
#   ##Creates a thread-local Timer.
#   result.start

proc absorb*(t: var Timer, threadTimer: Timer) =
  ##Absorbs a thread-local Timer.
  t.threadTimeElapsed += threadTimer.pausedAt - threadTimer.timeStart

proc pause*(t: var Timer) =
  t.pausedAt = cpuTime()

proc resume*(t: var Timer) =
  var dt = cpuTime() - t.pausedAt
  t.timeStart += dt
  t.timeLastCheckpoint += dt

proc stop*(t: Timer) =
  ##Prints the total time elapsed. Does not update time variables - only use when you are DONE with the Timer.
  var timeNow = cpuTime()
  stdout.styledWriteLine(fgGreen):
    "Total time elapsed (prog): " & (timeNow - t.timeStart - t.timePrinting).showDigits(3) & "s"
  stdout.styledWriteLine(fgGreen):
    "                   (real): " & (timeNow - t.timeStart).showDigits(3) & "s"
  if t.threadTimeElapsed > 0:
    stdout.styledWriteLine(fgGreen):
      "                 (thread): " & (timeNow - t.timeStart + t.threadTimeElapsed).showDigits(3) & "s"

template timer*(body: untyped): untyped =
  ##Very quick and barebones version of Timer.
  ##Use for timing *very short snippets of code*.
  ##For example, if you are timing a single proc at the end of a bunch of code (see e795 for example).
  block:
    var tpTimer = startTimer()
    body
    tpTimer.stop

template repeatedTiming*(times: int, body: untyped): untyped =
  ##This repeatedly executes body and displays the average time and standard deviation of the time it took to run.
  import terminal #in case it's not here
  var timePrev = cpuTime()
  var timeTotal = 0'f64
  var timeSqTotal = 0'f64
  var dt: float64
  var ut = 1.0'f64
  for _ in 1..times:
    body
    (dt, timePrev) = (cpuTime() - timePrev, cpuTime())
    timeTotal += dt
    if dt < ut and dt > 0.0:
      timeSqTotal *= dt / ut
      ut = dt
    timeSqTotal += dt
  timeTotal = timeTotal / times.float64
  timeSqTotal = timeSqTotal / times.float64
  stdout.styledWriteLine(fgGreen):
    "Total time elapsed (average): " & (timeTotal).showDigits(6) & "s"
  stdout.styledWriteLine(fgGreen):
    "                 (deviation): " & sqrt(timeSqTotal * ut - timeTotal^2).showDigits(6) & "s"
  stdout.styledWriteLine(fgGreen):
    "                      (real): " & (timeTotal * times.float64).showDigits(3) & "s"

template repeatedBatchTiming*(times: int, size: int, body: untyped): untyped =
  ##This repeatedly executes body in batches of size, and displays the average time and standard deviation of the time it took to run.
  ##Use this when what you're timing is *very* fast, to get accurate measurements.
  import terminal #in case it's not here
  var timePrev = cpuTime()
  var timeTotal = 0'f64
  var timeSqTotal = 0'f64
  var dt: float64
  var ut = 1.0'f64
  for _ in 1..times:
    for _ in 1..size:
      body
    (dt, timePrev) = (cpuTime() - timePrev, cpuTime())
    timeTotal += dt
    if dt < ut and dt > 0.0:
      timeSqTotal *= dt / ut
      ut = dt
    timeSqTotal += dt
  timeTotal = timeTotal / times.float64
  timeSqTotal = timeSqTotal / times.float64
  stdout.styledWriteLine(fgGreen):
    "Total time elapsed (average): " & (timeTotal / size.float64).showDigits(8) & "s"
  # echo timeSqTotal * ut - timeTotal^2
  stdout.styledWriteLine(fgGreen):
    "                 (deviation): " & (sqrt(abs(timeSqTotal * ut - timeTotal^2)) / sqrt(size.float64)).showDigits(8) & "s"
  stdout.styledWriteLine(fgGreen):
    "                      (real): " & timeTotal.showDigits(3) & "s"