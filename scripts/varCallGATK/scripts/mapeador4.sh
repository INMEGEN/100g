#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    mapeador2.sh <DIR> <nt> <RGID> <RGLB> <RGPU>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
           <nt>: cantidad de nucleos a utilizar 
         <RGID>: Read Group ID, se sugiere utilizar el nombre del
                 experimento
         <RGLB>: Read Group Library, se sugiere utilizar el nombre
                 del kit de la libreria
         <RGPU>: Read Group Process Unit, se sugiere utilizar el
                 nombre del equipo utilizado para la secuenciacion

ejemplo:
    ./mapeador.sh /home/user/proyecto/datosIntermedios 4 corrida1 panelX M03540"
        exit
fi

WORKdir=$1

cd $WORKdir

mergeOrden="java -jar $PICARDdir/MergeSamFiles.jar "
for i in $(ls *sam); do
#	cd $h
	pwd
	if [ -f aln_sorted_markedDuplicates.final.bam ];
	then
		echo ya se ha procesado
	else
#		lane=`echo $h | rev | cut -d '_' -f1 | rev`
#		sample=`echo $h | cut -d '_' -f-2`
#		bwa mem -M -t $2 $REF/hg19.fa p1.fastq.gz p2.fastq.gz >aln.sam
#		bwa mem -M -t $2 $REF/hg19.fa u1.fastq.gz >alnu1.sam
#		bwa mem -M -t $2 $REF/hg19.fa u2.fastq.gz >alnu2.sam
		
		aln=${i:0:5}
		echo $aln 
		samtools view -bS ${aln}.sam > ${aln}.bam
		java -jar $PICARDdir/SortSam.jar I=${aln}.bam O=${aln}_sorted.bam SO=coordinate
		mergeOrden=$mergeOrden"INPUT=${aln}_sorted.bam "
#		java -jar $PICARDdir/SortSam.jar I=alnu1.bam O=alnu1_sorted.bam SO=coordinate
#		java -jar $PICARDdir/SortSam.jar I=alnu2.bam O=alnu2_sorted.bam SO=coordinate
#		java -jar $PICARDdir/MergeSamFiles.jar INPUT=aln_sorted.bam INPUT=alnu1_sorted.bam INPUT=alnu2_sorted.bam OUTPUT=merged_sorted.bam
	fi
done
mergeOrden=$mergeOrden"OUTPUT=merged_sorted.bam"
echo $mergeOrden
$mergeOrden
java -jar $PICARDdir/MarkDuplicates.jar I=merged_sorted.bam O=aln_sorted_markedDuplicates.final.bam METRICS_FILE=aln_metrics_file_picard.txt
java -jar $PICARDdir/BuildBamIndex.jar INPUT=aln_sorted_markedDuplicates.final.bam

#java -jar $PICARDdir/AddOrReplaceReadGroups.jar I=merged_sorted.bam O=aln_final_picard.bam RGID=${4}_$lane RGLB=$3 RGPL=illumina RGPU=${5}_$lane RGSM=$sample CREATE_INDEX=true
 

