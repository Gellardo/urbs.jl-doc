set autoscale
unset log
unset label
set xtic auto
set ytic auto
set title "Time for model generation"
set key right center
set ylabel "Time (s)"
set xlabel "Number of Timesteps"
set xr [0:5000]
plot "data/20161011T1437.csv" using 1:3 title "urbs.py" with points lw 1.5, \
     "data/2016-10-10T21:03:17.csv" using 1:3 title "urbs.jl" with points lt 14 lw 1.5
