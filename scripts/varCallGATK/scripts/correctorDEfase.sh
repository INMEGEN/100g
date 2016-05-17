#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    correctorDEfase.sh <DIR> <dist>
donde:
          <DIR>: ruta donde se encuentran los directorios
                 de las muestras
         <dist>: distancia de correccion en nucleotidos 
ejemplo:
    ./correctorDEfase.sh /home/user/proyecto/datosIntermedios 4"
        exit
fi

export PATH=$PATH:/home/inmegen/r.garcia/src/bedtools-2.17.0/bin
WORKdir=$1

cd $WORKdir

for h in $(ls); do
	if [ -d "$h" ]
	then
		cd $h
		echo Procesando $h
		perl $perlDIR/variantDistances.pl ${h}_GATK_PASS-snp-indel.vcf $2 | cut -f-2,4-5,10- > algo.txt
		perl $perlDIR/variantCorrector.pl algo.txt ${h}_GATK_PASS-snp-indel.vcf $REF/human_g1k_v37_decoy.fasta > ${h}_filtered_final.vcf
		if [ -f "algo.txt" ]
		then
			rm algo.txt
		fi
		if [ -f "otro.fa" ]
		then		
			rm otro.fa
		fi
		if [ -f "tmp.bed" ]
		then
			rm tmp.bed
		fi
	        cd ..
	fi
done 

