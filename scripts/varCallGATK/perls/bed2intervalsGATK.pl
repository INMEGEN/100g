#! perl

open(FI,$ARGV[0]);
while(<FI>){
	if( $_ =~ /^chr/){
		chomp($_);
		@linea=split('\t',$_);
		print $linea[0].":".$linea[1]."-".$linea[2]."\n";
	}
}
