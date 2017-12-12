#!/bin/bash

#borramos el ficher DAT y los ficheros png
rm -f *.dat *.png

res1=$(./pi_par3 1 |tail -n 1|awk '{print $2}')
res2=$(./pi_par3 2 |tail -n 1|awk '{print $2}')
res4=$(./pi_par3 4 |tail -n 1|awk '{print $2}')
res6=$(./pi_par3 6 |tail -n 1|awk '{print $2}')
res7=$(./pi_par3 7 |tail -n 1|awk '{print $2}')
res8=$(./pi_par3 8 |tail -n 1|awk '{print $2}')
res9=$(./pi_par3 9 |tail -n 1|awk '{print $2}')
res10=$(./pi_par3 10 |tail -n 1|awk '{print $2}')
res12=$(./pi_par3 12 |tail -n 1|awk '{print $2}')

echo -e "1 $res1\n2 $res2\n4 $res4\n6 $res6\n7 $res7\n8 $res8\n9 $res9\n10 $res10\n12 $res12" >> ejercicio4_5.dat

gnuplot << END_GNUPLOT
	set title "Resultados ejercicio 4.5 sobre piPar3.c"
	set ylabel "Tiempo ejecucion (s)"
	set xlabel "Padding"
	set key right bottom
	set grid
	set term png
	set output "ej4.png"
	plot "ejercicio4_5.dat" using 1:2 with lines lw 2 title "tiempo ejecucion"
	replot
	quit
END_GNUPLOT