#! /bin/perl

########################################################
# USAGE
#
my $USAGE =<<USAGE;

     Uso:

         perl amplicon2bedChequer.pl [-h --help] [<-p> <-S> <chrOrden>] 

         donde:

     -h, --help:  Imprime esta ayuda
           <-p>:  Version de tuberia
           <-S>:  Version para ordenamiento para omision utilizar -N
     <chrOrden>:  Archivo de orden de cromosomas

     Ejemplo:

  cat file.bed | perl amplicon2bedChequer.pl -p -S | perl amplicon2bedChequer.pl -p -N ordenCromosomas.txt > correct.bed

Autor: Roberto Galindo Ramirez

USAGE
#
######################################################

if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || $ARGV[0] ne "-p"){
	print $USAGE;
	exit;
}

while(<STDIN>){
	chomp($_);
	if($_ =~/\w+\t\d+\t\d+/){
		@inter=split("\t",$_);

#### BLOQUE DE ORDENAMIENTO DE COLUMNAS
		if($inter[1]>$inter[2]){
			$max=$inter[1];
			$min=$inter[2];
		}elsif($inter[2]>$inter[1]){
			$max=$inter[2];
			$min=$inter[1];
		}else{
			next;
#			si son iguales las columnas se elimina el renglon
		}
#####################################
#### VERIFICACION DE CROMOSOMA
		if(!exists($crom{$inter[0]})){
			$crom{$inter[0]}[0][0]=0;
			$crom{$inter[0]}[0][1]=0;
		}
############################

# $j=scalar(@{$crom{$inter[0]}});
# $j tiene el total de elementos
# $#{@crom{$inter[0]}} tiene el numero de rows 

#### BLOQUE DE INTERSECCION DE INTERVALOS ###############
		$flag=0;
		for($i=0;$i<=$#{@crom{$inter[0]}};$i++){
			if(($crom{$inter[0]}[$i][0] <= $min)&&($min <= $crom{$inter[0]}[$i][1])){
				if($max>$crom{$inter[0]}[$i][1]){
					$crom{$inter[0]}[$i][1]=$max;
				}
				$flag=1;
			}
			elsif(($crom{$inter[0]}[$i][0] <= $max)&&($max <= $crom{$inter[0]}[$i][1])){
				if($min<$crom{$inter[0]}[$i][0]){
					$crom{$inter[0]}[$i][0]=$min;
				}
				$flag=1;
			}
			elsif(($min<$crom{$inter[0]}[$i][0])&&($crom{$inter[0]}[$i][1]<$max)){
				$crom{$inter[0]}[$i][0]=$min;
				$crom{$inter[0]}[$i][1]=$max;
				$flag=1;
			}
		}
		if($flag==0){
			$crom{$inter[0]}[$i][0]=$min;
			$crom{$inter[0]}[$i][1]=$max;
		}
#########################################################
	}
}
#### BLOQUE DE FUNCIONES ANEXAS ORDENAMIENTO E IMPRESION  ############
#### SI EXISTE TERCER ARGUMENTO OBTIENE UN ORDEN DE ESE ARCHIVO#
if(!$ARGV[2]){
	@ochr=("chrM","chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY");
}
else{
	open(ORDEN,$ARGV[2]) or die $!;
	@ochr=<ORDEN>;
	close(ORDEN);
	chomp(@ochr);
}
################################################################
#### BLOQUE DE ORDENAMIENTO POR BURBUJA PARA LOS STARTS #####################################
#### SI EL SEGUNDO ARGUMENTO ES -S ORDENA si es -N (o cualquier otro) NO ORDENA
if($ARGV[1] eq "-S"){
	foreach $chr (sort {compare($a, $b, @ochr)} (keys %crom)){
		if($#{@crom{$chr}}>1){
			for($i=1;$i<=$#{@crom{$chr}}-1;$i++){
				for($j=1;$j<=$#{@crom{$chr}}-1;$j++){
					if($crom{$chr}[$j][0]>$crom{$chr}[$j+1][0]){
						$tmp1=$crom{$chr}[$j][0];
	                                        $tmp2=$crom{$chr}[$j][1];
	                                        $crom{$chr}[$j][0]=$crom{$chr}[$j+1][0];
	                                        $crom{$chr}[$j][1]=$crom{$chr}[$j+1][1];
	                                        $crom{$chr}[$j+1][0]=$tmp1;
	                                        $crom{$chr}[$j+1][1]=$tmp2;
					}
				}
			}
		}
	}
}
#############################################################################################

#@ochr tiene un arreglo de cromosomas tipico de hg19 se deberia de poder definir

#### BLOQUE DE IMPRESION ###################################################################
foreach $chr (sort {compare($a, $b, @ochr)} (keys %crom)){
#  $#{@crom{$chr} tiene el numero de rows a utilizarse
	for($i=1;$i<=$#{@crom{$chr}};$i++){
		print "$chr\t$crom{$chr}[$i][0]\t$crom{$chr}[$i][1]\n";

	}
}
###########################################################################################

sub compare {
        my ($first, $second, @rule) = @_;
        $b1=0;
        $b2=0;
        for($i=0;$i<=$#rule;$i++){
                if($first eq $rule[$i]){
                        $b1=1;
                }
                if($second eq $rule[$i]){
                        $b2=1;
                }
                if($b1 > $b2){
                        return -1;
                }
                elsif($b1 < $b2){
                        return 1;
                }
                elsif($b1 == 1){
                        return 0;
                }
        }
}

