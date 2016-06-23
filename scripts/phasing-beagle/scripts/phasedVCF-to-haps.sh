#! /bin/bash

if [ $# -eq 0 ];
then
        echo "uso:
Escript para convertir archivos VCFs faseados por Beagle a formato HAPs de SHAPEIT
    phasedVCF-to-haps.sh <VCF> <HAPS>
donde:
           <VCF>: Archivo VCF faseado a convertir a HAPS
           <HAPS>: Archivo HAPS de salida
ejemplo:
    phasedVCF-to-haps.sh /home/user/proyecto/datosIntermedios/vcf-chr22.vcf /home/user/proyecto/datosIntermedios/vcf-chr22.haps"
        exit
fi

vcf=$1
haps=$2
dir=$(echo $1 | rev | cut -d "/" -f 2- | rev)
name=$(echo $1 | rev | cut -d "/" -f 1 | rev)

zcat $1 | grep -v "#" | awk '{printf $1"\t"$3"\t"$2"\t"$4"\t"$5"\n"}' >${dir}/${name}_aux1
zcat $1  | grep -v "#" | cut -f 10- | tr -s "|" "\t"  >${dir}/${name}_aux2
paste ${dir}/${name}_aux1 ${dir}/${name}_aux2 >$haps
rm ${dir}/${name}_aux1
rm ${dir}/${name}_aux2
