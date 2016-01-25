#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    filtradorAllcarpet.sh <IN> <OUT> <secuenciador>
donde:
           <IN>: direccion del directorio donde se encuentran 
                 los archivos de lecturas crudas
          <OUT>: direccion del directorio donde se depositaran
                 los archivos con lecturas filtradas
 <secuenciador>: tipo de secuenciador usado para generar las 
                 lecturas
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./filtradorAllcarpet.sh /home/user/proyecto/datosCrudos /home/user/proyecto/datosIntermedios MiSeq"
        exit
fi



#abortar()
#{
#if [ $1 -eq 0 ]
#then
#	echo Proceso exitoso
#else
#	echo Proceso con ERROR abortando con salida 1
#	exit 1
#fi
#}

WORKdir=$1
WORKout=$2
if [ $3 = "MiSeq" ];
then
	adapter="TruSeq3-PE.fa"
else
	adapter="TruSeq2-PE.fa"
fi

cd $WORKdir
###prueba
for i in $(ls | rev | cut -d '_' -f5- | rev | uniq)
##-f5- sirve para quitar _muestraID_LaneID_readID(fwd-rvs)_IDdesconocido.fastq.gz
do
	if [ -d $WORKout/Sample_$i ];
	then
		echo ya existe $WORKout/Sample_$i
	else
		mkdir $WORKout/Sample_$i
	fi
	if [ -f $WORKout/Sample_$i/u2.fastq.gz ];
	then
		echo ya se ha procesado $WORKout/Sample_$i
	else
		j=`ls | grep ${i}_ | grep R1`
		k=`ls | grep ${i}_ | grep R2`
#Se modifico a ${i}_ para separar 1 de 10 

		$FASTQCdir/fastqc -t $4 $j $k

		java -jar $TRIMdir/trimmomatic-0.33.jar PE $j $k p1.fastq.gz u1.fastq.gz p2.fastq.gz u2.fastq.gz ILLUMINACLIP:$ADAPT/$adapter:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:$5 MINLEN:$6
#		abortar $?
		mv *fastqc* $WORKout/Sample_$i
		mv p*fastq.gz $WORKout/Sample_$i
		mv u*fastq.gz $WORKout/Sample_$i
	fi
#cd ..
done 
