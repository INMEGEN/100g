#############################################################################################################################
## Script para agrupar (promediar) los valores en una matriz, de acuerdo al grupo al que pertenece cada fila en la matriz	#####
## Debe existir un archivo que defina a que grupo pertenece cada ID (fila) de la matriz					#####
#############################################################################################################################
 
#Opciones
# -in nombre de la matriz de conteo
# -id nombre del archivo de la matriz
# -out nombre de la matriz de salida

use strict;
use Getopt::Long;
 
use strict;

my ($inputmatrix, $idfile, $outfile, $group, $sample, $values, $line, $i,$s,$head);
my (@ids, @values,@sumvalues, @incidence);
 
GetOptions ("in=s"   => \$inputmatrix,
            "id=s"   => \$idfile,
            "head=i" => \$head,
	    "out=s"  => \$outfile) || die("Error in command line arguments\n");
 
if (!$inputmatrix || !$idfile || !$outfile){
  die "Falta indicar alguno de los parametros
	-in Nombre de la matriz de conteo
	-out Nombre de la matriz de salida
	-head=1 To include header
	-id Relacion de cada ID (nombre de fila) y el grupo al que pertenece, con el formato:
	Chinanteco	SM-3MGPV
	19-Chocholteco	SM-3MG5E
	20-Chocholteco	SM-3MG5F
	Chontal_Oax	SM-3MG5Z
	Se creara automaticamente el archivo incidence-matrix.txt el cual describe el numero de IDs por grupo que tengan una incidendia mayor a 0 para cada columna\n";
}


#Detectamos el numero total de grupos, se manda a un archivo auxiliar
system("sort -k 1 $idfile | cut -f 1 | sort -u >grupos-aux.txt");

if ($head == 1){
#Se manda el header de la matriz al archivo OUTput
system("head -n 1 $inputmatrix >$outfile");
#Se manda el header de la matriz al archivo incidence
system("head -n 1 $inputmatrix >incidence-matrix.txt");
#Crea el archivo de salida
open(OUT, ">>${outfile}") || die "No puedo crear el archivo de salida\n";
#Crea el archivo incidence
open(INN, ">>incidence-matrix.txt") || die "No puedo crear el archivo de salida\n";
}else{
#Crea el archivo de salida
open(OUT, ">${outfile}") || die "No puedo crear el archivo de salida\n";
#Crea el archivo incidence
open(INN, ">incidence-matrix.txt") || die "No puedo crear el archivo de salida\n";
}
#Se lee el archivo auxiliar, para cada grupo se detectan las muestras pertenecenecienes
open (AUX, "grupos-aux.txt") || die "No puede leer el archivo auxiliar grupos-aux.txt\n";
while(<AUX>){
  $group = $_;
  chomp($group);
  @ids = `grep $group $idfile | cut -f 2`;
  my $numbersamples = `grep -c $group $idfile`;
  #Para cada muestra o id, se leen sus valores, y se suman en un vector
  @sumvalues = ();
  @incidence = ();
  $numbersamples = 0;
  foreach(@ids){
	$sample = $_;
	chomp($sample);
	$line = `grep $sample $inputmatrix | cut -f 2-`;
	chomp($line);
        if ($line){
         $numbersamples++;
        }else{
	print "$sample no existe en $inputmatrix\n";
        }
	@values = split(/\t+/,$line);
	for ($i=0;$i <scalar @values;$i++){
  		  $sumvalues[$i] = $sumvalues[$i] + $values[$i];
		  if ($values[$i] > 0){
			$incidence[$i]++;
		  }
	  }
  }
  #Los campos vacios en la matriz incidence se vuelven 0
  for ($i=0;$i <scalar @values;$i++){
	if(!$incidence[$i]){
		$incidence[$i] = 0;
	}
  } 

  #Se imprimen los valores sumados de cada grupo en el archivo final
  print OUT "$group\t";
  foreach(@sumvalues){
 	$s = $_;
        $s = $s/$numbersamples;
	print OUT "$s\t";
  }
  print OUT "\n";	
  
  #Se imprimen los valores de ausencia y presencia en el archivo incidence
  print INN "$group\t";
  foreach(@incidence){
	$i = $_;
	print INN "$i\t";
  }
  print INN "\n";	

}
close(AUX);
close(OUT);
system("rm grupos-aux.txt");
















