#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    maestro_somatico.sh <RAW> <INT> <RGID> <RGLB> <RGPU> <nt> [<q> <l> <PREV>]
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
            <q>: Calidad minima en scala phred para mantener en el
                 analisis (default 30)
            <l>: Longitud de lectura para conservar en el mapeo
                 (default 70)
         <PREV>: Ruta del directorio donde se encuentran
                 los directorios con corridas pasadas (default NULL)
ejemplo:
    ./maestro_PerLane_somatico.sh /home/user/datosCrudos /home/user/proyecto/datosIntermedios EXPERIMENTO haloplex GAII /home/user/file.bed 8"
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


if [ -z ${11+x} ]
 then echo "no se tomaran corridas previas"
 else echo "Se tomaran corridas previas de '${1}'"
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
	echo INICIO: merger muestral
	echo ./mergerBYsample.sh $2
	./mergerBYsample.sh $2
##### Bloque de codigo para tomar en cuenta otras corridas
	if [ -z ${11+x} ]
		then
			echo "Se corre de manera normal"
		else 
			echo INICIO: merger previos
			echo ./mergerPrevios.sh $2/bySAMPLE ${11}
			./mergerPrevios.sh $2/bySAMPLE ${11}
	fi
####
	echo INICIO: realineador
	echo ./realineador_para_haloplex.sh $2/bySAMPLE $8
	./realineador_para_haloplex.sh $2/bySAMPLE $8
	echo INICIO: recalibrador
	echo ./recalibrador.sh $2/bySAMPLE $8
	./recalibrador.sh $2/bySAMPLE $8
	echo INICIO: mutect
	echo ./llamadorMuTect.sh $2/bySAMPLE Xmx4g $7 $8
	./llamadorMuTect.sh $2/bySAMPLE Xmx4g $7 $8
	echo INICIO: pindel
	echo  ./llamadorPindel.sh $2/bySAMPLE $8
	./llamadorPindel.sh $2/bySAMPLE $8
	echo INICIO: combinador
	echo ./mergerPindelMutect.sh $2/bySAMPLE $8
	./mergerPindelMutect.sh $2/bySAMPLE $8
	if [ -z ${11+x} ]
	        then
	            	echo "No se copia a base de datos"
	        else
			echo INICIO: copiador
			echo ./copiaAprevios.sh $2/bySAMPLE ${11} $4
			./copiaAprevios.sh $2/bySAMPLE ${11} $4
	fi
else
	cd $actual
	echo SE INICIARA EL PROTOCOLO SIN SEPARACION POR CARRIL 
        echo INICIO: filtrador
	echo ./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
        ./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
        echo INICIO: mapeador
	echo ./mapeador2.sh $2 $8 $4 $5 $6
        ./mapeador.sh $2 $8 $4 $5 $6
##### Bloque de codigo para tomar en cuenta otras corridas
        if [ -z ${11+x} ]
                then
                        echo "Se corre de manera normal"
                else
                        echo INICIO: merger previos
			echo ./mergerPrevios.sh $2 ${11}
                        ./mergerPrevios.sh $2 ${11}
        fi
####    
        echo INICIO: realineador
	echo ./realineador_para_haloplex.sh $2 $8
        ./realineador_para_haloplex.sh $2 $8
        echo INICIO: recalibrador
	echo ./recalibrador.sh $2 $8
        ./recalibrador.sh $2 $8
        echo INICIO: mutect
	echo ./llamadorMuTect.sh $2 Xmx4g $7 $8
        ./llamadorMuTect.sh $2 Xmx4g $7 $8
        echo INICIO: pindel
	echo ./llamadorPindel.sh $2 $8
        ./llamadorPindel.sh $2 $8
        echo INICIO: combinador
	echo ./mergerPindelMutect.sh $2 $8
        ./mergerPindelMutect.sh $2 $8
        if [ -z ${11+x} ]
                then
                        echo "No se copia a base de datos"
                else
                        echo INICIO: copiador
			echo ./copiaAprevios.sh $2 ${11} $4
                        ./copiaAprevios.sh $2 ${11} $4
        fi
fi	
date

