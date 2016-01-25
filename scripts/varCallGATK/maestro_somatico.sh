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
    ./maestro_somatico.sh /home/user/datosCrudos /home/user/proyecto/datosIntermedios EXPERIMENTO haloplex GAII /home/user/file.bed 8"
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
 else echo "Se tomaran corridas previas de '$1'"
fi


echo INICIO: filtrador
./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
echo INICIO: mapeador
./mapeador.sh $2 $4 $5 $6 $8
##### Bloque de codigo para tomar en cuenta otras corridas
if [ -z ${11+x} ]
	then
		echo "Se corre de manera normal"
	else 
		echo INICIO: merger
		./mergerPrevios.sh $2 ${11}
fi
####
echo INICIO: realineador
./realineador_para_haloplex.sh $2 $8
echo INICIO: recalibrador
./recalibrador.sh $2 $8
echo INICIO: mutect
./llamadorMuTect.sh $2 Xmx4g $7 $8
echo INICIO: pindel
./llamadorPindel.sh $2 $8
echo INICIO: combinador
./mergerPindelMutect.sh $2 $8
if [ -z ${11+x} ]
        then
            	echo "No se copia a base de datos"
        else
		echo INICIO: copiador
		./copiaAprevios.sh $2 ${11} $4
fi

date

