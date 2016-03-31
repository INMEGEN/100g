##Script to get the allele frequency for a list o variants. Taking care of the same variant allele. 
#It requires the program Tabix imported to the PATH

use strict;
#Input file
my $IN = "/scratch/inmegen/100g/wg_GATK/SNVs-Allefrequency-0.05.txt";

#File that contains the allele frequency, for each variant in the 1000 Genome project.
my $GP = "/scratch/inmegen/100g/references/1000g-phase_3-allele-frequency/1000GENOMES-phase_3-hg19.vcf.gz";

#Output file
my $OUT = "/scratch/inmegen/100g/wg_GATK/SNVs-Allefrequency-0.05-1000GP.txt";

#Defining variables
my ($line,$ref,$alt,$pos,$chr,$IAF,$var,$AFR_AF,$EAS_AF,$SAS_AF,$AMR_AF,$EUR_AF,$rs);
my (@aux,@varsGP);

#Output file creation
open (OUT,">$OUT") || die "No puedo crear el archivo de salida $OUT \n";
print OUT "CHR\tPOS\trs-dbSNP144\tREF\tALT\t94g_AF\tAFR_AF\tEUR_AF\tSAS_AF\tEAS_AF\tAMR_AF\n";

#Open input file, and reading each line
open(INN,"$IN") || die "No puedo abrir el archivo $IN\n";
while(<INN>){
$line = $_;
chomp($line);
if ($line =~ /^Chr/){
    next;
}

@aux = split(/\t+/,$line);
$chr = $aux[0];
$pos = $aux[1];
$ref = $aux[2];
$alt = $aux[3];
$IAF = $aux[4];

#Finding the corresponding region by Tabix
@varsGP = ();
my $panter = 0;
@varsGP = `tabix $GP ${chr}:${pos}-${pos}`;

#The same ragion can have multiple variants, each one is compared to the line input
if (@varsGP){
foreach (@varsGP){
 $var = $_;
 chomp($var);
 @aux = split(/\t+/,$var);
 if ($aux[3] eq $ref && $aux[4] eq $alt){
     $AFR_AF=(split(/AFR_AF=/,$var))[1];
     $AFR_AF=(split(/;/,$AFR_AF))[0];
     $EUR_AF=(split(/EUR_AF=/,$var))[1];
     $EUR_AF=(split(/;/,$EUR_AF))[0];
     $SAS_AF=(split(/SAS_AF=/,$var))[1];
     $SAS_AF=(split(/;/,$SAS_AF))[0];
     $EAS_AF=(split(/EAS_AF=/,$var))[1];
     $EAS_AF=(split(/;/,$EAS_AF))[0];
     $AMR_AF=(split(/AMR_AF=/,$var))[1];
     $AMR_AF=(split(/;/,$AMR_AF))[0];
     $rs = $aux[2];
     print OUT "$chr\t$pos\t$rs\t$ref\t$alt\t$IAF\t$AFR_AF\t$EUR_AF\t$SAS_AF\t$EAS_AF\t$AMR_AF\n";
 }
}
}
}
close(INN);
