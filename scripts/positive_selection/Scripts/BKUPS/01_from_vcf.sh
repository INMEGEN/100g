#!/bin/bash

### A continuacion hace la SAF Estimation (Site Allele Frecuency) desde VCF
###
#sample=$(echo $1 | cut -d"/" -f4)
#nind=$(echo $sample | cut -d"_" -f1)

#o_file=Output_files/$sample
#echo "[>>] Calculando SAF para $sample $O_file"
#./Tools/ANGSD/angsd/angsd -vcf-gl $1 -nind $nind -fai Input_files/VCFs/1000G_p3/hs37d5.fa.gz.fai -anc Input_files/Ancestral_sequence/chimpHg19.fa.gz -out $o_file -dosaf 1
