#! /bin/bash

###Importing programs
bcftools3="/home/fperez/bin/bcftools-1.3.1/"

#GATK vcf
gatk="/home/fperez/100g/backup/94_samples.ann.canon.vcf.gz"

#Output path
outpath="/home/fperez/100g/bgi-gatk_var-comparison"

#BGI vcf1 and vcf2
bgi1snp="/home/fperez/100g/discos3a6/disco4y6/NHT140485--4/2015.07.29_38_bam_68_vari/variation_68/SM-3MG3L/SNP/SM-3MG3L.samtools.snp.reformated.vcf.gz"
bgi2snp="/home/fperez/100g/discos3a6/disco4y6/NHT140485--4/2015.07.29_38_bam_68_vari/variation_68/SM-3MG3N/SNP/SM-3MG3N.samtools.snp.reformated.vcf.gz"


####################################
########VCF comparision#############

cd $outpath

#Identifying sample names
sample1=$(echo $bgi1snp | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1)
sample2=$(echo $bgi2snp | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1)

echo "Selection of variants for each sample"
${bcftools3}/bcftools view -s $sample1 $gatk -U -v snps -O z -o ${sample1}-gatk.vcf.gz
${bcftools3}/bcftools view -s $sample2 $gatk -U -v snps -O z -o ${sample2}-gatk.vcf.gz

echo "Coping vcfs to actual path"
#Coping vcf to actual path (this step was necesary because you cant write the disc where the vcfs are stored, and its necesary to create a bcftools index)
cp $bgi1snp ${sample1}-bgi.vcf.gz
cp $bgi2snp ${sample2}-bgi.vcf.gz

echo "Making bcftools index for each vcf file"
for i in $(ls *vcf.gz)
do
  ${bcftools3}/bcftools index $i
done

echo "Comparision of variants"
${bcftools3}/bcftools isec ${sample1}-gatk.vcf.gz ${sample1}-bgi.vcf.gz -p ${sample1}
${bcftools3}/bcftools isec ${sample2}-gatk.vcf.gz ${sample2}-bgi.vcf.gz -p ${sample2}

