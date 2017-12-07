#!/bin/bash

Tam=100
fDAT1=ejecucion.dat
fDAT2=aceleracion.dat

#borramos el ficher DAT y los ficheros png antiguos
rm -f $fDAT1 $fDAT2

for ((i= 1; i <= 4; i++)); do
	serie=$(./multiplicador_matrices $Tam)
	par1=$(./multiplicador_matrices_1 $Tam $i)
	par2=$(./multiplicador_matrices_2 $Tam $i)
	par3=$(./multiplicador_matrices_3 $Tam $i)

	echo "$i $serie $par1 $par2 $par3" >> $fDAT1

	acserie=$(echo $serie/$serie | bc -l)
	acpar1=$(echo $serie/$par1 | bc -l)
	acpar2=$(echo $serie/$par2 | bc -l)
	acpar3=$(echo $serie/$par3 | bc -l)

	echo "  $acserie $acpar1 $acpar2 $acpar3" >> $fDAT2
done