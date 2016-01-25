#! /bin/perl

########################################################
# USAGE
#
my $USAGE =<<USAGE;

     Uso:

         perl bed2pb.pl [-h --help] [<filename.vcf> <flag>] 

         donde:

     -h, --help:  Imprime esta ayuda
 <filename.bed>:  Archivo bed de entrada
         <flag>:  1 imprime linea por linea la longitud del intervalo
                  2 calcula el total de pb cubiertas

     Ejemplo:

  perl bed2pb.pl file.bed 2

USAGE
#
######################################################

if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0] || $ARGV[1] > 2){
	print $USAGE;
	exit;
}

open(FI,$ARGV[0])or die $!;
$flag=$ARGV[1];
$pb=0;
while(<FI>){
	if($_ =~/\w+\t\d+\t\d+/){
		@inter=split("\t",$_);
		$pbi=$inter[2]-$inter[1];
		if($flag==1){
			print "$inter[0]\t$inter[1]\t$inter[2]\t$pbi\n";
		}
		$pb+=$pbi;
	}
}
close(FI);
if($flag==2){
	print "TOTAL: $pb\n";
}
