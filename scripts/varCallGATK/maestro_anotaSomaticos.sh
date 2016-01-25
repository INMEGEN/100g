#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    maestro_anotaSomaticos.sh <DIR> <genoma>
donde:
          <DIR>: Ruta del directorio donde se encuentra 
                 el archivo de variantes output.vcf
       <genoma>: Genoma de anotacion para utilizar
ejemplo:
    ./maestro_anotaSomaticos.sh /home/user/datosIntermedios hg19"
        exit
fi

date


echo INICIO: anotacion

for i in $(ls $1)
do
	if [ -d "$1/$i" ]
	then
		./anotador_snpEff_v3_som.sh $1/$i $2
		./anotador_canon_snpEff.sh $1/$i $2
	fi
done
date

