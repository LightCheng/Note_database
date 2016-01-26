#!/usr/bin/perl
use strict;
use warnings;

my $sourcefile = $ARGV[0];
my $comparefile = $ARGV[1];
my $outfile = "output.csv";	
my $linecount = 1;
my $NotMatchcount = 0;
my $sourceName;
my $compareName;
my $sourceDescript;
my $compareDescript;

open (LOG, "> $outfile");

open(my $sourcedata, '< :raw', $sourcefile) || die "Can't open file $sourcefile : $!\n";
open(my $comparedata, '< :raw', $comparefile) || die "Can't open file $comparefile : $!\n";
print "sourcefile : $sourcefile , be compared file : $comparefile \n";
#print LOG "Type,CEI_Comment,Function,Team,Confidence,Group,Pattern,Descriptions\n";
while(my $sourceline = <$sourcedata>) {
#if(my $sourceline = <$sourcedata>) {
	chomp $sourceline;
	my $match = 0;
	#if($sourcecsv->parse($sourceline)) {
		
        #my @fields = $sourcecsv->fields();
	        my $bReset = 0;
		#$sourceName = $fields[0];
		$sourceName = $sourceline;
		#$sourceDescript = $fields[4];
                for (my $i=0; $i < 3; $i++) {
                    $sourceName =  substr $sourceName, index($sourceName, ',')+1;
                }
                $sourceName =~ /(.*?),/;
                $sourceName = $1;

                #print "sourceName : $sourceName\n";
		$sourceDescript = $sourceline;
		for (my $i=0; $i < 7; $i++) {
 		   $sourceDescript =  substr $sourceDescript, index($sourceDescript, ',')+1;
 		}
                #print "$sourceName \n";
		$sourceDescript =~ /(.*?)\.java/;
		$sourceDescript = $1;
                $sourceDescript =~ s/at line [0-9]+ of/at line  of/g;
		#print "Source description : $sourceDescript\n";
		while(my $compareline = <$comparedata>) {
			chomp $compareline;
			
			#if($comparecsv->parse($compareline)) {
				
				#my @fields = $comparecsv->fields();
				#$compareName = $fields[0];
				$compareName = $compareline;
                                for (my $i=0; $i < 3; $i++) {
                                   $compareName =  substr $compareName, index($compareName, ',')+1;
                                }
				$compareName =~ /(.*?),/;
                                #print "compareName : $compareName\n";
				$compareName = $1;
				#$compareDescript = $fields[4];
			$compareDescript = $compareline;
				for (my $i=0; $i < 7; $i++) {
 		   			$compareDescript =  substr $compareDescript, index($compareDescript, ',')+1;
				}
				$compareDescript =~ /(.*?)\.java/;
				$compareDescript = $1;
			#}
                        #print "Compare descriptioin : $compareDescript\n";
			if(($sourceName eq $compareName) && ($sourceDescript eq $compareDescript)){
				$match = 1;
				last;
			}
		}
                if(($match eq 0) && eof($comparedata)){
                        #seek to top only when search to the end of comparedata.
			seek($comparedata, 0, 0);
			while(my $compareline = <$comparedata>) {
				chomp $compareline;
			
				#if($comparecsv->parse($compareline)) {
				
					#my @fields = $comparecsv->fields();
					#$compareName = $fields[0];
					$compareName = $compareline;
                                        for (my $i=0; $i < 3; $i++) {
                                           $compareName =  substr $compareName, index($compareName, ',')+1;
                                        }
					$compareName =~ /(.*?),/;
					$compareName = $1;
					#$compareDescript = $fields[4];
					$compareDescript = $compareline;
					for (my $i=0; $i < 7; $i++) {
 		   				$compareDescript =  substr $compareDescript, index($compareDescript, ',')+1;
					}
					$compareDescript =~ /(.*?)\.java/;
					$compareDescript = $1;
                                        $compareDescript =~ s/at line [0-9]+ of/at line  of/g;
				#}
			
				if(($sourceName eq $compareName) && ($sourceDescript eq $compareDescript)){
					$match = 1;
					last;
				}
			}
			$bReset = 1;
                }
            #print "Compare name : $compareName\n";

		if(!$match){
			#print "NOOOOmatch\n";
                        $NotMatchcount ++;
			print LOG "$sourceline\n";
		}
	#}	
	#print "$linecount\n";
	$linecount ++;
}
print "Total Not Match number : $NotMatchcount\n";
#print "$linecount\n";
