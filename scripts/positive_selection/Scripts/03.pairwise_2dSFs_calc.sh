#!/bin/bash

#### $1 is the input file that should be Output_files/ANGSD_SAF/n.POP.chrN.vcf.saf.idx
#### $2 is the number of core procesors to use

### Store the different populations present in Output_files/ANGSD_SAF/ that can be compared with input files

n_samples=$(echo $1 | cut -d"/" -f3 | cut -d"." -f1)
i_folder=$(echo $1 | cut -d"/" -f1,2)
chromosome=$(echo $1 | cut -d"/" -f3 | cut -d"." -f3)
f_ext=$(echo $1 | cut -d"/" -f3 | cut -d"." -f4-)
track_file=temp/sdsfs_pairwise_tracking

###CREATING FILE FOR TRACKING PAIRWISE CALCULATIONS
touch $track_file
#echo $n_samples
#echo $i_folder
#echo $chromosome
#echo $f_ext

A_populations=( $(ls $i_folder/$n_samples.*.$chromosome.$f_ext | tr "\n" " ") )

for APOP in "${A_populations[@]}"
do
	A_name=$(echo $APOP | cut -d"/" -f3 | cut -d"." -f1-3)

	B_populations=( $(ls $i_folder/$n_samples.*.$chromosome.$f_ext | grep -wv $APOP | tr "\n" " ") )

	for BPOP in "${B_populations[@]}"
	do
	B_name=$(echo $BPOP | cut -d"/" -f3 | cut -d"." -f1-3)

	previous_check=$(grep -wc $A_name$B_name $track_file)

	if [ $previous_check -eq 0 ]
	then
		echo "[>]Calculating 2dsfs for $A_name vs $B_name"
		echo $A_name$B_name >> $track_file
		echo $B_name$A_name >> $track_file

	###CALCULATE PAIRWISE 2DSFS
	./Tools/ANGSD/angsd/misc/realSFS $APOP $BPOP -P $2 > Output_files/ANGSD_2dSFS/$A_name.$B_name.ml
###	touch Output_files/ANGSD_2dSFS/$A_name.$B_name.ml ###DEBUGGIN
	fi

	done
##	echo "[>>]Finished pairwise 2dsfs calculations for $A_name"
done

rm temp/* ##DEBUGGIN
