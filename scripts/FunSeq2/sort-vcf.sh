#BSUB-J sort-vcf
#BSUB-e sort-vcf.err.%J
#BSUB-o sort-vcf.out.%J

cd /home/inmegen/r.garcia/src/funseq2-1.2/
(grep ^"#" ENCODE_Output.vcf; grep -v ^"#" ENCODE_Output.vcf | sort -k1,1 -k2,2n) >ENCODE_Output_sorted.vcf
bgzip -c ENCODE_Output_sorted.vcf >ENCODE_Output_sorted.vcf.gz
tabix -p vcf ENCODE_Output_sorted.vcf.gz

