##script para partir por cromosoma cada vcf
##Se deposita la informacion en /scratch/inmegen/100g/VCFs-by-chr

#BSUB-q medium                   # Job queue
#BSUB-o split.output               # output is sent to file job.output
#BSUB-e split.err                  # stderr    
#BSUB-J split-vcfs                 # name of the job


# My instructions
for j in {1..22}
do
tabix /home/inmegen/r.garcia/100g/data/SM-3MG3M/SNP/SM-3MG3M.samtools.snp.reformated.vcf.gz ${j}:1-300000000 >/scratch/inmegen/100g/VCFs-by-chr/SM-3MG3M/chr${j}_SM-3MG3M.samtools.snp.reformated.vcf
done
