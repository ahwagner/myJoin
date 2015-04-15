#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

Getopt::Long::Configure('no_ignore_case');

#declare global variables, hashes and arrays
my $duplicate;
my $unique;
my $header_text;
my $help;
my $header;
my %line1;
my @uniq;
my @dup;

#set input flags
GetOptions("H" => \$header,
"unique" => \$unique,
"duplicate" => \$duplicate,
"help" => \$help) or die("Error in command line arguments -h for help\n");

#return help flag
help_me()  ($help);

#check for incorrect usage -d and -u
die "Error in command line arguments --h for help\n" if ($duplicate && $unique);

#command line input
foreach(@ARGV){
    line_hash1($_);
}

#add hash keys to uniq and dup arrays
if($header){
    print "$header_text\n";
}

foreach my $line(sort keys %line1){
    print "$line\n" if ($unique && $line1{$line} == 1);
    print "$line\n" if ($duplicate && $line1{$line} > 1);
    print "$line\n" if (!$unique  !$duplicate);
}

exit;

###################################################
#use first observed line as header if flagged, populate hash with line name as key
#Duplicate line names removed, keys can not be duplicated in hash.
#increment any names repeated more than once, indicates they are duplicates.

sub line_hash1{
    my $input = shift;
    open(FILE, $input) or die $!;
    if ($header){
        $header_text = <FILE>;
        chomp $header_text;
    }
    while (<FILE>){
        chomp;
        $line1{$_} += 1;
    }
    close FILE;
}



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

