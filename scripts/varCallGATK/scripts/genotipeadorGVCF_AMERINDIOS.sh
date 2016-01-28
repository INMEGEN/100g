#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    genotipeadorGVCF_AMERINDIOS.sh <DIR> <OutDir><nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
       <OutDir>: directorio donde se depositara el VCF completo
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./genotipeadorGVCF_AMERINDIOS.sh /home/user/proyecto/datosIntermedios /home/user/output 4"
        exit
fi

WORKdir=$1

cd $2

let cont=1
let eje=1
let c2=1
for h in $(find $WORKdir -name "raw.vcf"); do
	echo $cont
	if [ $cont -eq 1 ]
	then
		orden="java -Xmx16g -jar $GATKdir/GenomeAnalysisTK.jar -T CombineGVCFs -R $REF/human_g1k_v37_decoy.fasta -nt $3"
		let eje=1
		orden="$orden --variant $h"
		let cont+=1
	else
		orden="$orden --variant $h"
		if [ $cont -gt $4 ]
		then
			orden="$orden -o output_${c2}.vcf --disable_auto_index_creation_and_locking_when_reading_rods"
			echo $orden 
			$orden
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
	orden="$orden -o output_${c2}.vcf --disable_auto_index_creation_and_locking_when_reading_rods"
	echo $orden
	$orden
fi 
orden="java -Xmx16g -jar $GATKdir/GenomeAnalysisTK.jar -T GenotypeGVCFs -R $REF/human_g1k_v37_decoy.fasta -nt $3"
for h in $(ls output*vcf); do
	orden="$orden --variant $h"
done
orden="$orden -o final_output.vcf --disable_auto_index_creation_and_locking_when_reading_rods"
echo $orden
$orden


