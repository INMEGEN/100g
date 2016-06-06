#BSUB-e BGL-2-2.err.%J
#BSUB-o BGL-2-2.out.%J
#BSUB-J BGL-2-2
#BSUB-n 16

cd /scratch/inmegen/100g/phasing
export PATH=$PATH:/scratch/inmegen/100g/references/JAVA/jdk1.8.0_74/bin/

java8 -Xmx12g -jar /home/inmegen/r.garcia/src/beagle.03May16.862.jar gt=/scratch/inmegen/100g/wg_GATK/test3/allsamples_final_recaled_snp-indel.vcf chrom=2 ref=/scratch/inmegen/100g/references/1000g-phase_3-allele-frequency/ALL.chr2.phase3_shapeit2_mvncall_integrated_v5_extra_anno.20130502.genotypes.vcf.gz out=chr2_2 impute=false ibd=false

