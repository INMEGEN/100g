#! /bin/bash
#Script to phase variants in the 100GMX project in a chromosome by chromosome way

###Importing programs
java8="/home/fperez/bin/jre1.8.0_111/bin/java"
beagle="/home/fperez/bin/beagle.27Jul16.86a.jar"
bcftools3="/home/fperez/bin/bcftools-1.3.1/bcftools"
#tabix already in path
#bgzip already in path

###Input file to phase
input="/home/fperez/100g/backup/allsamples_final_GATK.vcf.gz"

###Output folder
out="/home/fperez/100g/genotype_phasing/result/"

###Intermediate folder
inter="/home/fperez/100g/genotype_phasing/intermediate-files/"

###############################
####Phasing all chromosomes####

#Indexing input using tabix
tabix -f -p vcf $input

cd $inter

for i in {1..22}
do

###Create folder for auxiliar files
mkdir phasing-chr${i}-aux_files
cd phasing-chr${i}-aux_files

###Create auxiliar vcf with unphased variants
tabix -h $input ${i}:1-300000000 >all_chr${i}.vcf
bgzip all_chr${i}.vcf
$bcftools3 index all_chr${i}.vcf.gz

###Declare auxiliar files 
ref="/home/fperez/reference/1000Genomes/ALL.chr${i}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
map="/home/fperez/reference/HapMap_plink_maps/plink.chr${i}.GRCh37.map"

###First phasing step
$java8 -Xmx12g -jar $beagle gt=$input out=chr${i}_imputed_phased1 impute=true ibd=false nthreads=20 ref=$ref map=$map chrom=${i}:1-280000000


###Take phased sites and concatenated them with the unphased sites

#Take phased called sites and index it
$bcftools3 view -c 1 -O z chr${i}_imputed_phased1.vcf.gz -o chr${i}_imputed_phased1_called.vcf.gz --threads 20
$bcftools3 index chr${i}_imputed_phased1_called.vcf.gz

#Concatenated phased called sites with all variants in the cromosome and then index
$bcftools3 concat -a chr${i}_imputed_phased1_called.vcf.gz all_chr${i}.vcf.gz -O z -o merge_chr${i}.vcf.gz --threads 20
$bcftools3 index merge_chr${i}.vcf.gz

#Remove duplicated unphased variants
$bcftools3 norm -d any merge_chr${i}.vcf.gz -O z -o merge_chr${i}_no_dup.vcf.gz --threads 20


###Re-phase unphased sites

$java8 -Xmx12g -jar $beagle gt="merge_chr${i}_no_dup.vcf.gz" out=chr${i}_imputed_phased2 impute=false ibd=false nthreads=20

cp chr${i}_imputed_phased2.vcf.gz $out
cd ..

done
