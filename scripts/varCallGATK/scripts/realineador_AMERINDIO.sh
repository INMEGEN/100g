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
		inputAm=${h:7}
#		java -jar $PICARDdir/MarkDuplicates.jar I=aln_final_picard.bam O=aln_sorted_markedDuplicates.bam METRICS_FILE=aln_metrics_file_picard.txt
#		java -jar $PICARDdir/BuildBamIndex.jar INPUT=aln_sorted_markedDuplicates.bam
		java -jar $GATKdir/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $REF/human_g1k_v37_decoy.fasta -L 1 -L 2 -L 3 -L 4 -L 5 -L 6 -L 7 -L 8 -L 9 -L 10 -L 11 -L 12 -L 13 -L 14 -L 15 -L 16 -L 17 -L 18 -L 19 -L 20 -L 21 -L 22 -L X -L Y -L MT -I ${inputAm}.final.bam -o aln_final_picard.intervals -nt $2 -known $VARIANTS/1000G_phase1.indels.b37.vcf
		java -jar $GATKdir/GenomeAnalysisTK.jar -T IndelRealigner -R $REF/human_g1k_v37_decoy.fasta -L 1 -L 2 -L 3 -L 4 -L 5 -L 6 -L 7 -L 8 -L 9 -L 10 -L 11 -L 12 -L 13 -L 14 -L 15 -L 16 -L 17 -L 18 -L 19 -L 20 -L 21 -L 22 -L X -L Y -L MT -I ${inputAm}.final.bam -targetIntervals aln_final_picard.intervals -known $VARIANTS/1000G_phase1.indels.b37.vcf -o aln_realigned.bam
	fi
        cd ..
done
