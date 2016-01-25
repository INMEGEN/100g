#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    realineador.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./realineador.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi


WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
	pwd
	if [ -f aln_realigned.bai ]
	then
		echo ya se ha procesado
	else
		java -jar $PICARDdir/MarkDuplicates.jar I=aln_final_picard.bam O=aln_sorted_markedDuplicates.bam METRICS_FILE=aln_metrics_file_picard.txt
		java -jar $PICARDdir/BuildBamIndex.jar INPUT=aln_sorted_markedDuplicates.bam
		java -jar $GATKdir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $REF/hg19.fa -I aln_sorted_markedDuplicates.bam -o aln_final_picard.intervals -nt $2 -known $VARIANTS/1000G_phase1.indels.hg19.sites.vcf
		java -jar $GATKdir/GenomeAnalysisTK.jar -T IndelRealigner -R $REF/hg19.fa -I aln_sorted_markedDuplicates.bam -targetIntervals aln_final_picard.intervals -known $VARIANTS/1000G_phase1.indels.hg19.sites.vcf -o aln_realigned.bam
	fi
        cd ..
done
