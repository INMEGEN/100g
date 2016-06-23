#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    anotador_canon_snpEff.sh <path> <genoma>
donde:
     <path>: direccion del directorio donde se pretende 
             ejecutar el analisis
   <genoma>: nombre del genoma con el que se va a hacer
             la anotacion
ejemplo:
    ./anotador_canon_snpEff.sh /home/user/variantes hg19"
        exit
fi


WORKdir=$1

cd $WORKdir

i=`ls *_final.exonic.vcf`
iname=$(basename $i _final.exonic.vcf)
tiempo=`date`
echo Inicio: $tiempo
echo Se toma $iname como patron usando el genoma $2
#echo Iniciando GATK VariantAnnotator
java -Xmx4g -jar $GATK35dir/GenomeAnalysisTK.jar -T VariantAnnotator -R $REF/human_g1k_v37_decoy.fasta --variant $i --dbsnp $VAR/dbsnp_138.b37.vcf -L $i -o $iname.gatk.vcf
echo Iniciando snpEff version canonica
java -Xmx4g -jar $SNPEFFdir/snpEff.jar -c $SNPEFFconfig/snpEff.config -v $2 -canon $iname.gatk.vcf > $iname.ann.canon.vcf
#echo Calculando conservación con phastCons
#java -jar $SNPEFFdir/SnpSift.jar phastCons -v $phastConsDIR $iname.ann.canon.vcf > $iname.ann.cons.canon.vcf
echo Obteniendo anotacion de dbNSFP
#java -jar $SNPEFFdir/SnpSift.jar dbnsfp -v -db $SNPEFFconfig/dbNSFP/hg19.txt.gz $iname.ann.canon.vcf > $iname.ann.canon.dbnsfp.vcf
echo Obteniendo anotacion
#cat $iname.ann.canon.dbnsfp.vcf | $SNPEFFdir/scripts/vcfEffOnePerLine.pl | java -jar $SNPEFFdir/SnpSift.jar extractFields - -e "." CHROM POS ID REF ALT FILTER "dbNSFP_phastCons100way_vertebrate" "dbNSFP_1000Gp1_ASN_AF" "dbNSFP_1000Gp1_EUR_AF" "dbNSFP_1000Gp1_AFR_AF" "dbNSFP_1000Gp1_AMR_AF" "dbNSFP_1000Gp1_AF" "dbNSFP_SIFT_pred" "dbNSFP_Polyphen2_HDIV_pred" "dbNSFP_Polyphen2_HVAR_pred" "ANN[*].ALLELE" "ANN[*].EFFECT" "ANN[*].IMPACT" "ANN[*].GENE" "ANN[*].GENEID" "ANN[*].FEATURE" "ANN[*].FEATUREID" "ANN[*].BIOTYPE" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_POS" "ANN[*].CDS_LEN" "ANN[*].AA_POS" "ANN[*].AA_LEN" "ANN[*].DISTANCE" "GEN[*].GT" > ${iname}_tmp1.tsv
#cat $iname.ann.canon.dbnsfp.vcf | $SNPEFFdir/scripts/vcfEffOnePerLine.pl | java -jar $SNPEFFdir/SnpSift.jar extractFields - -e "." CHROM POS ID REF ALT FILTER "dbNSFP_Uniprot_acc" "dbNSFP_Uniprot_id" "dbNSFP_Uniprot_aapos" "dbNSFP_Interpro_domain" "dbNSFP_cds_strand" "dbNSFP_refcodon" "dbNSFP_SLR_test_statistic" "dbNSFP_codonpos" "dbNSFP_fold-degenerate" "dbNSFP_Ancestral_allele" "dbNSFP_Ensembl_geneid" "dbNSFP_Ensembl_transcriptid" "dbNSFP_aapos" "dbNSFP_aapos_SIFT" "dbNSFP_aapos_FATHMM" "dbNSFP_SIFT_score" "dbNSFP_SIFT_converted_rankscore" "dbNSFP_SIFT_pred" "dbNSFP_Polyphen2_HDIV_score" "dbNSFP_Polyphen2_HDIV_rankscore" "dbNSFP_Polyphen2_HDIV_pred" "dbNSFP_Polyphen2_HVAR_score" "dbNSFP_Polyphen2_HVAR_rankscore" "dbNSFP_Polyphen2_HVAR_pred" "dbNSFP_LRT_score" "dbNSFP_LRT_converted_rankscore" "dbNSFP_LRT_pred" "dbNSFP_MutationTaster_score" "dbNSFP_MutationTaster_converted_rankscore" "dbNSFP_MutationTaster_pred" "dbNSFP_MutationAssessor_score" "dbNSFP_MutationAssessor_rankscore" "dbNSFP_MutationAssessor_pred" "dbNSFP_FATHMM_score" "dbNSFP_FATHMM_rankscore" "dbNSFP_FATHMM_pred" "dbNSFP_MetaSVM_score" "dbNSFP_MetaSVM_rankscore" "dbNSFP_MetaSVM_pred" "dbNSFP_MetaLR_score" "dbNSFP_MetaLR_rankscore" "dbNSFP_MetaLR_pred" "dbNSFP_Reliability_index" "dbNSFP_VEST3_score" "dbNSFP_VEST3_rankscore" "dbNSFP_PROVEAN_score" "dbNSFP_PROVEAN_converted_rankscore" "dbNSFP_PROVEAN_pred" "dbNSFP_CADD_raw" "dbNSFP_CADD_raw_rankscore" "dbNSFP_CADD_phred" "dbNSFP_GERP++_NR" "dbNSFP_GERP++_RS" "dbNSFP_GERP++_RS_rankscore" "dbNSFP_phyloP46way_primate" "dbNSFP_phyloP46way_primate_rankscore" "dbNSFP_phyloP46way_placental" "dbNSFP_phyloP46way_placental_rankscore" "dbNSFP_phyloP100way_vertebrate" "dbNSFP_phyloP100way_vertebrate_rankscore" "dbNSFP_phastCons46way_primate" "dbNSFP_phastCons46way_primate_rankscore" "dbNSFP_phastCons46way_placental" "dbNSFP_phastCons46way_placental_rankscore" "dbNSFP_phastCons100way_vertebrate" "dbNSFP_phastCons100way_vertebrate_rankscore" "dbNSFP_SiPhy_29way_pi" "dbNSFP_SiPhy_29way_logOdds" "dbNSFP_SiPhy_29way_logOdds_rankscore" "dbNSFP_LRT_Omega" "dbNSFP_UniSNP_ids" "dbNSFP_1000Gp1_AC" "dbNSFP_1000Gp1_AF" "dbNSFP_1000Gp1_AFR_AC" "dbNSFP_1000Gp1_AFR_AF" "dbNSFP_1000Gp1_EUR_AC" "dbNSFP_1000Gp1_EUR_AF" "dbNSFP_1000Gp1_AMR_AC" "dbNSFP_1000Gp1_AMR_AF" "dbNSFP_1000Gp1_ASN_AC" "dbNSFP_1000Gp1_ASN_AF" "dbNSFP_ESP6500_AA_AF" "dbNSFP_ESP6500_EA_AF" "dbNSFP_ARIC5606_AA_AC" "dbNSFP_ARIC5606_AA_AF" "dbNSFP_ARIC5606_EA_AC" "dbNSFP_ARIC5606_EA_AF" "dbNSFP_ExAC_AC" "dbNSFP_ExAC_AF" "dbNSFP_ExAC_Adj_AC" "dbNSFP_ExAC_Adj_AF" "dbNSFP_ExAC_AFR_AC" "dbNSFP_ExAC_AFR_AF" "dbNSFP_ExAC_AMR_AC" "dbNSFP_ExAC_AMR_AF" "dbNSFP_ExAC_EAS_AC" "dbNSFP_ExAC_EAS_AF" "dbNSFP_ExAC_FIN_AC" "dbNSFP_ExAC_FIN_AF" "dbNSFP_ExAC_NFE_AC" "dbNSFP_ExAC_NFE_AF" "dbNSFP_ExAC_SAS_AC" "dbNSFP_ExAC_SAS_AF" "dbNSFP_clinvar_rs" "dbNSFP_clinvar_clnsig" "dbNSFP_clinvar_trait" "dbNSFP_COSMIC_ID" "dbNSFP_COSMIC_CNT" > ${iname}_$2_canon.tsv
echo Generando output final: ${iname}_$2_canon.tsv
#p2=`cat $iname.ann.canon.dbnsfp.vcf | grep ^#CHROM | cut -f10-`
#p1=`head -n 1 ${iname}_tmp1.tsv | cut -f-33 | sed "s/ANN\[\*\]\.//g" | sed "s/dbNSFP_//g" | sed "s/_pred//g" | sed "s/100way_vertebrate//g"`
#sed "1s/.*/${p1}\t${p2}/" ${iname}_tmp1.tsv > ${iname}_$2_canon.tsv
#rm ${iname}_tmp1.tsv
tiempo=`date`
echo Terminado: $tiempo
#¿
