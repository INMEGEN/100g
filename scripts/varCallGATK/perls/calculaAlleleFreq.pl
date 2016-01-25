#! /bin/perl

########################################################
# USAGE
#
my $USAGE =<<USAGE;

     Uso:

         perl cuentaVarPerSample.pl [-h --help] [-p] [<filename.vcf>] 

         donde:

     -h, --help:  Imprime esta ayuda
             -p:  Para utilizar la version piping
 <filename.vcf>:  Modo archivo único lee el archivo de entrada

USAGE
#
######################################################
if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0]){
	print $USAGE;
	exit;
}
elsif($ARGV[0] eq "-p"){
        @samples=();
        @count=();
        while(<STDIN>){
                if($_=~ /^chr/){
                        chomp($_);
                        @tmp=split('\t',$_);
			@ale=split(':',$tmp[9]);
			@frq=split(',',$ale[1]);
			$altFreq= sprintf("%.3f",$frq[1]/($frq[0]+$frq[1]));
			print "$tmp[0]\t$tmp[1]\t$tmp[9]\t$frq[0]\t$frq[1]\t$altFreq\n";
                }
        }
}

