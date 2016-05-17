#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    combinadorGVCF_AMERINDIOS.sh <DIR> <OutDir> <CoT>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
       <OutDir>: directorio donde se depositaran los VCF combinados
          <CoT>: Tamano deseado menos 1 de la cohorte de cada combinacion 
ejemplo:
    ./combinadorGVCF_AMERINDIOS.sh /home/user/proyecto/datosIntermedios /home/user/output 23"
        exit
fi

WORKdir=$1

cd $2

let cont=1
let eje=1
let c2=1
quote=$'\042'
for h in $(find $WORKdir -name "raw.vcf"); do
	echo $cont
	if [ $cont -eq 1 ]
	then
		orden="bsub -q high -e %J.err -o %J.o -J ${c2}_GVCF ${quote}java -Xmx16g -jar $GATKdir/GenomeAnalysisTK.jar -T CombineGVCFs -R $REF/human_g1k_v37_decoy.fasta"
		let eje=1
		orden="$orden --variant $h"
		let cont+=1
	else
		orden="$orden --variant $h"
		if [ $cont -gt $3 ]
		then
			orden="$orden -o output_${c2}.vcf --disable_auto_index_creation_and_locking_when_reading_rods${quote}"
			echo $orden
			echo $orden > tmp${c2}.sh
			chmod 777 tmp${c2}.sh
			#./tmp.sh
			#rm tmp.sh
			let eje=2
			let cont=1
			let c2+=1
		else
			let cont+=1
		fi
	fi
done
if [ $eje -eq 1 ]
then
	orden="$orden -o output_${c2}.vcf --disable_auto_index_creation_and_locking_when_reading_rods${quote}"
	echo $orden
	echo $orden > tmp${c2}.sh
	chmod 777 tmp${c2}.sh
#	./tmp.sh
#	rm tmp.sh
fi


