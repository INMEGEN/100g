#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    mergerPrevios.sh <IN> <PRE>
donde:
           <IN>: direccion del directorio donde se encuentran
                 las muestras a analizar
          <PRE>: direccion del directorio donde se encuentran 
                 los directorios de muestras a combinar
ejemplo:
    ./mergerPrevios.sh /home/user/proyecto/datosIntermedios"
        exit
fi

WORKdir=$1
PREVdir=$2
cd $WORKdir


for h in $(ls); do
	if [ -d $PREVdir/$h ]; 
	then
		echo ya existe la muestra $h, se agregan dichas lecturas
		cd $h
		mv aln_final_picard.bam tmp_${h}_.bam
		java -jar $PICARDdir/MergeSamFiles.jar INPUT=$PREVdir/$h/aln_final_picard.bam INPUT=tmp_${h}_.bam OUTPUT=aln_final_picard.bam
		rm $PREVdir/$h/aln_final_picard.bam
		cp aln_final_picard.bam $PREVdir/$h
		cd ..
	else
		echo no existe la muestra $h
		mkdir $PREVdir/$h
		cp $h/aln_final_picard.bam $PREVdir/$h
	fi
done 
