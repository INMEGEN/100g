#! /bin/bash

source config.sh
if [ $# -lt 2 ];
then
        echo "uso:
    maestro_PerLane_amerindio.sh <INT> <nt>
donde:
          <INT>: Ruta del directorio donde se depositaran
                 los archivos intermedios
            <nt>: Cantidad de nucleos a utilizar

ejemplo:
    ./maestro_PerLane_amerindio.sh /home/user/datosIntermedios 6"
        exit
fi

date

#if [ -z ${9+x} ]
# then
#	echo "se usara 30 como calidad minima"
#	qual=30
# else
#	echo "se usara $9 como calidad minima"
#	qual=$9
#fi
#if [ -z ${10+x} ]
# then
#	echo "se usaran lecturas de mas de 70 nucleotidos"
#	long=70
# else
#	echo "se usaran lecturas de mas de ${10} nucleotidos"
#	long=${10}
#fi

#let suma=1
#actual=`pwd`
#cd $1
#
#for i in $(ls)
#do
#	if [ -d "$i" ]
#	then
#		let suma+=1
#	fi
#done
#
#if [ $suma -gt 1 ]
#then
#	cd $actual
#	echo SE INICIARA EL PROTOCOLO DE SEPARACION POR CARRIL 
#	echo INICIO: filtrador
#	echo ./filtradorSameSample.sh $1 $2 $3 $8 $qual $long
#	./filtradorSameSample.sh $1 $2 $3 $8 $qual $long
#	echo INICIO: mapeador
#	echo ./mapeador2.sh $2 $8 $4 $5 $6
#	./mapeador3_bamInit.sh $2 $8 $4 $5 $6
##	echo INICIO: merger
#	echo ./mergerBYsample.sh $2
#	./mergerBYsample.sh $2
#	echo INICIO: realineador
#	echo ./realineador.sh $2/bySAMPLE $8
#	./realineador.sh $2/bySAMPLE $8
#	echo INICIO: recalibrador
#	echo ./recalibrador.sh $2/bySAMPLE $8
#	./recalibrador.sh $2/bySAMPLE $8
#	echo INICIO: llamador
#	echo ./llamadorHC_gvcf.sh $2/bySAMPLE Xmx4g $7 $8
#	./llamadorHC_gvcf.sh $2/bySAMPLE Xmx4g $7 $8
#	echo INICIO: genotipificador
#	echo ./genotipeadorGVCF.sh $2/bySAMPLE $8
#	./genotipeadorGVCF.sh $2/bySAMPLE $8
#else
#	cd $actual
#	echo SE INICIARA EL PROTOCOLO SIN SEPARACION POR CARRIL
#	echo INICIO: filtrador
#	echo ./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
#	./filtradorAllcarpet.sh $1 $2 $3 $8 $qual $long
#	echo INICIO: mapeador
#	echo ./mapeador2.sh $2 $8 $4 $5 $6
#	./mapeador3_bamInit.sh $2 $8 $4 $5 $6
	echo INICIO: realineador
	echo ./realineador_AMERINDIO.sh $1 $2
	./realineador_AMERINDIO.sh $1 $2
	echo INICIO: recalibrador
	echo ./recalibrador.sh $1 $2
	./recalibrador.sh $1 $2
	echo INICIO: llamador
	echo ./llamadorHC_gvcf.sh $1 Xmx16g ALLGENOME $2
	./llamadorHC_gvcf.sh $1 Xmx16g ALLGENOME $2
#	echo INICIO: genotipificador
#	echo ./genotipeadorGVCF.sh $1 $2
#	./genotipeadorGVCF.sh $1 $2
#fi
date

