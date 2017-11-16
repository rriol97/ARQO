#!/bin/bash

# inicializacion de variables
Ninicio=2000
Npaso=64
Nfinal=$((Ninicio + 1024))
Ncache1=1024
factor=2
CacheMega=8e+06;
tam_linea=64;
Nreps=5

# borrar el fichero DAT y el fichero PNG
rm -f *.dat *.png

echo "Ejecutando el script..."
for ((i = 1; i<=Nreps; i++)); do
	echo "->>Repeticion $i/$Nreps"
	for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
		echo "N: $N / $Nfinal..."
		valgrind --tool=cachegrind --cachegrind-out-file=cacheSlow.dat ./slow > salida1.txt
		valgrind --tool=cachegrind --cachegrind-out-file=cacheFast.dat ./fast > salida2.txt
		slow_miss=$(head -n 18 cacheSlow.dat | tail -n 1 | awk '{print $4}')
		fast_miss=$(head -n 18 cacheFast.dat | tail -n 1 | awk '{print $4}')
		echo "$N	$slow_miss	$fast_miss" >> slowFastMisses.dat
	done
done