#!/bin/bash

##########################################################
#Script to eval the depth for the 12M variants in the 94g#

if [ $# -lt 3 ];
then
echo "use:
    eval-coverage.sh <regiones.bed> <bam-list> <output>
      <regiones.bed> BED format file that contains the regions to calculate depth
      <bam-list> File with all the bams to evaluate coverage in a list
      <output> Output file

example: eval-coverage.sh /export/home/fperez/var-regions.bed /export/home/fperez/100g/listado-bams.txt /export/home/fperez/coverage.txt

Its necesary bedtools in path"
 exit
fi



#List of bam files to analyse
bams=$2

#Regions to eval
bed=$1

#Output Path
out=$3

t=$(date)
echo "Starting at: $t"

#Puting all bams in a line
bamline=$(cat $bams | tr -s "\n" " ")

#Calculus of depth in all bams at bed regions
bedtools multicov -bams $bamline -bed $bed >$out
