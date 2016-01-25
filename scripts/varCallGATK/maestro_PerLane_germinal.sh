#! /bin/bash

source config.sh
if [ $# -lt 8 ];
then
        echo "uso:
    maestro_PerLane_germinal.sh <RAW> <INT> <secuenciador> <RGID> <RGLB> <RGPU> <BED> <nt> [<q>] [<l>]
donde:
          <RAW>: Ruta del directorio donde se encuentran 
                 los directorios de muestras crudas
          <INT>: Ruta del directorio donde se depositaran
                 los archivos intermedios
 <secuenciador>: Nombre del secuenciador
         <RGID>: Read Group ID, se sugiere utilizar el nombre del
                 experimento
         <RGLB>: Read Group Library, se sugiere utilizar el nombre
                 del kit de la libreria
         <RGPU>: Read Group Process Unit, se sugiere utilizar el
                 nombre del equipo utilizado para la secuenciacion
          <BED>: Archivo bed del panel utilizado
           <nt>: Cantidad de nucleos a utilizar
            <q>: Calidad minima de corte en el procesamiento en escala
                 Phred (default = 30)
            <l>: Longitud minima de las lecturas que pasan los filtros
                 para conservarse en el alineamiento (default = 70)
ejemplo:
    ./maestro_PerLane_germinal.sh /home/user/datosCrudos /home/user/datosIntermedios MiSeq EXPERIMENTO haloplex GAII /home/user/file.bed 6"
        exit
fi

date

if [ -z ${9+x} ]
 then
	echo "se usara 30 como calidad minima"
	qual=30
 else
	echo "se usara $9 como calidad minima"
	qual=$9
fi
if [ -z ${10+x} ]
 then
	echo "se usaran lecturas de mas de 70 nucleotidos"
	long=70
 else
	echo "se usaran lecturas de mas de ${10} nucleotidos"
	long=${10}
fi

let suma=0
actual=`pwd`
cd $1

for i in $(ls)
do
	if [ -f "$i" ]
	then
		let bandera=1
	else
		let bandera=0
	fi
	let suma=$suma+$bandera
done
if [ $suma -lt $(ls | wc -l) ]
then
	cd $actual
	echo SE INICIARA EL PROTOCOLO DE SEPARACION POR CARRIL 
	echo INICIO: filtrador
	echo ./filtradorSameSample.sh $1 $2 $3 $8 $qual $long
	./filtradorSameSample.sh $1 $2 $3 $8 $qual $long
	echo INICIO: mapeador
	echo ./mapeador2.sh $2 $8 $4 $5 $6
	./mapeador2.sh $2 $8 $4 $5 $6
	echo INICIO: merger
	echo ./mergerBYsample.sh $2
	./mergerBYsample.sh $2
	echo INICIO: realineador
	echo ./realineador.sh $2/bySAMPLE $8
	./realineador.sh $2/bySAMPLE $8
	echo INICIO: recalibrador
	echo ./recalibrador.sh $2/bySAMPLE $8
	./recalibrador.sh $2/bySAMPLE $8
	echo INICIO: llamador
	echo ./llamadorHC_gvcf.sh $2/bySAMPLE Xmx4g $7 $8
	./llamadorHC_gvcf.sh $2/bySAMPLE Xmx4g $7 $8
	echo INICIO: genotipificador
	echo ./genotipeadorGVCF.sh $2/bySAMPLE $8
	./genotipeadorGVCF.sh $2/bySAMPLE $8
else
	cd $actual
	echo SE INICIARA EL PROTOCOLO SIN SEPARACION POR CARRIL
	echo INICIO: filtrador
	echo ./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
	./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
	echo INICIO: mapeador
	echo ./mapeador2.sh $2 $8 $4 $5 $6
	./mapeador2.sh $2 $8 $4 $5 $6
	echo INICIO: realineador
	echo ./realineador.sh $2 $8
	./realineador.sh $2 $8
	echo INICIO: recalibrador
	echo ./recalibrador.sh $2 $8
	./recalibrador.sh $2 $8
	echo INICIO: llamador
	echo ./llamadorHC_gvcf.sh $2 Xmx4g $7 $8
	./llamadorHC_gvcf.sh $2 Xmx4g $7 $8
	echo INICIO: genotipificador
	echo ./genotipeadorGVCF.sh $2 $8
	./genotipeadorGVCF.sh $2 $8
fi
date

