#!/bin/bash

##### PARALELIZANDO DELLY2
export OMP_NUM_THREADS=5
#env
###Arreglo para declarar eventos a detectar, de acuerdo a las opciones que da delly por default.
Eventos=($1)

if [ ! -d Output_files/delly ]; then
mkdir Output_files/delly
fi

echo "[] Output_files/delly/ presente"

for n_batch in Input_files/BAMs/Batch_*
do
batch_number=$(echo $n_batch | cut -d"/" -f3 | cut -d"." -f1)
#echo $batch_number

for SVtype in "${Eventos[@]}"
do

	if [ ! -d Output_files/delly/$SVtype ]; then
	mkdir Output_files/delly/$SVtype
	fi

echo "[ ]Detectando "$SVtype" en batches." 

		#for f in /labs/100g/SVs/BAMs_for_testing/$batch_number/*/*.bam
		#do
		#	ID=$(echo $f | cut -d"/" -f7 | cut -d"." -f1 | cut -d"_" -f1)
		#	sample=$sample"_"$ID

		#done

sample=$(cat $n_batch | tr " " "\n" | cut -d"/" -f7 | tr "\n" "_")

		echo "[>] Detectando "$SVtype" para "$sample
		batch_bcf="Output_files/delly/"$SVtype"/"$batch_number".mdelly."$SVtype".bcf"

#echo TEST > $batch_bcf
file_call=$(cat $n_batch)
./Tools/delly/src/delly call -t $SVtype -g Input_files/resources/reference/human_g1k_v37_decoy.fasta -o $batch_bcf $file_call


#		sample=""	##resetear la variable para no duplicar nombres en los archivos de salida.

done	##Termina el tipo de SV

echo "[>>] $batch_number analizado con Delly2"

done	##Termina el batch

##for SVtype in "${Eventos[@]}"
##do

##echo "[>>]Collapsando $SVtype para todos los batches."

###AQUI ABAJO SE CONFIGURAN PARAMETROS IMPORTANTES COMO m=LONGITUD MINIMA DEL EVENTO, -n=LONGITUD MAXIMA, ETC. revisar el manual de DELLY2 para entenderlos
##./Tools/delly/src/delly merge -t $SVtype -m 500 -n 1000000 -o "Output_files/delly/collapsed.delly."$SVtype".bcf" -b 500 -r 0.7 "Output_files/delly/"$SVtype"/"*".mdelly."$SVtype".bcf" 

##done
