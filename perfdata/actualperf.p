set logscale
set xrange [1:1000]
set yrange [0.01:100000]

set xlabel "Number of Spheres"
set ylabel "ms to render"

set term png size 1280,800
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
set yrange[0.5:10000]
set logscale
set output 'implementation-compare.png'
plot "performance-original.dat" using 1:2 w linespoints title 'ms, original', \
"performance-inline.dat" using 1:2 w linespoints title 'ms, inlined', \
"performance-soa.dat" using 1:2 w linespoints title 'ms, SoA', \
"performance-pipelined.dat" using 1:2 w linespoints title 'ms, pipelined', \
"performance-gpu3.dat" using 1:2 w linespoints title 'ms, GPU', \
"performance-gpuwarp.dat" using 1:2 w linespoints title 'ms, GPU warp'

reset
set logscale
set output 'gpu-compare.png'
plot (((x*19+28)*2*1920*1080)/8710000000.0) title 'ms total, FLOP bound (GPU)', \
"performance-gpu1.dat" using 1:2 w linespoints title 'ms, gpu 1', \
"performance-gpu2.dat" using 1:2 w linespoints title 'ms, gpu 2', \
"performance-gpuwarp.dat" using 1:2 w linespoints title 'ms, gpu warp-aware', \
"performance-gpu3.dat" using 1:2 w linespoints title 'ms, gpu 3'
