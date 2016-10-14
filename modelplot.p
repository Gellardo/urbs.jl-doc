set autoscale
unset log
unset label
set xtic auto
set ytic auto
set title "Time for model generation"
set ylabel "Time (s)"
set xlabel "Number of Timesteps"
set xr [0:500]
plot "data/urbs-py-0926-1000-120-modsol.csv" using 1:3 title "urbs.py" with points, \
     "data/urbs-jl-0926-1000-60-modsol.csv" using 1:3 title "urbs.jl" with points lt 14
