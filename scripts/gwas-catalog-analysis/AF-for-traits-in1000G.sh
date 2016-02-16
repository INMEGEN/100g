
##Script to get the Allele frequency in the 1000 genome project, using the file /scratch/inmegen/100g/references/1000g-phase_3-allele-frequency/1000GENOMES-phase_3.vcf.gz previously indexed by Tabix.
##The script take a list of cordinates variants in tab format: "chr corrd rsdbSNP"
##tabix program have to be imported to de $PATH

#1000G project file with AF
GP="/scratch/inmegen/100g/references/1000g-phase_3-allele-frequency/1000GENOMES-phase_3.vcf.gz"

#Definging the variables for input -i and output -o files to use with getopts

usage() { echo "Usage: $0 -i [List of variants with tabular format: "chr corrdenate rsdbSNP"] -o [output file]" 1>&2; exit 1; }

while getopts ":i:o:" op; do
    case "${op}" in
        i)
            i=${OPTARG}
            ;;
	o)
	   out=${OPTARG}
	    ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${out}" ]; then
    usage
fi

echo "input = ${i}"
echo "output wiil be writen into: ${out}"

#Getting the coordinates with tabix
IFS='
'
printf "chr\tpos\trs\tAMR\tEAS\tSAS\tEUR\tAFR\n" > $out
for q in $(cat $i)
do
chr=$(echo "$q" | cut -f 1)
pos=$(echo "$q" | cut -f 2)
rs=$(echo "$q" | cut -f 3)
t=$(tabix $GP ${chr}:${pos}-${pos})
EAS=$(echo $t | awk 'BEGIN{FS="EAS_AF="} {print $2}' | cut -d ";" -f 1)
AFR=$(echo $t | awk 'BEGIN{FS="AFR_AF="} {print $2}' | cut -d ";" -f 1)
EUR=$(echo $t | awk 'BEGIN{FS="EUR_AF="} {print $2}' | cut -d ";" -f 1)
SAS=$(echo $t | awk 'BEGIN{FS="SAS_AF="} {print $2}' | cut -d ";" -f 1)
AMR=$(echo $t | awk 'BEGIN{FS="AMR_AF="} {print $2}' | cut -d ";" -f 1)
printf "$chr\t$pos\t$rs\t$AMR\t$EAS\t$SAS\t$EUR\t$AFR\n"
done >> $out

