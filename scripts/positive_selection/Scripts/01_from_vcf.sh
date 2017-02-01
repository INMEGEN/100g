#!/bin/bash

### A continuacion hace la SAF Estimation (Site Allele Frecuency) desde VCF
###
echo "[>>] Calculando SAF para el directorio $list_name"
#./Tools/ANGSD/angsd/angsd -b $o_file -anc Input_files/Ancestral_sequence/chimpHg19.fa.gz -out Output_files/$list_name -dosaf 1 -gl 1 -P 10
./Tools/ANGSD/angsd/angsd -vcf-gl $1 -nind 93 -fai Input_files/VCFs/1000G_p3/hs37d5.fa.gz.fai -anc Input_files/Ancestral_sequence/chimpHg19.fa.gz -out test.from_vcf.saf -dosaf 1
