#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

Getopt::Long::Configure('no_ignore_case');

#declare global variables, hashes and arrays
my $duplicate;
my $unique;
my $number = -1;
my $header_text;
my $help;
my $header;
my %line1;
my @uniq;
my @dup;

#set input flags
GetOptions(
"H" => \$header,
"unique" => \$unique,
"number:i" => \$number,
"help" => \$help) or die("Error in command line arguments -h for help\n");

#return help flag
help_me() if ($help);

#check for incorrect usage of -d and -u
die "Error in command line arguments --h for help\n" if ($number > -1 && $unique);

#determine file number for n to be called without a value, file number will correspond to
#lines present in every file
if ($number == 0){
    $number = scalar @ARGV;
}

#command line input
foreach(@ARGV){
    line_hash1($_);
}

#add hash keys to uniq and dup arrays
if ($header){
    print "$header_text\n";
}

#print logic for command line options and 
foreach my $line (sort keys %line1){

    
        print "$line\n" if ($number > -1 && $number <= $line1{$line}); # $number: command line (min num files for rep)
                                                                       # $line1{$line}: num of files line observed in
        print "$line\n" if ($unique && $line1{$line} == 1);
        print "$line\n" if (!$unique && $number == -1);

}


    
#print "Hash line1=";
#print Dumper(\%line1);
exit;

###################################################
#use first observed line as header if flagged, populate hash with line name as key
#Duplicate line names removed, keys can not be duplicated in hash.
#increment any names repeated more than once, indicates they are duplicates.

#subroutine to find duplicates within and between files
sub line_hash1{
    my %observed;
    my $input = shift;
    open(FILE, $input) or die $!;
    if ($header){
        $header_text = <FILE>;
        chomp $header_text;
        }
        while (<FILE>){
            chomp;
            #hash to remove duplicate names from individual file
            $observed{$_}++;
            next if $observed{$_} > 1;
                    }
                    #hash to find duplicate names between files
                    foreach my $unq (sort keys %observed){
                        $line1{$unq} += 1;
                        }
    close FILE;
}


#subroutine returns correct file usage
sub help_me {
    print
    "
    Returns a join of multiple files, similar to GNU join.
usage: myjoin [options] file1 file2 [file3...]
options:
    -h, --help this help text
    -H  files contain a header line
    -u  returns list of unique lines[mutually exclusive with -d]
    -d  returns list of duplicate lines [mutually exclusive with -u]
    ";
    exit;
}

