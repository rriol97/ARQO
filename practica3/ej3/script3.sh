#!/bin/bash

#inicilizar variables
Ninicio=256
Npaso=16
Nfinal=$((Ninicio + 256))
Nreps=20
fDAT=mult.dat
fPNG1=mult_cache.png
fPNG2=mult_time.png

# borrar el fichero DAT y el fichero png
rm -f *.dat *.png

# generar el fichero DAT vacío
touch $fDAT

echo "Ejecutando el script..."
# bucle que ejecuta el numero indicado de repeticiones
for ((i = 1; i <= Nreps; i++)); do
	echo "->Repeticion $i/$Nreps"
	# bucle que hace variar la dimension de la matriz
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal... [$i]"
		normalTime=$(./MultiplicarMatrices $N | awk '{print $1}')
		trasTime=$(./MultiplicarMatricesTraspuesta $N | awk '{print $1}')
		
		valgrind --quiet --tool=cachegrind --cachegrind-out-file=mult_normal.dat ./MultiplicarMatrices $N
		valgrind --quiet --tool=cachegrind --cachegrind-out-file=mult_tras.dat ./MultiplicarMatricesTraspuesta $N
		normal_miss_d1mr=$(cg_annotate mult_normal.dat | head -n 18 | tail -n 1 | awk '{print $5}')
		normal_miss_d1mw=$(cg_annotate mult_normal.dat | head -n 18 | tail -n 1 | awk '{print $8}')
		tras_miss_d1mr=$(cg_annotate mult_tras.dat | head -n 18 | tail -n 1 | awk '{print $5}')
		tras_miss_d1mw=$(cg_annotate mult_tras.dat | head -n 18 | tail -n 1 | awk '{print $8}')

		echo "$N	$normalTime $normal_miss_d1mr $normal_miss_d1mw	$trasTime $tras_miss_d1mr $tras_miss_d1mw" >> $fDAT
		rm -f mult_normal.dat
		rm -f mult_tras.dat
	done
done
# sustitucion de comas por espacion en los ficheros para que sean compatibles con gnuplot
sed -i 's/,//g' "$fDAT"

# calculo de medias
awk -v ini=$Ninicio -v fin=$Nfinal -v paso=$Npaso -v reps=$Nreps '
{
	acum_time_normal[$1] += $2;
	acum_miss_read_normal[$1] += $3;
	acum_miss_write_normal[$1] += $4;
	acum_time_tras[$1] += $5;
	acum_miss_read_tras[$1] += $6;
	acum_miss_write_tras[$1] += $7;
}
END {
	for (x = ini; x <= fin; x += paso) {
		print x"\t"acum_time_normal[x]/reps"\t"acum_miss_read_normal[x]/reps"\t"acum_miss_write_normal[x]/reps"\t"acum_time_tras[x]/reps"\t"acum_miss_read_tras[x]/reps"\t"acum_miss_write_tras[x]/reps;
	}
}' $fDAT >> mult_media.dat

# representacion de los fallos de cache
gnuplot << END_GNUPLOT
	set title "Cache Multiplicaciones"
	set ylabel "Numero fallos"
	set xlabel "Tamano matriz"
	set logscale y
	set key right bottom
	set grid
	set term png
	set output "mult_cache.png"
	plot "mult_media.dat" using 1:3 with lines lw 2 title "lectura_normal", \
		 "mult_media.dat" using 1:4 with lines lw 2 title "escritura_normal", \
		 "mult_media.dat" using 1:6 with lines lw 2 title "lectura_traspuesta", \
		 "mult_media.dat" using 1:7 with lines lw 2 title "escritura_traspuesta"
	replot
	quit
END_GNUPLOT

# representacion de los tiempos de ejecucion
gnuplot << END_GNUPLOT
	set title "Tiempos Multiplicaciones"
	set ylabel "Tiempo de ejecucion (s)"
	set xlabel "Tamano matriz"
	set key right bottom
	set grid
	set term png
	set output "mult_time.png"
	plot "mult_media.dat" using 1:2 with lines lw 2 title "normal", \
		 "mult_media.dat" using 1:5 with lines lw 2 title "traspuesta"
	replot
	quit
END_GNUPLOT