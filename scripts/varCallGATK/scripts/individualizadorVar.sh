#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    individualizadorVar.sh <DIR>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
	  <OUT-DIR> direccion del directorio de salida
ejemplo:
    ./individualizadorVar.sh /home/user/proyecto/datosIntermedios /home/user/proyecto/Resultados"
        exit
fi


WORKdir=$1
export PATH=$PATH:/home/inmegen/r.garcia/src/vcftools_0.1.12b/bin

cd $WORKdir


for sample in $(grep -m 1 "^#CHROM" allsamples_final_recaled_snp-indel.vcf | cut -f10-)
do
	echo Procesando $sample

	if [ -d "$2/$sample" ]
	then
		echo Existe directorio $sample
		cd $2/$sample
		if [ -f $2/$sample/${sample}_GATK_PASS-snp-indel.vcf ]
		then
			echo "Ya se han obtenido las variantes de la $sample"
		else
			vcf-subset -c $sample -e $WORKdir/allsamples_final_recaled_snp-indel.vcf | grep -E "^#|PASS" > ${sample}_GATK_PASS-snp-indel.vcf
		fi
		cd $WORKdir
	else
		echo Creando directorio $sample
		mkdir $2/$sample
		cd $2/$sample
		vcf-subset -c $sample -e $WORKdir/allsamples_final_recaled_snp-indel.vcf | grep -E "^#|PASS" > ${sample}_GATK_PASS-snp-indel.vcf
		cd $WORKdir
	fi
	
done

