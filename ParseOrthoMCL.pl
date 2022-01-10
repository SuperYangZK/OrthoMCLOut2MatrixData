#!/usr/bin/perl
use strict;
use warnings;

die"usage:perl $0 <Ortho> <OU>\n"unless(@ARGV == 2);
my(%hash,%flag);
open IN,$ARGV[0] or die $!;
while(<IN>){
	chomp;
	my@ar=split(/:\s+/,$_,2);
	my$ot = $ar[0];
	$ot =~ s/\(.*|ORTHOMCL//g;
	my@sr=split(/\s+/,$ar[1]);
	for(my$i=0;$i<=$#sr;$i+=1){
		my@tt = $sr[$i] =~ m/(\S+)\((\S+)\)/g;
		$hash{$ot}{$tt[1]} += 1;
		$flag{$tt[1]} = 1;
	}
}
close IN;

open OU,">",$ARGV[1] or die $!;
print OU "AccessID";
foreach my$key(sort{$a <=> $b}keys%hash){
	print OU "\tOrtho$key";
}
print OU "\n";
foreach my$key(sort{$a cmp $b}keys%flag){
	print OU "$key";
	foreach my$hey(sort{$a <=> $b}keys%hash){
		if(exists $hash{$hey}{$key}){
			print "$hash{$hey}{$key}\n";
			print OU "\t$hash{$hey}{$key}";
		}else{
			print OU "\t0";
		}
	}
	print OU "\n";
}
close OU;
