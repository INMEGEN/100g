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
		$vor{$lin[0]}{$nig[0]}=$nig[1]."\t".$lin[2]."\t".$nig[2]."\t".$lin[3]."\t".$lig[4];
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
			if($flag==1){
				print $_;
			}
			$flag=0;
			next;
		}
		elsif(exists $vor{$lin[0]}{$lin[1]}){
##bloque nuevo
#
#			$cadena=magia($_,$vor{$lin[0]}{$lin[1]},\%pos,$ARGV[2]);
#
			@lig=split(":",$lin[9]);
			@nig=split(/\|/,$lig[4]);
#			@lon=split("\t",$vor{$lin[0]}{$lin[1]});
#print "$lon[0]\n";
#			@log=split(":",$lon[4]);
#			@nog=split("|",$log[4]);
#			print "No son iguales porque $nig[0] \!\= $nog[0] $nig[1] \!\= $nog[1] \n";
####
			@nucs=split("\t",$vor{$lin[0]}{$lin[1]});
			@alte=split(",",$nucs[3]);
			$dist=$pos{$lin[0]}{$lin[1]}-$lin[1];

			@nog=split(/\|/,$nucs[4]);
			if (($nig[0]!=$nog[0])&&($nig[1]!=$nog[1])){
				print $_;
				$flag=1;
				next;
			}
			if($dist>1){
				open(OUT, ">tmp.bed");
				print OUT $lin[0]."\t".$lin[1]."\t".$pos{$lin[0]}{$lin[1]}."\n";
				close(OUT);
				$comando='bedtools getfasta -fi '.$ARGV[2].' -bed tmp.bed -fo otro.fa';
				system($comando);
				open(FA, "otro.fa") or die $!;
				@fa=<FA>;
				close(FA);
				$ref=substr($fa[1],0,-2);
				$rnuc=$nucs[0].$ref.$nucs[1];
				$anuc=$nucs[2].$ref;
			}
			else{
                                $rnuc=$nucs[0].$nucs[1];
				$anuc=$nucs[2];
			}
			$aanuc="";
			for($k=0;$k<=$#alte;$k++){
				$aanuc.=$anuc.$alte[$k].",";
			}
			chop($aanuc);
	
			$lin[3]=$rnuc;
                        $lin[4]=$aanuc;
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


####$uno=$_;$dos=$vor{$lin[0]}{$lin[1]};%pos=$pos;$cuatro=$ARGV[2];
sub magia($uno,$dos,$tres,$cuatro){
	$uno=
	@lin=split("\t",$uno);
	@lig=split(":",$lin[9]);
	@nig=split(/\|/,$lig[4]);
	@nucs=split("\t",$dos);
	@alte=split(",",$nucs[3]);
	$dist=$pos{$lin[0]}{$lin[1]}-$lin[1];
	@nog=split(/\|/,$nucs[4]);
	if (($nig[0]!=$nog[0])&&($nig[1]!=$nog[1])){
		return $_;
		$flag=1;
		next;
	}
	if($dist>1){
		open(OUT, ">tmp.bed");
		print OUT $lin[0]."\t".$lin[1]."\t".$pos{$lin[0]}{$lin[1]}."\n";
		close(OUT);
		$comando='bedtools getfasta -fi '.$cuatro.' -bed tmp.bed -fo otro.fa';
		system($comando);
		open(FA, "otro.fa") or die $!;
		@fa=<FA>;
		close(FA);
		$ref=substr($fa[1],0,-2);
		$rnuc=$nucs[0].$ref.$nucs[1];
		$anuc=$nucs[2].$ref;
	}
	else{
		$rnuc=$nucs[0].$nucs[1];
		$anuc=$nucs[2];
	}
	$aanuc="";
	for($k=0;$k<=$#alte;$k++){
		$aanuc.=$anuc.$alte[$k].",";
	}
	chop($aanuc);
	$lin[3]=$rnuc;
	$lin[4]=$aanuc;
	$vcf=join("\t", @lin);
	return $vcf;
}

