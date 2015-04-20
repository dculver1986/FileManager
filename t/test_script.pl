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
use IPC::System::Simple qw(capture run);

my $help = !@ARGV;
my $verbose = 0;
my $user;

my $valid_options = GetOptions(
    'help'     => \$help,
    'verbose'  => \$verbose,
    "user=s"     => \$user,
);

if ( !$valid_options || $help ) {
    my $file_name = File::Basename::basename($0);
    my $usage = <<"USAGE";
        Usage: perl $file_name [ --help ] [--verbose] [ --user ]

        General options:
            --help      Displays this help message
            --verbose   Displays verbose output
            --user      Searches for files and directories of user

        * NOTE: you may need to run this as perl -I lib $file_name

USAGE

    print STDERR $usage;
    exit(1);
}

my $path = $ARGV[0];
### Specified path is: ($path)
### Retrieving files and subdirectories...
if ( $user ) {
    my ($files, $dirs ) = locate_all_files($path);
    my $file_results;
    my @split_file_results;

    for my $file ( @{$files} ) {
         $file_results = capture("ls -l $file");
         @split_file_results = split /\s/, $file_results;

         if ( $split_file_results[2] eq $user ) {
            ### File found for user: ($user)
            remove_world_write($file);
            print $file,"\n";
        }
        @split_file_results = ();
    }

    my $dir_results;
    my @split_dir_results;
    for my $dir ( @{$dirs} ) {
        $dir_results = capture("ls -l $dir");
        @split_dir_results = split /\s/, $dir_results;
        if( scalar(@split_dir_results) && $split_dir_results[4] eq $user ) {
            ### Directory found for user: ($user)
            print $dir,"\n";
        }
        else {  next; }
    }
}

else {
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
}
