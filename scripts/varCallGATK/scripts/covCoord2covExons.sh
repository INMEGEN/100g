#! /bin/bash

GUIdir=$(dirname $(readlink -f $0)) ;
cd $GUIdir

if [ $# -eq 0 ];
then
        echo "CAMBIO A EXONES DE LOS CALCULOS DE PROFUNDIDAD

 Script utilizado para obtener medidas especificas de la calidad de secuenciacion en una
corrida analizada. Este script depende de GATK e invoca la ejecucion de scripts de R para
hacer los ultimos calculos y graficas.

 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam a elit accumsan, pretium
felis in, feugiat nibh. Suspendisse quis massa purus. Etiam eleifend elit sit amet
porttitor tempor. Etiam condimentum semper molestie. Vivamus rutrum porta ligula. Donec
non porttitor ante. Donec pretium in sem et rhoncus. Morbi et ligula et arcu pharetra
vulputate. Donec quis tincidunt lectus. Nam mollis dolor sed nisl viverra consectetur.
Aliquam ut pellentesque felis. Integer commodo ligula et faucibus euismod. Phasellus
ullamcorper massa ullamcorper mattis tempor. Mauris nec faucibus orci, at vulputate enim.
In tristique, sem ut accumsan egestas, nisl nulla euismod dui, eu scelerisque mi ex non
massa.

Integer interdum augue porta scelerisque pellentesque. Aenean varius mollis arcu. In
efficitur a mauris sed volutpat. Donec blandit ipsum diam. Quisque fringilla hendrerit
leo quis vestibulum. Morbi nisi erat, mollis ut semper in, dignissim at tellus. Etiam et
nisl at est tincidunt tincidunt. Curabitur sit amet maximus eros. Nulla ac massa
volutpat, volutpat dui eu, consectetur nulla. Nullam vulputate nisl nibh, eget fermentum
nisl lobortis nec. Vestibulum non sodales urna.

 El archivo de regiones debe construirse a partir de un archivo bed mediante el script de
perl bed2intervalsGATK.pl que tambien es parte del paquete.

uso:
    covCoord2covExons.sh <DIR> <exons>
donde:
          <DIR>: direccion del directorio donde se encuentran
                 los directorios de muestras
        <exons>: archivo BED para calcular la cobertura por exon
                 obtenido de UCSC

ejemplo:
    ./covCoord2covExons.sh /home/user/proyecto/datosIntermedios /home/files/beds/exons.bed"
        exit
fi

## Ejecucion mediante source
source config.sh $1 CCCE

## Definicion de variables y moverse a directorio de las muestras
WORKdir=$1
cd $WORKdir

## Recorrer los directorios muestrales
for h in $(ls); do
	if [ -d "$h" ]
	then
		cd $h
		echo Procesando muestra $h
		cut -f 1,3 coverage.txt > allDepths_2.txt
		tail -n +2 allDepths_2.txt | cut -d "." -f 1 | sed "s/[:|-]/\t/g" | sort > sorted_all.bed
		bedtools closest -a sorted_all.bed -b $2 > all_exons.bed
		perl $perlDIR/cambiaNombre.pl all_exons.bed allDepths_2.txt > exonDepths.txt
		echo -e "CROMOSOMA\tINTERVALO\tGEN\tEXON\tPROFUNDIDAD" > exon_orderedDepths.tsv
		perl $perlDIR/ordenadorJerarquiColumna.pl exonDepths.txt $perlDIR/ordenChr.txt >> exon_orderedDepths.tsv
		rm allDepths_2.txt sorted_all.bed all_exons.bed exonDepths.txt
		cd ..
	fi
done

