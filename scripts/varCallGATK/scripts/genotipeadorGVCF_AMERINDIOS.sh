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

orden="java -Xmx60g -jar $GATKdir/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF/human_g1k_v37_decoy.fasta -nt $2 -L $3"
for h in $(ls output*vcf); do
	orden="$orden --variant $h"
done
orden="$orden -o final_output.vcf --disable_auto_index_creation_and_locking_when_reading_rods"
#orden="$orden -o final_output.vcf"
echo $orden
$orden


