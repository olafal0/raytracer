set style line 1 lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 1 ps 1 lt 1 lw 2 # --- green
set style line 3 lc rgb '#0200AE' pt 1 ps 1 lt 1 lw 2 # --- blue

set logscale
set xrange [1:1000]
set yrange [0.01:100]

set xlabel "Number of Spheres"
set ylabel "ms to render"

set term svg size 1000,1000 enhanced background rgb 'white' font 'Verdana,14'

set output 'expected-raytrace-perf.svg'
set title "Max Theoretical Performance"
set label 1 "60fps" at (16.67*1700000000 / (1920*1080*35)),16.67 point
plot ((35*x*1920*1080)/1700000000) title 'ms total, FLOP bound (1920x1080)', \
((1920*1080*4 + x*20 + 50)/100000000) title 'ms, bandwidth bound (1920x1080)'


set output 'actual-raytrace-perf.svg'
set logscale
set xrange [1:1000]
set yrange [0.01:10000]
set label 1 "60fps" at (16.67*1700000000 / (1920*1080*35)),16.67 point
set title "CPU Implementation"
plot ((35*x*1920*1080)/1700000000) title 'ms total, FLOP bound (1920x1080)', \
((1920*1080*4 + x*20 + 50)/100000000) title 'ms, bandwidth bound (1920x1080)', \
"performance-original.dat" using 1:2 w linespoints title 'ms, original', \
"performance-pipelined.dat" using 1:2 w linespoints title 'ms, best'


reset
set title "CPU Implementation Comparison"
set xlabel "Number of Spheres"
set ylabel "ms to render"
set yrange[4:2000]
set logscale
set output 'implementation-compare.svg'
plot "performance-original.dat" using 1:2 w linespoints title 'ms, original', \
"performance-inline.dat" using 1:2 w linespoints title 'ms, inlined', \
"performance-soa.dat" using 1:2 w linespoints title 'ms, SoA', \
"performance-pipelined.dat" using 1:2 w linespoints title 'ms, pipelined'

reset
set title "GPU Implementation Comparison"
set xlabel "Number of Spheres"
set ylabel "ms to render"
set yrange[0.4:200]
set logscale
set output 'gpu-compare.svg'
plot "performance-gpu1.dat" using 1:2 w linespoints title 'ms, gpu v1', \
"performance-gpu2.dat" using 1:2 w linespoints title 'ms, gpu v2', \
"performance-gpuwarp.dat" using 1:2 w linespoints title 'ms, gpu warp-aware', \
"performance-gpu3.dat" using 1:2 w linespoints title 'ms, gpu v3'
