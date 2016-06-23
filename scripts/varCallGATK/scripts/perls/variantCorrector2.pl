#! /bin/perl
#
#########################################################
## USAGE
#
my $USAGE =<<USAGE;

Script de perl para hacer la correccion de alelos mediante la integracion de posiciones
y el genoma de referencia, la herramienta depende de bedtools. Este script requiere de 
las marcas de GATK pertenecientes a faseo fisico obtenido automaticamente por el metodo
de HaplotypeCaller.

     Uso:

              perl variantCorrector2.pl [-h --help] [<filename.vcf> <dist> <ref>] 

        donde:

             -h, --help:  Imprime esta ayuda
         <filename.vcf>:  Archivo VCF de entrada
                 <dist>:  Distancia de correccion
                  <ref>:  Archivo fasta con la referencia usada para el llamado de variantes
                          del archivo VCF

       Ejemplo:
              perl variantCorrector.pl filtered.vcf 4 /path/to/hg19.fa

USAGE
#
######################################################
if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0] ){
	print $USAGE;
	exit;
}
$flag="";
open(FI,$ARGV[0]) or die $!;
while(<FI>){
# Verificando que no es un header
	if($_=~/^[^#]/){
# Se genera un arreglo de linea @lin
		@lin=split("\t",$_);
# Se verifica si ya existe el cromosoma de la linea, si sí entonces entramos 
		if(exists $var{$lin[0]}[0]){
# Se coloca una nueva posicion al arreglo del cromosoma de la linea y se coloca la linea en el hash vor para uso futuro
			$var{$lin[0]}[1]=$lin[1];
			$vor{$lin[0]}[1]=$_;
# Calculo de distancia entre las posiciones actual y previa en el arreglo del cromosoma, si es mayor a valor ingresado por usuario se imprime la linea anterior 
			$dist=$var{$lin[0]}[1]-$var{$lin[0]}[0];
#si la distancia es mayor a la especificada o es menor 1 (se asume ordenamiento previo para que solo exista 0) se imprime lo que hay en memoria, se cambia el valor en memoria y la bandera de final de cromosoma
			if(($dist>=$ARGV[1])||($dist<1)){
				print $vor{$lin[0]}[0];
				$vor{$lin[0]}[0]=$_;
				$flag=$_;
			}
#si la distancia esta en el rango de la distancia especificada
			else{
				@resultado=ejecutaCercanos($_,$vor{$lin[0]}[0],$ARGV[2]);
				if($resultado[1]==1){
					$vor{$lin[0]}[0]=$resultado[0];
					$flag=$resultado[0];
				}
			}
			$var{$lin[0]}[0]=$lin[1];
		}
# iniciar un nuevo cromosoma 
		else{
			print $flag;
			$vor{$lin[0]}[0]=$_;
			$var{$lin[0]}[0]=$lin[1];
		}
	}
	else{
# se imprime header
		print $_;
	}
}
#print"ya termine, checo si hay algo mas que imprimir\n";
print $flag;
close(VCF);


sub obtenerNucleotido {
	my ($chrom,$ini,$fin,$refPath)=@_;
	open(OUT,">tmp.bed");
	print OUT $chrom."\t".$ini."\t".$fin."\n";
	close(OUT);
	$comando='bedtools getfasta -fi '.$refPath.' -bed tmp.bed -fo otro.fa';
	system($comando);
	open(FA,"otro.fa") or die $!;
	@fa=<FA>;
	close(FA);
	$ref=substr($fa[1],0,-2);
	return($ref);
}

sub bin2dec {
	return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub obviaAlelo {
	my $v1 = shift;
	if ($v1==0){
		return("0");
	}
	else{
		return("1");
	}
}


sub ejecutaCercanos {
	my ($actual,$previa,$pathREF) = @_;		
# Se descomponen la línea previa y la actual, l@n tiene campos de vcf, l@g tiene subcampos de muestra, n@g tiene fase de variante, alte@ posee los alelos alternativos
	@lon=split("\t",$previa);
	@lin=split("\t",$actual);
	@lig=split(":",$lin[9]);
	@log=split(":",$lon[9]);
	@nig=split(/\|/,$lig[4]);
	@nog=split(/\|/,$log[4]);
	@altei=split(",",$lin[4]);
	@alteo=split(",",$lon[4]);
	
#	if($lig[5] ne $log[5]){
#		$flag=1;
#		return ($previa.$actual,$flag);
#	}
# Cambio binario
	$nig[0]=obviaAlelo($nig[0]);
	$nig[1]=obviaAlelo($nig[1]);
	$nog[0]=obviaAlelo($nog[0]);
	$nog[1]=obviaAlelo($nog[1]);
	$num=bin2dec($nig[0].$nig[1].$nog[0].$nog[1]);
#	print "num=$num\n";
#	print "num=$num porque p1A = $nig[0] p1B = $nig[1] p2A = $nog[0] p2B = $nog[1]\n";
# Si los genotipos faseados son diferentes se imprimen ambas variantes por separado
# $num>3 && $num<10 && $num%3==0
	if(($num==6)||($num==9)){
		$flag=1;
		return($previa.$actual,$flag);
	}
#si hay fase
	elsif(($num>4)&&(($num%4)!=0)){			
#se obtienen los alelos de combinacion
		if($dist>1){
			$ref=obtenerNucleotido($lin[0],$lon[1],$lin[1],$pathREF);
			$rnuc=$lon[3].$ref.$lin[3];
			$anuc=$lon[4].$ref;
		}
		else{
			$rnuc=$lon[3].$lin[3];
			$anuc=$lon[4];
		}       
		$aanuc="";
		for($k=0;$k<=$#altei;$k++){
			$aanuc.=$anuc.$altei[$k].",";
		}
		chop($aanuc);
		$lon[3]=$rnuc;
		$lon[4]=$aanuc;
		$vcf=join("\t",@lon);
# si la fase es el alelo alternativo unico
		if(($num%5)==0){
			$flag=1;
			return($vcf,$flag);
		}
#si la fase y el alternativo de la posicion actual son heterocigotos
		elsif(($num%7)==0){
			$flag=1;
			return($vcf.$previa,$flag);
		}
#si la fase y el alternativo de la posicion previa son heterocigotos
		elsif((abs(12-$num))==1){
			$flag=1;
			return($vcf.$actual,$flag);
		}
	}
#si solo hay alternativo de la posicion previa (esto no debe existir)
	elsif(($num%4)==0){
		$flag=0;
		return($previa,$flag);
	}
#si solo hay alternativo de la posicion actual (esto no debe exitir)
	elsif($num>0){
		$flag=0;
		return($actual,$flag);
	}
#si no hay alternativos en ambas posiciones (esto menos debe de pasar)
	else{
		$flag=0;
		return("",$flag);
	}
}






