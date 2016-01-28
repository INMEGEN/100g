#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    indexador_GVCF_AMERINDIOS.sh <DIR> <OutDir>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
       <OutDir>: directorio donde se depositaran los logs
ejemplo:
    indexador_GVCF_AMERINDIOS.sh /home/user/proyecto/datosIntermedios /home/user/output 4"
        exit
fi

WORKdir=$1

cd $2

#orden="java -Xmx16g -jar $GATKdir/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF/human_g1k_v37_decoy.fasta -nt $3"
for h in $(find $WORKdir -name "raw.vcf"); do
	if [ -f "${h}.idx" ]
	then
		echo "$h ya se tiene indice"
	else
		echo $IGVdir/igvtools index $h
#		bsub -q medium -e %J.err -o %J.o "$IGVdir/igvtools index $h"
	fi
done

