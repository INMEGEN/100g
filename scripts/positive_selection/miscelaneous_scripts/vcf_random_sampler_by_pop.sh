#!/bin/bash

## Recibe como argumento el ID de una de las superpoblaciones del 1000 genomes project fase 3, de acuerdo a como estan en el archivo igsr_samples.tsv
## Las poblaciones posibles son AS (SOut ASians),  EAS (east asians), EUR (european), FR (African), MR (American).

o_file=temp/$1"_"$2".sample_list"
o_vcf=Input_files/VCFs/by_population/$1"_"$2".vcf"

echo "[] Extracting all sample names for $2 population"
grep -w $2 Input_files/VCFs/1000G_p3/igsr_samples.tsv | cut -f1 > $o_file

echo "[] Validating sample names existance in VCF"

zgrep -m1 -w "\#CHROM" $3 | cut -f10- | tr "\t" "\n" > temp/samples_in_vcf

grep -wFf $o_file temp/samples_in_vcf > temp/valid_samples


echo "[>] Randomizing $1 samples for $2 population"

Rscript --vanilla Tools/randomizer.R temp/valid_samples $1 $o_file

echo "[>>] $1 $2 Samples succesfully randomized"

echo "[>>>] Subsampling VCF"

bcftools view -Ov -I -S $o_file $3 > $o_vcf
