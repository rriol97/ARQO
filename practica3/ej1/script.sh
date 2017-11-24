#!/bin/bash

# inicializar variables
Ninicio=10000
Npaso=64
Nfinal=$((Ninicio + 1024))
fDAT=time_slow_fast.dat
fPNG=time_slow_fast.png
Nreps=20

# borrar el fichero DAT y el fichero PNG
rm -f *.dat *.png

# generar el fichero DAT vacío
touch $fDAT

echo "Ejecutando el script..."
# bucle que ejecuta el numero indicado de repeticiones
for ((i = 1; i <= Nreps; i++)); do
	echo "->Repeticion $i/$Nreps"
	# bucle que hace variar la dimension de la matriz
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

# calculo de medias
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

# representacion de los tiempos de ejecucion
./genera_grafica.sh slow_fast_media.dat TiemposMedia TiempoEjecucion_s TamanyoMatriz time_slow_fast.png