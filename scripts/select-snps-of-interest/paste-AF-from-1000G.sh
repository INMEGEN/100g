#! /bin/bash

#This script paste the allele frequency of the populations from 1000g using the script paste-AF-from-1000G.pl, cutting the input file in different sets and runing a job for each set in parallele. 

if [ $# -eq 0 ];
then
        echo "uso:
Missing values:
   paste-AF-from-1000G.sh <AF-file> <AF_1000Gp> <out_file>
where:
   <AF-file>	Input file, with allele frequencies in population
   <AF_1000Gp>	1000Gp file, with allele frequencies downloaded from ensembl
   <out_file>	Output file

example:
    ./get-modifier-variants.sh /home/user/variantes.vcf /home/user/modifier/ SM3"
        exit
fi


IN=$1
GP=$2
OUT=$3
outpath=$(echo $OUT | rev | cut -d "/" -f 2- | rev)

#split the in file
split -d -l 75000 $IN AF100g 
mv AF100g* $outpath
for i in $(ls $outpath/AF100g??)
do
bsub -J $i -e ${i}-err%J -o ${i}-out%J "perl paste-AF-from-1000G.pl -af $i -gp $GP -o ${i}-out"
done

#cd $outpath
#cat AF100*-out >$OUT
#rm AF100g*
