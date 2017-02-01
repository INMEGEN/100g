#!/bin/bash

find ../../../SVs/Input_files/DISKs/ -name "*.final.bam" | grep -v "SM-3MGPV" | grep -v "SM-3MG3M" > sample_index.txt

wglist=$(cat  sample_index.txt |tr "\n" " ")
Array=($wglist)

for i in "${Array[@]}"
do
	sample=$(echo $i | cut -d"/" -f11)
	echo "[] procesando $sample"

	samtools view -b $i 22:2,000,000 > ../../Output_files/$sample.chr22_1a2000000.final.bam
done
