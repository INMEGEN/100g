#! /bin/perl

########################################################
# USAGE
#
my $USAGE =<<USAGE;

     Uso:

         perl cuentaVarPerSample.pl [-h --help] [-p FIELD sub1 sub2 ... ]  

         donde:

     -h, --help:  Imprime esta ayuda
             -p:  Para utilizar la version piping
          FIELD:  Campo primario (INFO o FORMAT)
            sub:  ID de campo secundario que se desea mantener

USAGE
#
######################################################
if($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || !$ARGV[0]){
	print $USAGE;
	exit;
}
elsif($ARGV[0] eq "-p"){
	if($ARGV[1] eq "INFO"){
		$campo=7;
	}
	elsif($ARGV[1] eq "FORMAT"){
		$campo=8;
	}
	else{
		die "Utiliza un campo valido (INFO o FORMAT)\n";
	}
        @samples=();
        @count=();
        while(<STDIN>){
                if($_=~ /^chr/){
                        chomp($_);
                        @tmp=split('\t',$_);
			$string="";
			if($campo<8){
				@fiel=split(';',$tmp[$campo]);
				$sep=';';
			}
			else{
				@fiel=split(':',$tmp[$campo]);
				@fiel2=split(':',$tmp[$campo+1]);
				$sep=':';
				$string2="";
			}
			@fixed=();
			for($i=0;$i<=$#fiel;$i++){
				$flag=0;
				for($j=2;$j<=$#ARGV;$j++){
					if($fiel[$i] =~ /$ARGV[$j]/){
						$flag=1;
#						print "$ARGV[$j] si esta en $fiel[$i]\n";
						last;
					}
#					print "$ARGV[$j] no esta en $fiel[$i]\n";
				}
				if($flag==1){
					push(@fixed,$i);
				}
			}
			for($i=0;$i<=$#fixed;$i++){
				$string=$string.$sep.$fiel[$fixed[$i]];
				if($campo>7){
					$string2=$string2.$sep.$fiel2[$fixed[$i]];
				}
			}
			$var="";
			$string=~s/^.//s;
			for($i=0;$i<=$#tmp;$i++){
				if($i==$campo){
					if($i==8){
						$string2=~s/^.//s;
						$var=$var."\t".$string."\t".$string2;
						last;
					}
					else{
						$var=$var."\t".$string;
					}
				}
				else{
					$var=$var."\t".$tmp[$i];
				}
			}
			$var=~s/^.//s;
			print "$var\n";
                }
		else{
			print $_;
		}
        }
}

