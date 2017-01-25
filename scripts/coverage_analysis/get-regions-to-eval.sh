#!/bin/bash

#Script to get the regions with variants in all the 94g

#TABIX is necesary on path

inputVCF="/export/home/fperez/100g/backup/94_samples.ann.canon.vcf.gz"
outpath="/export/home/fperez/100g/coverage-analysis/"

for i in {1..22} X Y MT
do
 echo "Processing chr${i}"
 tabix ${inputVCF} ${i}:1-300000000 | awk '{printf $1"\t"$2"\t"$2"\t.\t.\t.\t.\n"}' >${outpath}/chr${i}-var-regions.bed
done
