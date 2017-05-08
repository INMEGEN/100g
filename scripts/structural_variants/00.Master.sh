#!/bin/bash

echo "[] Arrancando el pipeline."

echo "[] Revisando estructura del directorio Input."

if [ ! -f Input_files/resources/reference/human_g1k_v37_decoy.fasta ]; then
echo "[X] FALTA el genoma de referencia.fasta."
exit 1
fi
echo "[>] genoma de referencia presente."

#if [ ! -d /labs/100g/SVs/BAMs_for_testing/ ]; then
#echo "[X] FALTA el directorio de BAMs Input con estructura Input_files/BAMs/SAMPLE/SAMPLE.bam."
#exit 1
#fi
#echo "[>] directorio de BAMs/ presente."


echo "[] Revisando estructura de directorio Output."

if [ ! -d Output_files/ ]; then
echo "-Creando directorio Output_files/"
mkdir Output_files/
fi

echo "[>] directorio Output_files/ presente."

bash 01.AMI2_delly_multi_thr.sh $1

bash 02.AMI2_delly_multi_thr_REGENOTYPING.sh $1
