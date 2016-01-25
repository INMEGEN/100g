#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    individualizadorVar.sh <DIR>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
ejemplo:
    ./individualizadorVar.sh /home/user/proyecto/datosIntermedios"
        exit
fi


WORKdir=$1
export PATH=$PATH:/home/inmegen/r.garcia/src/vcftools_0.1.12b/bin

cd $WORKdir


for sample in $(grep ^#CHROM filtered_output.vcf | cut -f10-)
do
	echo Procesando $sample

	if [ -d "$sample" ]
	then
		echo Existe directorio $sample
		cd $sample
		vcf-subset -c $sample -e ../filtered_output.vcf > filtered.vcf
		cd ..
	else
		echo Creando directorio $sample
		mkdir $sample
		cd $sample
		vcf-subset -c $sample -e ../filtered_output.vcf > filtered.vcf
		cd ..
	fi
	
done


