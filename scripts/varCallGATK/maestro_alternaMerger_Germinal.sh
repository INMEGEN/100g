#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    maestro_somatico.sh <PREV> <INT> <RGID> <RGLB> <RGPU> <nt> [<q> <l> <PREV>]
donde:
         <PREV>: Ruta del directorio donde se encuentran 
                 los directorios con corridas pasadas
          <INT>: Ruta del directorio donde se depositaran
                 los archivos intermedios
         <RGID>: Read Group ID, se sugiere utilizar el nombre del
                 experimento
          <BED>: Archivo bed del panel utilizado
           <nt>: Cantidad de nucleos a utilizar

ejemplo:
    ./maestro_somatico.sh /home/user/datosCrudos /home/user/proyecto/datosIntermedios EXPERIMENTO haloplex GAII /home/user/file.bed 8"
        exit
fi

date


##### Bloque de codigo para tomar en cuenta otras corridas
echo INICIO: merger
./mergerPrevios.sh $2 $1
####
echo INICIO: realineador
./realineador.sh $2 $5
echo INICIO: recalibrador
./recalibrador.sh $2 $5
echo INICIO: llamador
./llamadorHC_gvcf.sh $2 Xmx4g $4 $5
echo INICIO: genotipificador
./genotipeadorGVCF.sh $2 $5
echo INICIO: copiador
./copiaAprevios.sh $2 $1 $3

date

