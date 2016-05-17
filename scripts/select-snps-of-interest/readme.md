This folder contains scripts to get the allele frequency for each variant in the 95g, select only the variants with high allele frequency and get the allele frequency for each selected variant in the 1000 genome project. Scripts are enumerated in order of execution:


 1. *get-snps.pl* : Script to get the allele frequency for each snv in a multisample VCF then print in to a file only the snvs that pass an frequency threshold.
 2. *paste-AF-from-1000G.pl* : From a list of snv variants, search in the VCF of the 1000 GP the allele frequency for each variant.
 3. *paste-AF-from-1000G.sh* : Script to split and input list of snv possitions, an run in parallele the *paste-AF-from-1000G.pl* script.
 4. *run-script.sh* Script that contains the commands for execution of the previous scripts.

