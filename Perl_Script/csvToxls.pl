#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;

my $sourcecsv = Text::CSV->new({sep_char=>','});

my $sourcefile = $ARGV[0];
my $outfile = "final.csv";	
my $linecount = 1;
my $sourceName;
my $sourcePrio;
my $sourceCategory;
my $sourceBugcode;
my $sourceDescript;

open (LOG, "> $outfile");

open(my $sourcedata, '<', $sourcefile);
while(my $sourceline = <$sourcedata>) {
	chomp $sourceline;
	my $match = 0;
	
	if($sourcecsv->parse($sourceline)) {
		
		my @fields = $sourcecsv->fields();
		$sourceName = $fields[0];
		$sourcePrio = $fields[1];
		$sourceCategory = $fields[2];
		$sourceBugcode = $fields[3];
		$sourceDescript = $fields[4];
	}	
	print LOG "$sourceName\t$sourcePrio\t$sourceCategory\t$sourceBugcode\t$sourceDescript\n";
}
