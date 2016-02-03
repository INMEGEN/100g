#!/bin/sh
for v in $(find /home/inmegen/r.garcia/100g/data/ -name "*.vcf.gz"); 
do 
echo $v; 

name=$(basename $v);
echo $name;


bsub -q medium -e /home/inmegen/r.garcia/100g/tests/TEST-VARIANT-MIKE/${name}.err.%J -o /home/inmegen/r.garcia/100g/tests/TEST-VARIANT-MIKE/${name}.out.%J "zcat $v | grep -v ^# -c > /home/inmegen/r.garcia/100g/tests/TEST-VARIANT-MIKE/${name}.variantcount.txt"
done
