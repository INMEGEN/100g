#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    mapeador.sh <DIR> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
         <RGID>: Read Group ID, se sugiere utilizar el nombre del
                 experimento
         <RGLB>: Read Group Library, se sugiere utilizar el nombre
                 del kit de la libreria
         <RGPU>: Read Group Process Unit, se sugiere utilizar el
                 nombre del equipo utilizado para la secuenciacion
           <nt>: cantidad de nucleos a utilizar 
ejemplo:
    ./mapeador.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

WORKdir=$1

cd $WORKdir

for h in $(ls); do
	cd $h
#	echo ls
	bwa mem -M -t $5 $REF/hg19.fa p1.fastq.gz p2.fastq.gz >aln.sam
	bwa mem -M -t $5 $REF/hg19.fa u1.fastq.gz >alnu1.sam
	bwa mem -M -t $5 $REF/hg19.fa u2.fastq.gz >alnu2.sam

	samtools view -bS aln.sam > aln.bam
	samtools view -bS alnu1.sam > alnu1.bam
	samtools view -bS alnu2.sam > alnu2.bam

	java -jar $PICARDdir/SortSam.jar I=aln.bam O=aln_sorted.bam SO=coordinate
	java -jar $PICARDdir/SortSam.jar I=alnu1.bam O=alnu1_sorted.bam SO=coordinate
	java -jar $PICARDdir/SortSam.jar I=alnu2.bam O=alnu2_sorted.bam SO=coordinate

	java -jar $PICARDdir/MergeSamFiles.jar INPUT=aln_sorted.bam INPUT=alnu1_sorted.bam INPUT=alnu2_sorted.bam OUTPUT=merged_sorted.bam
	java -jar $PICARDdir/AddOrReplaceReadGroups.jar I=merged_sorted.bam O=aln_final_picard.bam RGID=$2 RGLB=$3 RGPL=illumina RGPU=${4}_${2} RGSM=$h CREATE_INDEX=true
        cd ..
done 

