#!/bin/bash

#inicializar variables
TamIni=50000000
TamPaso=95000000
TamFin=1760000000
Nreps=5
fDAT=pescalar_tiempos.dat
fPNG1=pescalar_time.png
fPNG2=pescalar_aceleration.png

#borramos el ficher DAT y los ficheros png
rm -f *.dat *.png

# generar el fichero DAT vacío
touch $fDAT

#bucle para tener varias muestras y luego poder hacer la media
for ((i = 1; i <= Nreps; i++)); do
	echo "->Repeticion $i/$Nreps"
	#bucle para variar el numero de hilos
	for ((j = 1; j <= 4; j++)); do
		echo "->num_hilos $j/4"
		for ((k = TamIni; k <= TamFin; k += TamPaso))
			echo "-> Tamanio $k/TamFin"
			time_serie=$(./pescalar_serie $j $k |tail -n 1|awk '{print $2}')
			time_par2=$(./pescalar_par2 $j $k |tail -n 1|awk '{print $2}')
			echo "$j $k $time_serie $time_par2" >> $fDAT
		done
	done	
done	


# calculo de medias
awk -v ini=$TamIni -v fin=$TamFin -v paso=$TamPaso -v reps=$Nreps '
{
	acum_time_serie[$1,$2] += $3;
	acum_time_par[$1,$2] += $4;
}
END {
	for (i = 1; i <= 4; i++){
		for (x = ini; x <= fin; x += paso) {
			print "i\tx\t"acum_time_serie[i,x]/reps"\t"acum_time_par[i,x]/reps
		}
	}	
}' $fDAT >> pescalar_media.dat

pescalar_media.dat |head -n 10 > pescalar_media_1hilo.dat
pescalar_media.dat |head -n 20 |tail -n 10 > pescalar_media_2hilos.dat
pescalar_media.dat |head -n 30 |tail -n 10 > pescalar_media_3hilos.dat
pescalar_media.dat |tail -n 10 > pescalar_media_4hilos.dat

#grafica de tiempos
gnuplot << END_GNUPLOT
	set title "Timpos de ejecucion"
	set ylabel "tiempo"
	set xlabel "tamanio"
	set key right bottom
	set grid
	set term png
	set output "fPNG1"
	plot "pescalar_media_1hilo.dat" using 2:3 with lines lw 2 title "1 hilo serie", /
		 "pescalar_media_1hilo.dat" using 2:4 with lines lw 2 title "1 hilo par", /
		 "pescalar_media_2hilos.dat" using 2:3 with lines lw 2 title "2 hilos serie", /
		 "pescalar_media_2hilos.dat" using 2:4 with lines lw 2 title "2 hilos par", /
		 "pescalar_media_3hilos.dat" using 2:3 with lines lw 2 title "3 hilos serie", /
		 "pescalar_media_3hilos.dat" using 2:4 with lines lw 2 title "3 hilos par", /
		 "pescalar_media_4hilos.dat" using 2:3 with lines lw 2 title "4 hilos serie", /
		 "pescalar_media_4hilos.dat" using 2:4 with lines lw 2 title "4 hilos par"
	replot
	quit
END_GNUPLOT	

awk -v ini=$TamIni -v fin=$TamFin -v paso=$TamPaso -v reps=$Nreps '
{
	acum_time_serie[$1,$2] += $3;
	acum_time_par[$1,$2] += $4;
}
END {
	for (i = 1; i <= 4; i++){
		for (x = ini; x <= fin; x += paso) {
			print "i\tx\t"acum_time_serie[i,x]/acum_time_par[i,x]
		}
	}	
}' pescalar_media.dat >> pescalar_aceleracion.dat

pescalar_aceleracion.dat |head -n 10 > pescalar_aceleracion_1hilo.dat
pescalar_aceleracion.dat |head -n 20 |tail -n 10 > pescalar_aceleracion_2hilos.dat
pescalar_aceleracion.dat |head -n 30 |tail -n 10 > pescalar_aceleracion_3hilos.dat
pescalar_aceleracion.dat |tail -n 10 > pescalar_aceleracion_4hilos.dat

#grafica de aceleracion
gnuplot << END_GNUPLOT
	set title "Aceleracion en funcion del tamanio del vector"
	set ylabel "Aceleracion"
	set xlabel "tamanio"
	set key right bottom
	set grid
	set term png
	set output "fPNG2"
	plot "pescalar_aceleracion_1hilo.dat" using 2:3 lines lw 2 title "aceleracion 1 hilo",/
		 "pescalar_aceleracion_2hilos.dat" using 2:3 lines lw 2 title "aceleracion 2 hilos",/
		 "pescalar_aceleracion_3hilos.dat" using 2:3 lines lw 2 title "aceleracion 3 hilos",/
		 "pescalar_aceleracion_4hilos.dat" using 2:3 lines lw 2 title "aceleracion 4 hilos"
	replot
	quit
END_GNUPLOT	