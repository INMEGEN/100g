#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    copiaAprevios.sh <IN> <OUT>
donde:
           <IN>: direccion del directorio donde se encuentran
                 las muestras a analizar
          <OUT>: direccion del directorio donde se encuentran 
                 los directorios de muestras guardar
ejemplo:
    ./copiaAprevios.sh /home/user/proyecto/datosIntermedios"
        exit
fi

WORKdir=$1
PREVdir=$2
cd $WORKdir


for h in $(ls); do
	if [ -d $PREVdir/$h ]; 
	then
		if [ -f $PREVdir/$h/filtered_final.vcf ];
		then
			echo ya existe la muestra $h se reescriben los resultados
			mv $PREVdir/$h/filtered_final.vcf $PREVdir/$h/previo_a_$3_.vcf
		else
			echo no existe la muestra $h se copian los resultados
		fi
		cp $h/filtered_final.vcf $PREVdir/$h
	else
		echo no existe la muestra $h se copian los resultados
		mkdir $PREVdir/$h
		cp $h/filtered_final.vcf $PREVdir/$h
	fi
done 
