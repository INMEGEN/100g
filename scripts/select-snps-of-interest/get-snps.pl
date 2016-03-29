#Script to get the variants with higth Allele frequency from multi-individual-VCF.
#The criterion for "higth Allele frequency" can be modified below

use strict;

#input vcf-file
my $INPUT = "/scratch/inmegen/100g/wg_GATK/test3/allsamples_final_recaled_snp-indel.vcf";
#Allele frequency cutoff
my $EAF=0.05;
#output file
my $OUT = "/scratch/inmegen/100g/wg_GATK/SNVs-Allefrequency-0.05.txt";
open (OUT, ">$OUT") || die "No puedo crear el archivo $OUT\n";
print OUT "Chr\tPOS\tREF\tALT\tAF\n";

my ($line,$i,$genotype,$length,$individuals,$geno,$count,$AF);
my (@fields,@alleles,@frequency);

#First inspections of the number of individuals in the master VCF FILE
$line = `grep -m 1 \"PASS\" $INPUT`;
chomp($line);
@fields = split(/\t+/,$line);
$length = @fields;
$individuals = $length - 9;
print "File containing $individuals individuals\n";
print "Output file written in : $OUT\n";

#Calculus of Alele frequency for each SNV and PASS variant
open (INN,"$INPUT") || die "Cant open file $INPUT\n";
while(<INN>){
$line =$_;
chomp($line);
@fields = split(/\t+/,$line);

#Select only the SNVs PASS, get the genotype and concat in @frequency
@frequency = ();
if ($fields[6] eq "PASS" && $fields[4] =~ /^[A|C|G|T]$/ && $fields[3] =~ /^[A|C|G|T]$/ ){
for ($i=9; $i < $length; $i++){
	$genotype = (split(/:+/,$fields[$i]))[0];
	@alleles = split(/\/+/, $genotype);
	push(@frequency,@alleles);
}

#Get the number of alleles in the individuals
$count = 0;
foreach(@frequency){
  $geno = $_;
  if ($geno eq "1"){
	$count++;
  }
}
#Calculus of Allele frequency in the indivuals
$AF = $count/($individuals*2);
if ($AF >= $EAF){
	print OUT "$fields[0]\t$fields[1]\t$fields[3]\t$fields[4]\t$AF\n";
}
}
}
close(INN);
close(OUT);

