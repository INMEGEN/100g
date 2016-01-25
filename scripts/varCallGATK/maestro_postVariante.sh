#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    maestro_postVariante.sh <DIR> <nt> <dist> <genoma>
donde:
          <DIR>: Ruta del directorio donde se encuentra 
                 el archivo de variantes output.vcf
           <nt>: Cantidad de nucleos a utilizar
         <dist>: Distancia de correccion de fase
       <genoma>: Genoma de anotacion para utilizar
ejemplo:
    ./maestro_postVariante.sh /home/user/datosIntermedios 6 4 hg19"
        exit
fi

date

echo INICIO: filtro de variantes
./filtraVariantes_HF.sh $1 $2
echo INICIO: individualizacion
./individualizadorVar.sh $1
echo INICIO: corrector de fase
./correctorDEfase.sh $1 $3
echo INICIO: anotacion

for i in $(ls $1)
do
	if [ -d "$1/$i" ]
	then
		./anotador_snpEff_v2.sh $1/$i $4
		./anotador_canon_snpEff.sh $1/$i $4
	fi
done
date

