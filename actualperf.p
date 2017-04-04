set logscale
set xrange [1:1000]
set yrange [0.01:3000]

set term png size 800,600
set output 'actual-raytrace-perf.png'
set label 1 "60fps" at (16.67*1700000000 / (1920*1080*35)),16.67 point

plot ((35*x*1920*1080)/1700000000) title 'ms total, FLOP bound (1920x1080)', \
((1920*1080*4 + x*20 + 50)/100000000) title 'ms, bandwidth bound (1920x1080)', \
"performance-original.dat" using 1:2 w linespoints title 'ms, actual'
