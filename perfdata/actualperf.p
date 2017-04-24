set logscale
set xrange [1:1000]
set yrange [0.01:100000]

set xlabel "Number of Spheres"
set ylabel "ms to render"

set term png size 800,900
set output 'actual-raytrace-perf.png'
set label 1 "60fps" at (16.67*1700000000 / (1920*1080*35)),16.67 point

plot ((35*x*1920*1080)/1700000000) title 'ms total, FLOP bound (1920x1080)', \
((1920*1080*4 + x*20 + 50)/100000000) title 'ms, bandwidth bound (1920x1080)', \
"performance-original.dat" using 1:2 w linespoints title 'ms, original', \
"performance-inline.dat" using 1:2 w linespoints title 'ms, inlined', \
"performance-soa.dat" using 1:2 w linespoints title 'ms, SoA', \
"performance-pipelined.dat" using 1:2 w linespoints title 'ms, pipelined', \
"performance-gpu2.dat" using 1:2 w linespoints title 'ms, GPU'


reset
set yrange[0:1000]
set output 'implementation-compare.png'
plot "performance-original.dat" using 1:2 w linespoints title 'ms, original', \
"performance-inline.dat" using 1:2 w linespoints title 'ms, inlined', \
"performance-soa.dat" using 1:2 w linespoints title 'ms, SoA', \
"performance-pipelined.dat" using 1:2 w linespoints title 'ms, pipelined', \
"performance-gpu2.dat" using 1:2 w linespoints title 'ms, GPU'