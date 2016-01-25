#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    filtraVariantes.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./filtraVariantes.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi


WORKdir=$1

cd $WORKdir

export PATH=$PATH:$TABIXdir

java -jar $GATKdir/GenomeAnalysisTK.jar -T SelectVariants -R $REF/hg19.fa -V output.vcf -selectType SNP -o output.snp.vcf -nt $2
java -jar $GATKdir/GenomeAnalysisTK.jar -T SelectVariants -R $REF/hg19.fa -V output.vcf	-selectType INDEL -o output.indel.vcf -nt $2

java -jar $GATKdir/GenomeAnalysisTK.jar -T VariantFiltration -R $REF/hg19.fa -V output.snp.vcf --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "my_filter" -o filtered_snp.vcf
java -jar $GATKdir/GenomeAnalysisTK.jar -T VariantFiltration -R $REF/hg19.fa -V output.indel.vcf --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" --filterName "my_filter" -o filtered_indel.vcf

java -jar $GATKdir/GenomeAnalysisTK.jar -T CombineVariants -R $REF/hg19.fa -V filtered_snp.vcf -V filtered_indel.vcf -o filtered_output.vcf -nt $2 --genotypemergeoption UNSORTED

