#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    copiaAprevios.sh <IN> <OUT> <file>
donde:
           <IN>: direccion del directorio donde se encuentran
                 las muestras a analizar
          <OUT>: direccion del directorio donde se encuentran 
                 los directorios de muestras guardar
         <file>: nombre comun de los archivos que se desean
                 copiar
ejemplo:
    ./copiaAprevios.sh /home/user/proyecto/datosIntermedios /home/user/otro/directorio file.txt"
        exit
fi

WORKdir=$1
PREVdir=$2
cd $WORKdir


for h in $(ls); do
	if [ -d $PREVdir/$h ]; 
	then
		if [ -f $PREVdir/$h/$3 ];
		then
			echo ya existe la muestra $h se reescriben los resultados
			mv $PREVdir/$h/$3 $PREVdir/$h/prev_$3
		else
			echo no existe la muestra $h se copian los resultados
		fi
		cp $h/$3 $PREVdir/$h
	else
		echo no existe la muestra $h se copian los resultados
		mkdir $PREVdir/$h
		cp $h/$3 $PREVdir/$h
	fi
done

