#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    llamadorHC_gvcf.sh <DIR> <Xmx> <bedfile> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
          <Xmx>: parametro para modificar el heap memory de Java,
                 se sugiere usar Xmx4g
      <bedfile>: archivo BED con las regiones del panel de 
                 enriquecimiento utilizado en la corrida
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./llamadorHC_gvcf.sh /home/user/proyecto/datosIntermedios Xmx4g /home/user/regiones.bed 4"
        exit
fi


WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f raw.vcf.idx ];
	then
		echo ya se ha procesado
	else
#		java -$2 -jar $GATKdir/GenomeAnalysisTK.jar -T HaplotypeCaller -R $REF/hg19.fa -nct $4 --minPruning 3 -L $3 -I aln_recaled2.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -o raw.vcf
		java -$2 -jar $GATKdir/GenomeAnalysisTK.jar -T HaplotypeCaller -R $REF/human_g1k_v37_decoy.fasta -nct $4 --minPruning 3 -I aln_recaled2.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 -o raw.vcf
	fi
	cd ..
done 

