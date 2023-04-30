Show[RegionPlot[
  1 <= x && 1 <= y && x y <= 10, {x, 1/2, 10 + 1/2}, {y, 1/2, 
   10 + 1/2}, FrameTicks -> {{2 Range[5], None}, {2 Range[5], None}}, 
  PlotStyle -> Opacity[.5, LightBlue], BoundaryStyle -> Dashed, 
  GridLines -> {Range[10], Range[10]}],
 Plot[10/x, {x, 1, 10}, PlotRange -> All],
 RegionPlot[
  1 <= x && 1 <= y && x <= 2.3 && y <= 10/2.3, {x, 1/2, 10 + 1/2}, {y,
    1/2, 10 + 1/2}, PlotStyle -> Opacity[0.5, LightRed], 
  BoundaryStyle -> None],
 ContourPlot[(x - 2.3) (y - 10/2.3) == 0, {x, 1, 10}, {y, 1, 10/x}, 
  ContourStyle -> Directive[Dashed, Opacity[0.9, Red]]],
 ListPlot[Flatten[Table[{x, y}, {x, 1, 10}, {y, 1, 10/x}], 1], 
  PlotStyle -> Directive[Black, PointSize -> 0.015]]]