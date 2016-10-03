set title "Rx IQ setttings mode: USB"
set ylabel "Setting"
set xlabel "Frequency [MHz]"
set xrange [1:30]
set yrange [-100:128]
plot \
  'rxIQ.dat' i 0 u ($1):2 t "AG5GX B"        w lp lt 1 pt 5 lc 1, \
  'rxIQ.dat' i 0 u ($1):3 t "      P"        w lp lt 1 pt 4 lc 1, \
  'rxIQ.dat' i 1 u ($1):4 t "PA3CCE 1"       w lp lt 1 pt 5 lc 2, \
  'rxIQ.dat' i 1 u ($1):5 t ""               w lp lt 1 pt 4 lc 2, \
  'rxIQ.dat' i 2 u ($1):5 t "DD4WH 1"        w lp lt 1 pt 5 lc 3, \
  'rxIQ.dat' i 2 u ($1):6 t ""               w lp lt 1 pt 4 lc 3, \
  'rxIQ.dat' i 3 u ($1):5 t "DD4WH 2"        w lp lt 1 pt 5 lc 4, \
  'rxIQ.dat' i 3 u ($1):6 t ""               w lp lt 1 pt 4 lc 4, \
  'rxIQ.dat' i 4 u ($1):2 t "PA3CCE 2"       w lp lt 1 pt 5 lc 5, \
  'rxIQ.dat' i 4 u ($1):3 t ""               w lp lt 1 pt 4 lc 5

