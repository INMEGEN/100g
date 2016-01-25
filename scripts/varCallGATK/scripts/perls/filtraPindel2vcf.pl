#! /bin/perl

########################################################
# USAGE
#
my $USAGE =<<USAGE;

     Uso:

         perl filtraPindel2vcf.pl [-h --help] [-p <filename.vcf>] 

         donde:

     -h, --help:  Imprime esta ayuda
             -p:  Para utilizar la version piping
 <filename.vcf>:  Archivo de entrada VCF para filtrar

USAGE
#
######################################################
if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0]){
	print $USAGE;
	exit;
}
elsif($ARGV[0] eq "-p"){
	open(FI,$ARGV[1]) or die $!;
        while(<STDIN>){
                if($_=~ /^chr/){
                        chomp($_);
 			@tmp=split('\t',$_);
			$var{$tmp[0]}{$tmp[1]}{$tmp[2]}=$tmp[5];
		}
        }
	while(<FI>){
                if($_=~ /^chr/){
			chomp($_);
			@tmp=split('\t',$_);
			if(exists($var{$tmp[0]}{$tmp[1]}{$tmp[9]})){
				print "$_\n";
			}
                }
		else{
			print $_;
		}
	}
	close(FI);
}
else{
	print $USAGE;
	exit;
}

