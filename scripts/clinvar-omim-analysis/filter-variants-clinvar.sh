#script to take a subset confidence variants from clinvar database, convert them to vcf, and index with Tabix ##
#Its important to have Tabix in the $PATH

#BSUB-e filter-err.%J
#BSUB-o filter-out.%J
#BSUB-J clinvar

#Clinvar Path
p="/scratch/inmegen/100g/references/clinvar"

#Select confidence variants
grep "GRCh37" ${p}/variant_summary_2015-11.txt >${p}/variant_summary_2015-11_GRCh37.txt
grep -E "multiple submitters|practice guideline|reviewed by expert" ${p}/variant_summary_2015-11_GRCh37.txt >${p}/variant_summary_2015-11_GRCh37_reviewed.txt
#Change to vcf format and edit by Tabix
cat ${p}/variant_summary_2015-11_GRCh37_reviewed.txt  | awk 'BEGIN {FS="\t"};{printf $14"\t"$15"\t"$26"\t"$27"\t"$1"\t"$25"\t"$11"\n"}' | grep -v "na" | sort -k1,1 -k2,2n >${p}/variant_summary_2015-11_GRCh37_reviewed.vcf
bgzip -c ${p}/variant_summary_2015-11_GRCh37_reviewed.vcf >${p}/variant_summary_2015-11_GRCh37_reviewed.vcf.gz
tabix -p vcf ${p}/variant_summary_2015-11_GRCh37_reviewed.vcf.gz
