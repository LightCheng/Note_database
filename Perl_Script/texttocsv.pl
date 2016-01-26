#!/usr/bin/perl

$sourcefile = $ARGV[0];
#$outputfile = "all_log_convert.csv";
if(length $ARGV[1]){
$outputfile = "$ARGV[1]_converted.csv";
} else {
$outputfile = "test_log_convert.csv";
}
print "$outputfile \n";
open(OUTPUT, "> $outputfile");
open(my $sourcedata, '<', $sourcefile) || die "Can't open file $filename : $!\n";
#open my $sourcedata, $sourcefile or die "Could not open $sourcefile: $!";
while(my $sourceline = <$sourcedata>) {
	chomp $sourceline;
	$sourceline =~ s/\t/\,/gi;
	$sourceline =~ s/\:\,/\:\,\"/gi;
	$sourceline =~ s/$/\"/gi;
	print OUTPUT "$sourceline\n";
}
close $sourcedata
