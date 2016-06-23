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
open(VCF,$ARGV[0])or die $!;
while(<VCF>){
	if($_ =~/^[^#]/){
		@lin=split("\t",$_);
		@nucs=split(":",$lin[9]);
		if($#nucs > 5){
			if (length $lin[3] > 1){
				@var=split("_",$nucs[5]);
				if($var[0] == $lin[1]){
					print $_;
				}
			}
		}
	}
	else{
		print $_;
	}
}
close(VCF);

