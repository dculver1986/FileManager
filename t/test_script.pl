#!/usr/bin/perl
use strict;
use warnings;

local $| = 1;

## no critic (Variables::RequireLocalizedPunctuationVars)
BEGIN {
    if ( " @ARGV " =~ / --verbose / ) {
        $ENV{Smart_Comments} =
          ( $ENV{Smart_Comments} ? $ENV{Smart_Comments} . ':' : '' ) . '###';
    }
}
## use critic

use Getopt::Long;
use File::Manager qw(locate_all_files);
use File::Basename;
use Data::Dumper;
use Smart::Comments -ENV;


my $help = !@ARGV;
my $verbose = 0;

my $valid_options = GetOptions(
    'help'     => \$help,
    'verbose'  => \$verbose,
);

if ( !$valid_options || $help ) {
    my $file_name = File::Basename::basename($0);
    my $usage = <<"USAGE";
        Usage: perl $file_name [ --help ] [--verbose]

        General options:
            --help      Displays this help message
            --verbose   Displays verbose output

        * NOTE: you may need to run this as perl -I lib $file_name

USAGE

    print STDERR $usage;
    exit(1);
}

my $path = $ARGV[0];
### Specified path is: ($path)
### Retrieving files and subdirectories...

my ($files, $dirs ) = locate_all_files($path);

for my $file ( @{$files} ) {

    ### File Found!
    print $file,"\n";
    remove_world_write($file);

}

for my $dir ( @{$dirs} ) {

    ### Directory found!
    print $dir,"\n";
}


