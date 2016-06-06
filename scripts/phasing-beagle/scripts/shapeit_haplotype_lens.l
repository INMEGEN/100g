#!/usr/bin/perl
use strict;
use warnings;
my(@geno, @histo, $cnt, @pairs, @pos); 

my $prev=-1; 
# Read haps
while(<>){
    my($chrom, $rs, $pos, $al1, $al2, @gen)=split; 
    
#     @gen=@gen[24 .. 29]; # Asi me quedo solo con el trio

    next unless sum(@gen)/@gen >= 0.02; # more than 98% of genotypes are '0'
    
    # con un haps correcto esta precaucion no es necesaria
    next if $pos<=$prev;  
    $prev=$pos; 
    
    push @pos, $pos; 
    # transpose rows to cols
    for(my $i=0; $i< @gen; $i++){
        push @{$geno[$i]}, $gen[$i]; 
    }
}

# Create list of all possible chromosme pairs
for(my $i=0; $i< @geno; $i++){
    for(my $j=$i+1; $j< @geno; $j++){
        push @pairs, [$i, $j]; 
    }
}

# Randomly sample possible chromosme pairs, because sampling
# all pairs could take too long
while(1){
    last unless @pairs; 
    
    my $k =rand(@pairs);         # get a random pair
    my($i, $j)=@{$pairs[$k]}; 
    splice(@pairs, $k, 1);       # discard the used pair
    
    print STDERR "Doing $i\t$j\n"; 
    shrared($geno[$i], $geno[$j]); 
    last if sum(@histo)> 1e7;   # Stop if sampling is good enough
}

# Report distribution
print "#log_of_len\tlen\tfrequency\n"; 
for(my $i=0; $i< @histo; $i++){
    $histo[$i]||=0; 
    my $log=($i+0.5)/10; 
    my $len= int(exp( 2.302585093 * $log)); 
    print "$log\t$len\t$histo[$i]\n"; 
}

### ===============subroutines =========
sub sum{
# simple sum of values in array
    my $sum=0; 
    foreach my $val ( @_ ){
        $sum+=$val ||0; 
    }
    return $sum; 
}

sub shrared{
# finds all identical regions between two chroms (x,y), and counts
# them by length into global @histo
    my($x, $y)=@_; 
    my $prev=-1; 
    for(my $i=0; $i< $#pos; $i++){
        next if $x->[$i] eq $y->[$i]; 
        my $len=$pos[$i]-$prev;                      # Real length in bp
        $histo[10 * log($len) / 2.302585093 +0.5]++; # This creates nice log10 distribution
        $prev=$pos[$i]; 
    }
    my $len=$pos[$#pos]-$prev;
    $histo[10 * log($len) / 2.302585093 +0.5]++; 
}
