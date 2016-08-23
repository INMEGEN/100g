#BSUB-J Funseq2
#BSUB-e funseq2.err.%J
#BSUB-o funseq2.out.%J
#BSUB-N 
#BSUB-u frpvillatoro@gmail.com
#BSUB-n 6

export PATH=$PATH:/home/inmegen/r.garcia/src/TFM-Pvalue/
cd /home/inmegen/r.garcia/src/funseq2-1.2/
./funseq2.sh -f /scratch/inmegen/100g/wg_GATK/perIndividuoGATK/94_samples.vcf -inf VCF -m 2 -nc -o /scratch/inmegen/100g/FunSeq2/
