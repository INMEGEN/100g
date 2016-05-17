#! /bin/bash

REF="/home/inmegen/r.garcia/100g/references/GRCh37/genome"
#FASTQCdir="/home/shared/bin/FastQC"
GATKdir="/home/inmegen/r.garcia/src/GATK"
GATK35dir="/home/inmegen/r.garcia/src/GATK_3.5"
SNPEFFdir="/home/inmegen/r.garcia/src/snpEff"
SNPEFFconfig="/home/inmegen/r.garcia/100g/snpEff"
#TRIMdir="/home/shared/bin/Trimmomatic-0.33"
VAR="/home/inmegen/r.garcia/100g/references/GRCh37/genome"
VARIANTS="/home/inmegen/r.garcia/100g/references/GRCh37/genome"
#ADAPT="/home/shared/bin/Trimmomatic-0.33/adapters"
PICARDdir="/home/inmegen/r.garcia/src/picard/picard-tools-1.89"
#phastConsDIR="/home/shared/referencias/phastCons46"
#CANCER="/home/shared/referencias/cancer"
TABIXdir="/home/inmegen/r.garcia/src/samtools-1.2/htslib-1.2.1"
IGVdir="/home/inmegen/r.garcia/src/IGVTools"
perlDIR=`pwd`
perlDIR=${perlDIR}/perls

exit_trap () {
  local lc="$BASH_COMMAND" rc=$?
  echo "El comando [$lc] tuvo una salida con codigo [$rc]"
}

trap exit_trap EXIT
set -e

