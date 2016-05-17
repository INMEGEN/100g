#! /bin/bash

if [ $# -eq 0 ];
then
        echo "uso:
Missing values:
    get-modifier-variants.sh <vcf> <out_path> <sample>
where:
   <vcf>: Input annotated vcf file
   <out_path>: Output path
   <sample>: Sample name for each file name
example:
    ./get-modifier-variants.sh /home/user/variantes.vcf /home/user/modifier/ SM3"
        exit
fi


#Input and output files, change those values
INPUT=$1
OUTPUT=$2
sample=$3

#get the modifier variants and write in file
grep -v -E "intergenic|intron|synonymous|\|inframe|intragenic|non_coding|Noncoding|downstream_gene|upstream_gene|\|3_prime_UTR_variant\||\|5_prime_UTR_variant\||stop_retained_variant|\|3_prime_UTR_v\|" $INPUT  | grep -v "^#" >$OUTPUT/${sample}-modifier-variants.txt

#get the genes with modifer variants
awk 'BEGIN {FS="|"}; {print $4}' $OUTPUT/${sample}-modifier-variants.txt | sort -u | tr -s "," "\n" | sort -u >$OUTPUT/${sample}-modified-genes.txt


