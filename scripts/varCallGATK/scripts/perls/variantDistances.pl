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

if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0] ){
	print $USAGE;
	exit;
}

open(FI,$ARGV[0])or die $!;
#$flag=$ARGV[1];

while(<FI>){
	if($_ =~/^[^#]/){
		@lin=split("\t",$_);
		if(exists $var{$lin[0]}[0]){
			$var{$lin[0]}[$i]=$lin[1];
			$dif=$var{$lin[0]}[$i]-$var{$lin[0]}[$i-1];
			if($dif < $ARGV[1] ){
				print $_;
			}
#			print "$dif\n";
			$i+=1;
		}
		else{
#			print "\$var\{$lin[0]\}\[0\]=$lin[1]\t$i\n";
			$var{$lin[0]}[0]=$lin[1];
			$i=1;
		}
	}
}
close(FI);
