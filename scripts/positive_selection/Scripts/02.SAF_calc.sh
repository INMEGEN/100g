#!/bin/bash

fai_file=Input_files/VCFs/1000G_p3/hs37d5.fa.gz.fai
ancestral_seq=Input_files/Ancestral_sequence/chimpHg19.fa.gz

VCFs=( $(ls Input_files/VCFs/by_population/*$1*) )

for v_file in "${VCFs[@]}"
do
o_file=Output_files/ANGSD_SAF/$(echo $v_file | cut -d"/" -f4)
	n_individuals=$(grep -m1 -w "\#CHROM" $v_file | tr "\t" "\n" | tail -n+10 | wc -l)
	echo "[]Calculating SAF for $n_individuals samples in $v_file"
	./Tools/ANGSD/angsd/angsd -vcf-gl $v_file -nind $n_individuals -fai $fai_file -anc $ancestral_seq -dosaf 1 -out $o_file
done
