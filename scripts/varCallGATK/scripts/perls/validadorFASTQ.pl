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
$cont=0;

while(<FI>){
	if($_ =~/^@.+10:000000000-ABRWW/){
		$_=~s/10:000000000-ABRWW/10:corto/g;
		chomp($_);
		$_=$_.":".$ARGV[1];
		if(exists $nombres{$_}){
			$nombres{$_}+=1;
		}
		else{
			$nombres{$_}=1;
		}
		print "$_:$nombres{$_}\n";
	}
	else{
		print $_;
	}
	$cont+=1;
}
#foreach $uno (sort keys %alelo){
#	foreach $dos (sort keys %{$alelo{$uno}}){
#		print "$uno $dos: $alelo{$uno}{$dos}\n";
#	}
#}
