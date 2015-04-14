#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

#declare global variables, hashes and arrays
my $duplicate;
my $unique;
my $head;
my $help;
my $ph;
my %gene1;
my @uniq;
my @dup;

#set input flags
GetOptions ("ph" => \$ph,
            "unique" => \$unique,
            "duplicate" => \$duplicate,
            "help" => \$help)or die ("Error in command line arguments -h for help\n");

#return help flag
if ($help){
    help_me();
}

#command line input
foreach(@ARGV){
	gene_hash1($_);
}

#add hash keys to uniq and dup arrays
foreach my $gene_name(sort keys %gene1){
if ($gene1{$gene_name} == 1){
    push(@uniq, $gene_name);
    }else{
        push(@dup, $gene_name);
        @dup = sort(@dup);
    }
}

#confirm arays populated correctly
#print Dumper(@uniq);
#print Dumper(@dup);

#combine unique and duplicate arrays for complete sorted list
my @combined = (@uniq, @dup);
@combined = sort(@combined);

#print statements
if ($help){
    help_me();
}
elsif ($ph){
    print "$head\n";
}
if (!$duplicate && !$unique){
    array_print(\@combined);
}elsif($duplicate && $unique){
    die "Error in command line arguments --h for help\n";
}elsif($duplicate){
    array_print(\@dup);
}elsif($unique){
    array_print(\@uniq);
}

exit;


###################################################

#Use first observed line as header if flagged, populate hash with gene name as hash key.
#Duplicate gene names removed keys cannot be duplicated in hash.
#increment any names repeated more than once, indicates they are duplicates.
sub gene_hash1{
	my $input = shift;
    open(FILE, $input);
    if ($ph){
    $head = <FILE>;
    chomp $head;
    }
	while (<FILE>){
		chomp;
		my @data = split("\t");
		$gene1{$data[0]} += 1;
            }
	close FILE;
}

#access and print arrays
sub array_print {
    my @array = @{$_[0]};
    foreach(@array){
        print "$_\n";
    }
}

#sub routine to print help statement
sub help_me {

    print "usage: myjoin [file1] [file2]\n-no command options returns unique list\n-ph pulls first line, uses it as a header\n-u returns list of unique names\n-d returns list of duplicate names\n-u -d not accepted at the same time\n";
    exit;

}
