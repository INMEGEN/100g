bsub -o out.%J -e err.%J -q medium "perl get-snps.pl"

#After runing the previous line, then run this
#./paste-AF-from-1000G.sh /scratch/inmegen/100g/wg_GATK/SNVs-Allefrequency-0.05.txt /scratch/inmegen/100g/references/1000g-phase_3-allele-frequency/1000GENOMES-phase_3-hg19.vcf.gz /scratch/inmegen/100g/wg_GATK/SNVs-Allefrequency-0.05-1000GP.txt
