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
while(<FI>){
	chomp;
	@lin=split("\t",$_);
	if($lin[4] =~ /\|/){
		$var{$lin[0]}{$lin[1]}=$_;
		@lig=split(":",$lin[4]);
		@nig=split("_",$lig[5]);
#	print "vor es $lin[0] $lig[6] .. $nig[0]\n";
		$vor{$lin[0]}{$nig[0]}=$nig[1]."\t".$lin[2]."\t".$nig[2]."\t".$lin[3];
		$pos{$lin[0]}{$nig[0]}=$lin[1];
	}
	else{
#		print "ERROR: no se puede $lin[0] $lin[1]\n";
	next;
	}
}
close(FI);
open(VCF,$ARGV[1])or die $!;
while(<VCF>){
	if($_ =~/^[^#]/){
		@lin=split("\t",$_);
		if(exists $var{$lin[0]}{$lin[1]}){
#print "ya existe\n";
#print $_;
			next;
		}
		elsif(exists $vor{$lin[0]}{$lin[1]}){

			@nucs=split("\t",$vor{$lin[0]}{$lin[1]});
			$dist=$pos{$lin[0]}{$lin[1]}-$lin[1];

			if($dist>1){
				open(OUT, ">tmp.bed");
				print OUT $lin[0]."\t".$lin[1]."\t".$pos{$lin[0]}{$lin[1]}."\n";
				close(OUT);
				$comando='bedtools getfasta -fi '.$ARGV[2].' -bed tmp.bed -fo otro.fa';
#				system('bedtools getfasta -fi /scratch-compute-0-1/carmen_alaez/referencias/genome/hg19.fa -bed tmp.bed -fo otro.fa');
				system($comando);
				open(FA, "otro.fa") or die $!;
				@fa=<FA>;
				close(FA);
				$ref=substr($fa[1],0,-2);
				$rnuc=$nucs[0].$ref.$nucs[1];
				$anuc=$nucs[2].$ref.$nucs[3];
			}
			else{
                                $rnuc=$nucs[0].$nucs[1];
                                $anuc=$nucs[2].$nucs[3];

			}

                        $lin[3]=$rnuc;
                        $lin[4]=$anuc;
                        $vcf=join("\t", @lin);
                        print $vcf;
		}
		else{
			print $_;
		}
	}
	else{
		print $_;
	}
}
close(VCF);
