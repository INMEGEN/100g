#! /bin/bash

GUIdir=$(dirname $(readlink -f $0)) ;
cd $GUIdir

if [ $# -eq 0 ];
then
        echo "ESTIMACION DE METRICAS DE COBERTURA Y PROFUNDIDAD EN PANEL

 Script utilizado para obtener medidas especificas de la calidad de secuenciacion en una
corrida analizada. Este script depende de GATK e invoca la ejecucion de scripts de R para
hacer los ultimos calculos y graficas.

 Es requerida la previa ejecucion de un pipeline de deteccion, al menos hasta el punto de
recalibracion de calidad de bases, ya que la entrada de este proceso son los alineamientos
procesados de lecturas con el nombre comun -aln_recaled2.bam-. El output es un archivo 
-coverage.txt- el cual contiene la informacion resumida de cobertura y profundidad 
promedio de region del panel en cada muestra de la corrida. Adicionalmente se obtiene una 
imagen en formato png con la informacion de cada region en cada muestra, esta imagen posee
el prefijo -cov_- seguido del nombre de la muestra en cuestion y el sufijo -.png-. La
forma en la que esta construido el script permite hacer un procesamiento paralelo de cada
region, sin embargo se debe de cuidar que la cantidad de nucleos a utilizar sea menor a la
cantidad de nucleos disponibles y ser de preferencia un numero par o divisor de la cantidad
de regiones.

 El archivo de regiones debe construirse a partir de un archivo bed mediante el script de
perl bed2intervalsGATK.pl que tambien es parte del paquete.

uso:
    panelCoverage.sh <DIR> <intervals> <nt>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
    <intervals>: archivo tipo BED para calcular la cobertura
                 para obtenerlo mediante el script 
                 bed2intervalsGATK.pl
           <nt>: cantidad de nucleos a utilizar

ejemplo:
    ./panelCoverage.sh /home/user/proyecto/datosIntermedios /home/files/panel.intervals 6"
        exit
fi

## Ejecucion mediante source
#source config.sh
#El source mata el paralelismo por la salida 1 de cada prueba en el modulo
cat <(awk '/^#/,/^exec 1/' config.sh ) <(awk '/echo \"Proce/,/EOF/' config.sh) > tmp_config.sh
source tmp_config.sh $1 PCOV

## Definicion de variables y moverse a directorio de las muestras
N=$3
WORKdir=$1
actual=`pwd`
cd $WORKdir

## Recorrer los directorios muestrales
for h in $(ls); do
	if [ -d "$h" ]
	then
		cd $h
		echo Procesando muestra $h
#### Crear el encabezado del archivo final
		echo -e Sample'\t'Coverage'\t'MeanDepth > coverage.txt
		pwd

#### Recorrer las regiones
		for i in $(cat $2); do

##### Se ejecuta de manera paralela hasta alcanzar el numero de nucleos a utilizar
			((j=j%N)); ((j++==0)) && wait

##### Obtencion de cada metrica en cada intervalo
			(java -jar $GATKdir/GenomeAnalysisTK.jar -T BaseCoverageDistribution -R $REF/hg19.fa -I aln_recaled2.bam -L $i -fd -o ${i}.grp && R --slave --vanilla --args ${i}.grp < $actual/rscripts/panelCoverageDepthGATK.R && rm ${i}.grp && echo $i ) &
		done

#### Generar la grafica de la muestra con sus regiones
		R --slave --vanilla --args coverage.txt cov_${h}.png < $actual/rscripts/graficaProfundidadPanel.R
	        cd ..
	fi
done 

cd $actual
rm tmp_*

