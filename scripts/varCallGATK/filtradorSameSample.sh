#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    filtradorSameSample.sh <IN> <OUT> <secuenciador>
donde:
           <IN>: direccion del directorio donde se encuentran 
                 los archivos de lecturas crudas
          <OUT>: direccion del directorio donde se depositaran
                 los archivos con lecturas filtradas
 <secuenciador>: tipo de secuenciador usado para generar las 
                 lecturas
           <nt>: cantidad de nucleos a utilizar
ejemplo:
    ./filtradorSameSample.sh /home/user/proyecto/datosCrudos /home/user/proyecto/datosIntermedios GAII"
        exit
fi


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
for h in $(ls); do
	if [ -d "$h" ];
	then
	cd $h
		for i in $(ls | grep fastq | cut -d '_' -f1,3 | uniq); do
			if [ -d $WORKout/Sample_$i ];
			then
				echo ya existe $WORKout/Sample_$i
			else
				mkdir $WORKout/Sample_$i
			fi
			if [ -f $WORKout/Sample_$i/u2.fastq.gz ];
			then
				echo ya se ha procesado Sample_$i
			else
				mm=`echo $i | cut -d '_' -f2`
				m=`ls | cut -d '_' -f1-3 | uniq | grep $mm`
#			echo $m
				j=`ls | grep $m | grep R1`
				k=`ls | grep $m | grep R2`
				$FASTQCdir/fastqc -t $4 $j $k
#			fastqc $j $k
				java -jar $TRIMdir/trimmomatic-0.33.jar PE $j $k p1.fastq.gz u1.fastq.gz p2.fastq.gz u2.fastq.gz ILLUMINACLIP:$ADAPT/$adapter:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:$5 MINLEN:$6
				mv *fastqc* $WORKout/Sample_$i
				mv p*fastq.gz $WORKout/Sample_$i
				mv u*fastq.gz $WORKout/Sample_$i
			fi
		done
		cd ..
	fi
done 
