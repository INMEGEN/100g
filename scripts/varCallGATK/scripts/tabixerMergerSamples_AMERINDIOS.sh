#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    genotipeadorGVCF_AMERINDIOS.sh <DIR> <OutDir><nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras combinadas
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./tabixerMergerSamples_AMERINDIOS.sh /home/user/proyecto/datosIntermedios"
        exit
fi

export PATH=$PATH:/home/inmegen/r.garcia/src/bcftools-1.3
cd $1

orden="bcftools merge"
for h in $(ls); do
	if [ -d $h ]
	then
  	        echo Analizando muestra $h
		orden+=" ${h}/${h}_GATK_PASS-snp-indel.vcf.gz"
		cd $h
		if [ -f ${h}_GATK_PASS-snp-indel.vcf.gz.tbi ]
		then
			echo Ya se ha hecho el indice tabix de la muestra ${h}
		else
			echo Obteniendo indice tabix de la muestra ${h}
			bgzip -c ${h}_GATK_PASS-snp-indel.vcf > ${h}_GATK_PASS-snp-indel.vcf.gz
			tabix -p vcf ${h}_GATK_PASS-snp-indel.vcf.gz
		fi
		cd ..
	else
                echo Fichero $h omitido
	fi
done
orden+=" -O v -o allsamples_merged.vcf"
echo Realizando merge
echo $orden
$orden
echo Obteniendo indice tabix de poblacion
bgzip -c allsamples_merged.vcf > allsamples_merged.vcf.gz
tabix -p vcf allsamples_merged.vcf.gz
echo Completado satisfactoriamente

