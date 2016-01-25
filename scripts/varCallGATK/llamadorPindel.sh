#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    llamadorPindel.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./llamadorPindel.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi


WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f output_indel.vcf ]
	then
		echo ya se ha procesado
	else
		echo "aln_recaled2.bam   200   $h" > config_pindel.txt
		pindel -f $REF/hg19.fa -i config_pindel.txt -c ALL -o pindel_out -T $2
		pindel2vcf -P pindel_out -r $REF/hg19.fa -R hg19 -d 20101123 -G -v pindel.vcf
		cat pindel.vcf | perl $perlDIR/calculaAlleleFreq.pl -p | awk '$6 > 0.05 {print}' | awk '$6 < 0.9 {print}' | awk '$6 > 0.6 || $6 < 0.4 {print}' | awk '$4 + $5 > 100 {print}' | perl $perlDIR/filtraPindel2vcf.pl -p pindel.vcf > filtered_pindel.vcf
		java -jar $GATKdir/GenomeAnalysisTK.jar -T SelectVariants -R $REF/hg19.fa -V filtered_pindel.vcf -selectType INDEL -o output_indel.vcf -nt $2
	fi
	cd ..
done 

