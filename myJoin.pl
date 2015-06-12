#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

Getopt::Long::Configure('no_ignore_case');

#declare global variables, hashes and arrays
my $duplicate;
my $field;
my $i = 0;
my $unique;
my $number = -1;
my $header_text;
my $help;
my $header;
my $ref;
my %line1;
my %header_lib;
my %attribu;
my %count;
my @headers;
my @uniq;
my @dup;
my @field;
my @row;

#set input flags
GetOptions(
"H" => \$header,
"unique" => \$unique,
"number:i" => \$number,
"field:s" => \$field,
"help" => \$help) or die("Error in command line arguments -h for help\n");

#process field argument
@field = split(",", $field);

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


#print Dumper(\@aoa);
#print "Hash line1=";
#print Dumper(\%line1);
print Dumper(\%header_lib);
print Dumper(\@field);
#print Dumper(\@headers);
#print Dumper(\@row);
print Dumper(\%attribu);
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
        @headers = split("\t", $header_text);
        %header_lib = map {$headers[$_] => $_} 0..$#headers;
    }
#    print "reading $input\n";
    while (<FILE>){
        @row = split("\t");
#        map {print "my row $_\n";} @row;
        my $key = '';
        foreach my $k (@field){
            $ref = $header_lib{$k};
            if (exists $row[$ref]){
            $key .=  $row[$ref];
#           map {print "my row: $_\n";} @row;
            }else{
                die "input file contains empty fields";
                }
#           print "my key: $key\n";

           
            }
        #This field
        foreach my $h (keys %header_lib){
            foreach my $v (@field){
            if ($h ne $v){
            my $i = $header_lib{$h};
            $attribu{$key}{$h} = $row[$i];
                }
            }
        }

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
    -n  returns list of duplicate lines in all files,  [mutually exclusive with -u]
    n=1,2,[3...] minimum number of files line must be present in to output\n
    
    ";
}

exit;