#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $in=shift;
my $fai=shift;
my $gff=shift;
my $out=shift;

my %fa;
open FA, $fai or die $!;
while(<FA>){
        chomp;
        my @inf=split;
        print Dumper @inf;
        $fa{$inf[0]}= 'A' x $inf[1];
}
close FA;

print "fa done\n";

my $gene_count=0;
my $line_count=0;
open GFF, $gff or die $!;
while(<GFF>){
        $line_count+=1;
        if ( $line_count % 100 eq 0){ print "precessed $line_count lines\n";}
        next unless /^chr/;
        chomp;
        my @inf=split;
        next unless exists $fa{$inf[0]};
        if ($inf[2] eq "CDS"){
                substr($fa{$inf[0]},$inf[3]-1,$inf[4]-$inf[3]+1)=~s/[AdDuUiIeE]/c/g;
        }elsif($inf[2] eq "exon"){
                if ($_=~/gbkey=mRNA/){substr($fa{$inf[0]},$inf[3]-1,$inf[4]-$inf[3]+1)=~s/[AdDuUiIe]/E/g;}
                substr($fa{$inf[0]},$inf[3]-1,$inf[4]-$inf[3]+1)=~s/[AdDuUiI]/e/g;
        }elsif($inf[2] eq "gene"){

                my ($ust,$ued,$dst,$ded)=($inf[3]-10001,$inf[3]-2,$inf[4],$inf[4]+9999);

                if ($inf[6] eq "-"){
                        ($ust,$ued,$dst,$ded)=($dst,$ded,$ust,$ued);
                }
                if($_=~/protein_coding/){
                        substr($fa{$inf[0]},$inf[3]-1,$inf[4]-$inf[3]+1)=~s/[AdDuU]/I/g;
                        substr($fa{$inf[0]},$ust,$ued-$ust+1)=~s/[AdD]/U/g;
                        substr($fa{$inf[0]},$dst,$ded-$dst+1)=~s/[A]/D/g;
                }

                substr($fa{$inf[0]},$inf[3]-1,$inf[4]-$inf[3]+1)=~s/[AdDuU]/i/g;
                $gene_count+=1;
                if ( $gene_count % 100 eq "0" ){ print "$gene_count gene\n";}
                substr($fa{$inf[0]},$ust,$ued-$ust+1)=~s/[AdD]/u/g;
                substr($fa{$inf[0]},$dst,$ded-$dst+1)=~s/[A]/d/g;
        }

}
close IN;

open OUT, " > $out " or die $!;
open IN, $in or die $!;
while(<IN>){
        chomp;
        my @inf=split;
        next unless exists $fa{$inf[0]};
        my $ele=substr($fa{$inf[0]},$inf[2]-1,1);
        print OUT "$_\t$ele\n";
}
close IN;
close OUT;


for my $fa (keys %fa){
        my $c= $fa{$fa} =~ tr/c//;
        my $E= $fa{$fa} =~ tr/E//;
        my $I= $fa{$fa} =~ tr/I//;
        my $e= $fa{$fa} =~ tr/e//;
        my $i= $fa{$fa} =~ tr/i//;
        my $u= $fa{$fa} =~ tr/u//;
        my $U= $fa{$fa} =~ tr/U//;
        my $d= $fa{$fa} =~ tr/d//;
        my $D= $fa{$fa} =~ tr/D//;
        my $A= $fa{$fa} =~ tr/A//;
        print  "$fa\n$c\n$E\n$I\n$U\n$D\n$e\n$i\n$u\n$d\n$A\n";
}


