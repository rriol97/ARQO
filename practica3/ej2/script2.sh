#!/bin/bash
rm -f *.dat

# inicializacion de variables
Ninicio=2000
Npaso=64
Nfinal=$((Ninicio + 1024))
Ncache1=1024
NcacheFinal1=8192
factor=2
CacheMega=8388608
TamLinea=64
Nvias=1

# borrar el fichero DAT y el fichero PNG
rm -f *.dat *.png
# bucle para cambiar el tamanyo de las caches
for ((K = Ncache1 ; K <= NcacheFinal1 ; K *= 2)); do
	echo "->>Tamanio $K/$NcacheFinal1"
	# bucle que hace variar la dimension de la matriz
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal..."
		valgrind --quiet --tool=cachegrind --I1=$K,$Nvias,$TamLinea --D1=$K,$Nvias,$TamLinea --LL=$CacheMega,$Nvias,$TamLinea --cachegrind-out-file=cacheSlow.dat ./slow $N
		valgrind --quiet --tool=cachegrind --I1=$K,$Nvias,$TamLinea --D1=$K,$Nvias,$TamLinea --LL=$CacheMega,$Nvias,$TamLinea --cachegrind-out-file=cacheFast.dat ./fast $N
		slow_miss_d1mr=$(cg_annotate cacheSlow.dat | head -n 18 | tail -n 1 | awk '{print $5}')
		slow_miss_d1mw=$(cg_annotate cacheSlow.dat | head -n 18 | tail -n 1 | awk '{print $8}')
		fast_miss_d1mr=$(cg_annotate cacheFast.dat | head -n 18 | tail -n 1 | awk '{print $5}')
		fast_miss_d1mw=$(cg_annotate cacheFast.dat | head -n 18 | tail -n 1 | awk '{print $8}')

		echo "$N $slow_miss_d1mr $slow_miss_d1mw $fast_miss_d1mr $fast_miss_d1mw" >> cache_$K.dat
		# sustitucion de comas por espacion en los ficheros para que sean compatibles con gnuplot
		sed -i 's/,//g' cache_$K.dat

		rm -f cacheSlow.dat
		rm -f cacheFast.dat
	done
done

# representacion de los fallos de cache en lectura
gnuplot << END_GNUPLOT
	set title "Misses lectura"
	set ylabel "Numero fallos"
	set xlabel "Tamano matriz"
	set key right bottom
	set grid
	set term png
	set output "cache_lectura.png"
	plot "cache_1024.dat" using 1:2 with lines lw 2 title "slow1024", \
	     "cache_1024.dat" using 1:4 with lines lw 2 title "fast1024", \
	     "cache_2048.dat" using 1:2 with lines lw 2 title "slow2048", \
	     "cache_2048.dat" using 1:4 with lines lw 2 title "fast2048", \
		 "cache_4096.dat" using 1:2 with lines lw 2 title "slow4096", \
		 "cache_4096.dat" using 1:4 with lines lw 2 title "fast4096", \
		 "cache_8192.dat" using 1:2 with lines lw 2 title "slow8192", \
		 "cache_8192.dat" using 1:4 with lines lw 2 title "fast8192"
	replot
	quit
END_GNUPLOT
ç
# representacion de los fallos de cache en escritura
gnuplot << END_GNUPLOT
	set title "Misses escritura"
	set ylabel "Numero fallos"
	set xlabel "Tamano matriz"
	set key right bottom
	set grid
	set term png
	set output "cache_escritura.png"
	plot "cache_1024.dat" using 1:3 with lines lw 2 title "slow1024", \
	     "cache_1024.dat" using 1:5 with lines lw 2 title "fast1024", \
	     "cache_2048.dat" using 1:3 with lines lw 2 title "slow2048", \
	     "cache_2048.dat" using 1:5 with lines lw 2 title "fast2048", \
		 "cache_4096.dat" using 1:3 with lines lw 2 title "slow4096", \
		 "cache_4096.dat" using 1:5 with lines lw 2 title "fast4096", \
		 "cache_8192.dat" using 1:3 with lines lw 2 title "slow8192", \
		 "cache_8192.dat" using 1:5 with lines lw 2 title "fast8192"
	replot
	quit
END_GNUPLOT
