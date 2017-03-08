#!/bin/bash

nsamples=$1
populations=( $(echo $2 | tr "," " ") )
chromosome=$(echo $3 | cut -d"." -f2)

echo "[]Staring subsampling $chromosome for ${populations[@]} populations"

###CHECK VALIDITY OF INPUT POPULATIONS
cut -f6 Input_files/VCFs/1000G_p3/igsr_samples.tsv | sort -u > temp/valid_populations

for POP in "${populations[@]}"
do
	hits=$(grep -wc $POP temp/valid_populations)
	if [ ! $hits -eq 1 ]
		then
		echo "[STOPING SCRIPT] Population $POP has no samples, or Superpopulation ID is similar to another Superpopulation ID."
		exit 1
		fi
done

###EXTRACTING SAMPLE NAMES FROM VCF

zgrep -m1 -w "\#CHROM" $3 | tr "\t" "\n" > temp/vcf_samples

###SUBSAMPLING VCF BY POPULATIONS
for POP in "${populations[@]}"
do
	echo "[>] Randomizing $1 samples for $POP population."
	Rscript --vanilla Scripts/01-2.Table_randomizer.R $1 $POP

	columnas=$(cat temp/col_numbers_$POP)
	zcat $3 | cut -f1-9,$columnas > Input_files/VCFs/by_population/$1.$POP.$chromosome.vcf
done


##REMOVE TEMP FILES
rm temp/*
