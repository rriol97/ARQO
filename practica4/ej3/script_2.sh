#!/bin/bash

TamIni=512+5
TamPaso=128
TamFin=1541 #1024+512+5 = 1541

NHilos=2 #ver
Nreps=2
fDAT=tiempos.dat

fPNG1=tiempos.png
fPNG2=aceleracion.png

# generar el fichero DAT vacío
touch $fDAT

for ((i = 1; i <= Nreps; i++)); do
	echo "->Repeticion $i/$Nreps"
	#bucle para variar el numero de hilos
	serieBase=$(./multiplicador_matrices TamIni)
	for ((k = TamIni; k <= TamFin; k += TamPaso)); do
		echo "-> Tamanio $k/$TamFin"
		serie=$(./multiplicador_matrices $k)
		par3=$(./multiplicador_matrices_3 $k $NHilos)
		acel_serie=$(echo $serieBase/$serie | bc -l)
		acel_par=$(echo $serie/$par3 | bc -l)
		echo "$k $serie $par3 $acel_serie $acel_par" >> $fDAT
	done
done	

awk -v ini=$TamIni -v fin=$TamFin -v paso=$TamPaso -v reps=$Nreps '
{
	acum_serie[$1] += $2;
	acum_par3[$1] += $3;
	acum_acel_serie[$1] += $4;
	acum_acel_par[$1] += $5;
}
END {
	for (x = ini; x <= fin; x += paso) {
		print x" "acum_serie[x]/reps" "acum_par3[x]/reps" "acum_acel_serie[x]" "acum_acel_par[x];
	}
}' $fDAT >> tiempos_media.dat

gnuplot << END_GNUPLOT
	set title "Tiempos de ejecucion"
	set ylabel "Tiempo (s)"
	set xlabel "Tamanio"
	set key right bottom
	set grid
	set term png
	set output "fPNG1"
	plot "tiempos_media.dat" using 1:2 lines lw 2 title "tiempo ejecucion en serie", \
		 "tiempos_media.dat" using 1:3 lines lw 2 title "tiempo ejecucion en paralelo"
	replot
	quit
END_GNUPLOT	

gnuplot << END_GNUPLOT
	set title "Aceleracion en funcion del tamanio de matriz"
	set ylabel "Aceleracion"
	set xlabel "Tamanio"
	set key right bottom
	set grid
	set term png
	set output "fPNG2"
	plot "tiempos_media.dat" using 1:4 lines lw 2 title "aceleracion en serie", \
		 "tiempos_media.dat" using 1:5 lines lw 2 title "aceleracion en paralelo"
	replot
	quit
END_GNUPLOT	