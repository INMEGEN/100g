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
ejemplo:
    ./filtradorAllcarpet.sh /home/user/proyecto/datosCrudos /home/user/proyecto/datosIntermedios MiSeq"
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
for i in $(ls | rev | cut -d '_' -f4- | rev | uniq)
do
	mkdir $WORKout/Sample_$i
	j=`ls | grep $i | grep R1`
	k=`ls | grep $i | grep R2`
	jj=$(basename $j .gz)
	kk=$(basename $k .gz)
#	gunzip $j
#	dos2unix $jj
#	gzip $jj
#	gunzip $k
#	dos2unix $kk
#	gzip $kk
	$FASTQCdir/fastqc $j $k
	java -jar $TRIMdir/trimmomatic-0.33.jar PE $j $k p1.fastq.gz u1.fastq.gz p2.fastq.gz u2.fastq.gz ILLUMINACLIP:$ADAPT/$adapter:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:30 MINLEN:70
	mv *fastqc* $WORKout/Sample_$i
	mv p*fastq.gz $WORKout/Sample_$i
	mv u*fastq.gz $WORKout/Sample_$i
#cd ..
done 
