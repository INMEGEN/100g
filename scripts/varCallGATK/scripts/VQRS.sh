#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    VQRS.sh <INN> <nt>
donde:
          <INN>: Archivo VCF a recalibrar
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./realineador.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

#Deffining variables
INPUT=$1
INNAME=$(echo $INPUT | cut -d "." -f 1)


#If the INPUT has no index, it will be created by IGVtools
if [ -e ${INPUT}.idx ]
 then
     echo El indice ${INPUT}.idx ya existe, se omite su creacion

 else
     echo $IGVdir/igvtools index $INPUT
     $IGVdir/igvtools index $INPUT
 fi


#Recalibrating SNPs

java -Xmx40g -jar $GATK35dir/GenomeAnalysisTK.jar -T VariantRecalibrator -R $REF/human_g1k_v37_decoy.fasta -input $INPUT -mode SNP -recalFile ${INNAME}_snp.recal -tranchesFile ${INNAME}_snp.trash -rscriptFile ${INNAME}-recalibrate_SNP_plots.R -nt $2 -resource:hapmap,known=false,training=true,truth=true,prior=15.0 $REF/hapmap_3.3.b37.vcf -resource:omni,known=false,training=true,truth=true,prior=12.0 $REF/1000G_omni2.5.b37.vcf -resource:1000G,known=true,training=true,truth=true,prior=10.0 $REF/Mills_and_1000G_gold_standard.indels.b37.vcf -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $REF/dbsnp_138.b37.vcf -an DP -an QD -an FS -an SOR -an MQ -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff

#Apply recalibration in SNPs
java -Xmx40g -jar $GATK35dir/GenomeAnalysisTK.jar -T ApplyRecalibration -R $REF/human_g1k_v37_decoy.fasta -input $INPUT -mode SNP -recalFile ${INNAME}_snp.recal -nt $2 -tranchesFile ${INNAME}_snp.trash -o ${INNAME}_recaled_snp.vcf -ts_filter_level 99.0 

#Recalibrating INDELS
java -Xmx40g -jar $GATK35dir/GenomeAnalysisTK.jar -T VariantRecalibrator -R $REF/human_g1k_v37_decoy.fasta -input ${INNAME}_recaled_snp.vcf  -mode INDEL -recalFile ${INNAME}_recaled_snp_indel.recal -tranchesFile ${INNAME}_recaled_snp_indel.trash -rscriptFile ${INNAME}_recaled_snp-recalibrate_INDEL_plots.R -nt $2 -resource:mills,known=false,training=true,truth=true,prior=12.0 $REF/Mills_and_1000G_gold_standard.indels.b37.vcf -an DP -an QD -an FS -an SOR -an MQRankSum -an ReadPosRankSum -an InbreedingCoeff

#Apply recalibration in INDELS
java -Xmx40g -jar $GATK35dir/GenomeAnalysisTK.jar -T ApplyRecalibration -R $REF/human_g1k_v37_decoy.fasta -input ${INNAME}_recaled_snp.vcf -mode INDEL -recalFile ${INNAME}_recaled_snp_indel.recal -nt $2 -tranchesFile ${INNAME}_recaled_snp_indel.trash -o ${INNAME}_recaled_snp-indel.vcf -ts_filter_level 99.0
