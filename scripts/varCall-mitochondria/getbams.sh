#BSUB-J MitoBAM
#BSUB-e getBAM.err.%J
#BSUB-o getBAM.out.%J
#BSUB-q medium

a="/scratch/inmegen/100g/NHT140485--3/2015.07.29.12_raw_clean_30_bam/bam_30/"
b="/scratch/inmegen/100g/NHT140485--4/2015.07.29_38_bam_68_vari/bam_38/"
c="/scratch/inmegen/100g/NHT140485--5/2015.08.12_27_raw_clean_10_bam/bam_10/"
d="/scratch/inmegen/100g/NHT140485--6/2015.08.12_27_17_bam_27_var/Bam_17/"

cd $a
for i in $(ls -d */ | tr -d "/"); do cd $i; cd Sample_*; samtools view -h -b ${i}.final.bam MT:1-17000 >/scratch/inmegen/100g/Mitochondrial-bams/${i}-MT.bam; cd ../../; done
cd $b
for i in $(ls -d */ | tr -d "/"); do cd $i; cd Sample_*; samtools view -h -b ${i}.final.bam MT:1-17000 >/scratch/inmegen/100g/Mitochondrial-bams/${i}-MT.bam; cd ../../; done
cd $c
for i in $(ls -d */ | tr -d "/"); do cd $i; cd Sample_*; samtools view -h -b ${i}.final.bam MT:1-17000 >/scratch/inmegen/100g/Mitochondrial-bams/${i}-MT.bam; cd ../../; done
cd $d
for i in $(ls -d */ | tr -d "/"); do cd $i; cd Sample_*; samtools view -h -b ${i}.final.bam MT:1-17000 >/scratch/inmegen/100g/Mitochondrial-bams/${i}-MT.bam; cd ../../; done
