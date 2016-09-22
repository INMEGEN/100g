#BSUB-J select_high
#BSUB-e select_high.err
#BSUB-o select_high.out

cd /scratch/inmegen/100g/FunSeq2/

#VCF file that contains only high frequency variants
in="/scratch/inmegen/100g/wg_GATK/AlleleFrec-50-05.txt"

out="ENCODE_Output_sorted_high-frequency-variants.vcf"
IFS='
'
for i in $(cat $in)
do 
chr=$(echo $i | cut -f 1)
pos=$(echo $i | cut -f 2)
ref=$(echo $i | cut -f 4)
alt=$(echo $i | cut -f 5)
l=$(tabix ENCODE_Output_sorted.vcf.gz chr${chr}:${pos}-${pos})
if [ -n "$l" ]; then
   ref2=$(echo $l | cut -f 4)
   alt2=$(echo $l | cut -f 5)
   if [ "$ref2" == $ref ]; then
      if [ "$alt2" == $alt ]; then
         echo "$l"
   fi
   fi
fi
done >$out
