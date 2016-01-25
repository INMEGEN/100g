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
$cont=1;
while(<FI>){
	if($_ =~/^[^@]/){
		@lin=split("\t",$_);
		$chr=$lin[2];
		$ini=$lin[3];
#		$seq=$lin[9];
		@pos=split('',$lin[9]);
		if ($#pos+$ini < $ARGV[2]){
#			print "Read:$cont insuficiente\n";
		}
		else{
			if (exists $alelo{$pos[$ARGV[1]-$ini]}{$pos[$ARGV[2]-$ini]}){
				$alelo{$pos[$ARGV[1]-$ini]}{$pos[$ARGV[2]-$ini]}+=1;
			}else{
				$alelo{$pos[$ARGV[1]-$ini]}{$pos[$ARGV[2]-$ini]}=1;
#			print "Read:$cont $pos[$ARGV[1]-$ini] $pos[$ARGV[2]-$ini]\n";
			}
		}
		$cont+=1;
	}
}
foreach $uno (sort keys %alelo){
	foreach $dos (sort keys %{$alelo{$uno}}){
		print "$uno $dos: $alelo{$uno}{$dos}\n";
	}
}
