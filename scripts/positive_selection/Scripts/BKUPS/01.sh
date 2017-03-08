#!/bin/bash

####
## Crear la lista de bamfiles de acuerdo a la carpeta señalada como input por el usuario !!!EN UNA CARPETA DEBE ESTAR CADA UNA DE LAS POBLACIONES QUE SE QUIEREN ESTUDIAR, CADA CARPETA SEPARADA
###

list_name=$(echo $1 | cut -d"/" -f3)
fecha=$(date -u | tr " " "_" | tr ":" ".")
o_file=$(echo temp/$list_name"_"$fecha".filelist")

echo "[]Creando filelist para el directorio $list_name"

find $1 -name "*.bam" > $o_file

echo "[>]Guardado en $o_file"

####
## A continuacion hace la SAF Estimation (Site Allele Frecuency)
###
echo "[>>] Calculando SAF para el directorio $list_name"
./Tools/ANGSD/angsd/angsd -b $o_file -anc Input_files/Ancestral_sequence/chimpHg19.fa.gz -out Output_files/$list_name -dosaf 1 -gl 1 -P 10
