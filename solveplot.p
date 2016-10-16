set autoscale
unset log
unset label
set xtic auto
set ytic auto
set title "Time for model solve"
set ylabel "Time (s)"
set xlabel "Number of Timesteps"
set xr [0:300]
plot "data/urbs-py-0926-1000-120-modsol.csv" using 1:4 title "urbs.py" with points lw 1.5, \
     "data/urbs-jl-0926-1000-60-modsol.csv" using 1:4 title "urbs.jl" with points lt 14 lw 1.5
