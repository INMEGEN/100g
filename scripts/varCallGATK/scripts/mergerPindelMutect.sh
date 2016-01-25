#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    mergerPindelMutect.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./mergerPindelMutect.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi


WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f filtered_final.vcf ]
	then
		echo ya se ha procesado
	else
		java -jar $GATKdir/GenomeAnalysisTK.jar -T CombineVariants -R $REF/hg19.fa -V raw.vcf -V filtered_pindel.vcf -o filtered_output.vcf -nt $2 --genotypemergeoption UNSORTED
		grep -v REJECT filtered_output.vcf > filtered_both.vcf
#	vcf-subset -c $h -e filtered_both.vcf > filtered_final.vcf
		vcf-subset -c $h filtered_both.vcf > filtered_final.vcf
	fi
	cd ..
done 

