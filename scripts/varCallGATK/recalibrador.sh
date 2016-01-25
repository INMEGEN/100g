#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    recalibrador.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./recalibrador.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f aln_recaled2.bai ];
	then
		echo ya se ha procesado
	else 
		java -jar $GATKdir/GenomeAnalysisTK.jar -T BaseRecalibrator -R $REF/human_g1k_v37_decoy.fasta -I aln_realigned.bam -knownSites $VARIANTS/1000G_phase1.snps.high_confidence.b37.vcf -nct $2 -o aln_hg19_GATK_recaltable1
		java -jar $GATKdir/GenomeAnalysisTK.jar -T PrintReads -R $REF/human_g1k_v37_decoy.fasta -I aln_realigned.bam -BQSR aln_hg19_GATK_recaltable1 -nct $2 -o aln_recaled1.bam
		java -jar $GATKdir/GenomeAnalysisTK.jar -T BaseRecalibrator -R $REF/human_g1k_v37_decoy.fasta -I aln_recaled1.bam -knownSites $VARIANTS/1000G_phase1.snps.high_confidence.b37.vcf -nct $2 -o aln_hg19_GATK_recaltable2
		java -jar $GATKdir/GenomeAnalysisTK.jar -T PrintReads -R $REF/human_g1k_v37_decoy.fasta -I aln_recaled1.bam -BQSR aln_hg19_GATK_recaltable2 -nct $2 -o aln_recaled2.bam
	fi
        cd ..
done 

