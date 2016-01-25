#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    genotipeadorGVCF.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./genotipeadorGVCF.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

WORKdir=$1

cd $WORKdir
orden="java -Xmx2g -jar $GATKdir/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF/hg19.fa -nt $2"
for h in $(ls); do
	orden="$orden --variant $h/raw.vcf"
done
orden="$orden -o output.vcf"
echo $orden
$orden
 
