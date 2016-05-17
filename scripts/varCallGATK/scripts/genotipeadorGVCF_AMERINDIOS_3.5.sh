#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    genotipeadorGVCF_AMERINDIOS.sh <DIR> <OutDir><nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras combinadas
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./genotipeadorGVCF_AMERINDIOS.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

cd $1

orden="java -Xmx40g -jar $GATK35dir/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF/human_g1k_v37_decoy.fasta -nt $2"
for h in $(ls output*split_${3}.vcf); do
	orden="$orden --variant $h"
	if [ -e ${h}.idx ]
	then
  	        echo El indice ${h}.idx ya existe, se omite su creacion
		
	else
                echo $IGVdir/igvtools index $h
                $IGVdir/igvtools index $h
	fi
done
orden="$orden -o final_${3}_output.vcf --disable_auto_index_creation_and_locking_when_reading_rods"
#orden="$orden -o final_${3}_output.vcf"
echo $orden
$orden
