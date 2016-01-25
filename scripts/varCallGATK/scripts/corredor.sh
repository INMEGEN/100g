#! /bin/bash



for var in "$@"
do
	i=$(echo $var | rev | cut -d '/' -f1 | rev)
	echo ./maestro_somatico.sh $var /scratch-compute-0-1/carmen_alaez/Alaez_Junio2015_Cancer/Datos_Intermedios MiSeq $i TruSight_Myeloid M03540 /scratch-compute-0-1/carmen_alaez/somaticas/trusight-myeloid-amplicon-track.bed 8 /scratch-compute-0-1/carmen_alaez/Alaez_Junio2015_Cancer/Datos_Previos
done


