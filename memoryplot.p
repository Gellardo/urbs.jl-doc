set autoscale
unset log
unset label
set xtic auto
set ytic auto
set title "Approximate Memory consumption of the model generation"
set key right center
set ylabel "Speicherverbrauch (MB)"
set xlabel "Number of Timesteps"
plot "data/20161011T1437.csv" using 1:($5/1000) title "urbs.py" with points, \
     "data/2016-10-10T21:03:17.csv" using 1:($5/1000000) title "urbs.jl" with points lt 14
