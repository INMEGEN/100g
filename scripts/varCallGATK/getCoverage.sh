#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    getCoverage.sh <DIR> <intervals>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras
    <intervals>: archivo tipo BED para calcular la cobertura
                 para obtenerlo mediante el script bed2intervalsGATK.pl
ejemplo:
    ./getCoverage.sh /home/user/proyecto/datosIntermedios /home/files/panel.intervals"
        exit
fi

WORKdir=$1
actual=`pwd`
cd $WORKdir
echo -e Sample'\t'Coverage'\t'MeanDepth > coverage.txt
for h in $(ls); do
	if [ -d "$h" ]
	then
		cd $h
		pwd
	
		java -jar $GATKdir/GenomeAnalysisTK.jar -T BaseCoverageDistribution -R $REF/hg19.fa -I aln_recaled2.bam -L $2 -fd -o report.grp
		R --slave --vanilla --args report.grp coverage.png < $actual/rscripts/coverageDepthGATK.R
		
	        cd ..
	fi
done 

