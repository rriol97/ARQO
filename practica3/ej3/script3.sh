#!/bin/bash

#inicilizar variables
Ninicio=256
Npaso=16
Nfinal=$((Ninicio + 256))
Nreps=3
fDAT=mult.dat
fPNG1=mult_cache.png
fPNG2=mult_time.png

# borrar el fichero DAT y el fichero png
rm -f *.dat *.png

# generar el fichero DAT vacío
touch $fDAT

echo "Ejecutando el script..."

for ((i = 1; i <= Nreps; i++)); do
  echo "->Repeticion $i/$Nreps"
  for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do
    echo "N: $N / $Nfinal..."
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
sed -i 's/,//g' $fDAT

awk -v ini=$Ninicio -v fin=$Nfinal -v paso=$Npaso -v reps=$Nreps '
{
	acum_time_normal[$1] += $2;
  acum_miss_read_normal+=$3;
  acum_miss_write_normal+=$4;
	acum_time_tras+=$5;
  acum_miss_read_tras+=$6;
  acum_miss_write_tras+=$7;
}
END {
	for (x = ini; x <= fin; x += paso) {
		print x"\t"acum_time_normal[x]/reps"\t"acum_miss_read_normal[x]/reps"\t"acum_miss_write_normal[x]/reps"\t"acum_time_tras[x]/reps"\t"acum_miss_read_tras[x]/reps"\t"acum_miss_write_tras[x]/reps;
	}
}' $fDAT >> mult_media.dat
