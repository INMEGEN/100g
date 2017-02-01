#!/bin/bash



echo "[] concatenating vcf files for $1"

ls Input_files/VCFs/1000G_p3/ALL.chr$1*.gz > temp/vcf_file.list

while read v_file; do
sample=$(echo $v_file | cut -d"/" -f4 | cut -d"." -f3)
		echo "[>] unzipping $sample file for chromosome $1"
		gunzip $v_file

done < temp/vcf_file.list

ls Input_files/VCFs/1000G_p3/ALL.chr$1.svmed.with_numts_cmplxinvs.genotype_likelihoods.vcf > temp/vcf_file.list
ls Input_files/VCFs/1000G_p3/ALL.chr$1.snps_indels_complex_STRs_svs.genotype_likelihoods.vcf >> temp/vcf_file.list

while read v_file; do
sample=$(echo $v_file | cut -d"/" -f4 | cut -d"." -f3)
                echo "[>] reheading $sample file for chromosome $1"
		head -n2 $v_file | tail -n1 > temp/reheaded.$sample.$1.vcf
		head -n1 $v_file >> temp/reheaded.$sample.$1.vcf
		gawk 'BEGIN {FS="\t"; OFS="\t";} NR>2 {print} ' $v_file >> temp/reheaded.$sample.$1.vcf
		rm $v_file
		mv temp/reheaded.$sample.$1.vcf $v_file
##Aqui hay que agregar el bgzip con indexado

done < temp/vcf_file.list

#bcftools concat -a -dall -Ov -o Input_files/VCFs/1000G_p3/concat.chr$1.vcf Input_files/VCFs/1000G_p3/ALL.chr$1*.gz
