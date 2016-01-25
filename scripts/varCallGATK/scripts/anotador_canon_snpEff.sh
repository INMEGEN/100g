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

i=`ls | grep _final.vcf$`
iname=$(basename $i .vcf)
tiempo=`date`
echo Inicio: $tiempo
echo Se toma $iname como patron usando el genoma $2
#echo Iniciando GATK VariantAnnotator
#java -Xmx4g -jar $GATKdir/GenomeAnalysisTK.jar -T VariantAnnotator -R $REF/hg19.fa --variant $i --dbsnp $VAR/dbsnp_138.hg19.vcf -L $i -o $iname.gatk.vcf
echo Iniciando snpEff version canonica
java -Xmx4g -jar $SNPEFFdir/snpEff.jar -c $SNPEFFconfig/snpEff.config -v $2 -canon $iname.gatk.vcf > $iname.ann.canon.vcf
#echo Calculando conservación con phastCons
#java -jar $SNPEFFdir/SnpSift.jar phastCons -v $phastConsDIR $iname.ann.canon.vcf > $iname.ann.cons.canon.vcf
echo Obteniendo anotacion de dbNSFP
java -jar $SNPEFFdir/SnpSift.jar dbnsfp -v -db $SNPEFFconfig/dbNSFP/hg19.txt.gz $iname.ann.canon.vcf > $iname.ann.canon.dbnsfp.vcf
echo Obteniendo anotacion
cat $iname.ann.canon.dbnsfp.vcf | $SNPEFFdir/scripts/vcfEffOnePerLine.pl | java -jar $SNPEFFdir/SnpSift.jar extractFields - -e "." CHROM POS ID REF ALT FILTER "dbNSFP_phastCons100way_vertebrate" "dbNSFP_1000Gp1_ASN_AF" "dbNSFP_1000Gp1_EUR_AF" "dbNSFP_1000Gp1_AFR_AF" "dbNSFP_1000Gp1_AMR_AF" "dbNSFP_1000Gp1_AF" "dbNSFP_SIFT_pred" "dbNSFP_Polyphen2_HDIV_pred" "dbNSFP_Polyphen2_HVAR_pred" "ANN[*].ALLELE" "ANN[*].EFFECT" "ANN[*].IMPACT" "ANN[*].GENE" "ANN[*].GENEID" "ANN[*].FEATURE" "ANN[*].FEATUREID" "ANN[*].BIOTYPE" "ANN[*].RANK" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_POS" "ANN[*].CDS_LEN" "ANN[*].AA_POS" "ANN[*].AA_LEN" "ANN[*].DISTANCE" "GEN[*].GT" > ${iname}_tmp1.tsv
echo Generando output final: ${iname}_$2_canon.tsv
p2=`cat $iname.ann.canon.dbnsfp.vcf | grep ^#CHROM | cut -f10-`
p1=`head -n 1 ${iname}_tmp1.tsv | cut -f-33 | sed "s/ANN\[\*\]\.//g" | sed "s/dbNSFP_//g" | sed "s/_pred//g" | sed "s/100way_vertebrate//g"`
sed "1s/.*/${p1}\t${p2}/" ${iname}_tmp1.tsv > ${iname}_$2_canon.tsv
rm ${iname}_tmp1.tsv
tiempo=`date`
echo Terminado: $tiempo

