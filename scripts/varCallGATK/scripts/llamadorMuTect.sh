#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    llamadorMutect.sh <DIR> <Xmx> <bedfile> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
          <Xmx>: parametro para modificar el heap memory de Java,
                 se sugiere usar Xmx4g
      <bedfile>: archivo BED con las regiones del panel de 
                 enriquecimiento utilizado en la corrida
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./llamadorMutect.sh /home/user/proyecto/datosIntermedios Xmx4g /home/user/regiones.bed 4"
        exit
fi


WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f raw.vcf ]
	then
		echo ya se ha procesado
	else
#	java -$2 -jar $GATKdir/GenomeAnalysisTK.jar -T HaplotypeCaller -R $REF/hg19.fa -nct $4 --minPruning 5 -L $3 -I aln_recaled2.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -o raw.vcf
		java -$2 -jar $GATKdir/mutect-1.1.7.jar --analysis_type MuTect --reference_sequence $REF/hg19.fa --dbsnp $VAR/dbsnp_138.hg19.vcf --cosmic $CANCER/b37_cosmic_v54_120711_chr.vcf --intervals $3 --input_file:tumor aln_recaled2.bam --out call_stats.txt --coverage_file wig_coverage.txt -vcf raw.vcf
	fi
	cd ..
done 

