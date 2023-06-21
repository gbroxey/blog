Show[RegionPlot[{x^2 + y^2 <= 110, 
   Floor[x]^2 + Floor[y]^2 <= 
    110, (Floor[x] + 1)^2 + (Floor[y] + 1)^2 <= 110}, {x, 0, 
   Ceiling@Sqrt[110]}, {y, 0, Ceiling@Sqrt[110]}, 
  GridLines -> {Range[11], Range[11]}], 
 ListPlot[Flatten[Table[{x, y}, {x, 1, 10}, {y, 1, Sqrt[110 - x^2]}], 
   1], PlotStyle -> Directive[Black, 0.5]]]