#!/bin/bash

# inicializar variables
Ninicio=10000
Npaso=64
Nfinal=$((Ninicio + 1024))
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
Nreps=10

# borrar el fichero DAT y el fichero PNG
rm -f *.dat *.png

# generar el fichero DAT vacío
touch $fDAT

echo "Ejecutando el script..."
# bucle para N desde P hasta Q 
#for N in $(seq $Ninicio $Npaso $Nfinal);
for ((i = 1; i <= Nreps; i++)); do
	echo "->Repeticion $i/$Nreps"
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal..."
	
		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')

		echo "$N	$slowTime	$fastTime" >> $fDAT
	done
done

awk -v ini=$Ninicio -v fin=$Nfinal -v paso=$Npaso -v reps=$Nreps '
{
	acum_slow[$1] += $2;
	acum_fast[$1] += $3; 
}
END {
	for (x = ini; x <= fin; x += paso) {
		print x"\t"acum_slow[x]/reps"\t"acum_fast[x]/reps; 
	}
}' $fDAT >> slow_fast_media.dat

./genera_grafica.sh $fDAT SlowFastTiempoEjecucion TiempoEjecucion_s TamanyoMatriz timeSlowFast.png
./genera_grafica.sh slow_fast_media.dat TiemposMedia TiempoEjecucion_s TamanyoMatriz timeSlowFastMedia.png