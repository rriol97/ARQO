echo -e "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
#gnuplot argumentos <fichero.txt> <titulo> <ylabel> <xlabel> <nombre_grafica> 
gnuplot << END_GNUPLOT
set title "$2"
set ylabel "$3"
set xlabel "$4"
set key right bottom
set grid
set term png
set output "$5"
plot "$1" using 1:2 with lines lw 2 title "slow", \
     "$1" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
echo "[OK]"