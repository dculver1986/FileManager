#!/usr/bin/perl
use strict;
use warnings;
use Cwd qw(getcwd);

use Test::More;

use File::Manager qw(locate_all_files remove_world_write);
use File::stat;
use Data::Dumper;
use Readonly;


subtest "Get all files in the fake directory" => sub {
    my $fake_dir = getcwd . '/t/fake_dir';
    my $fake_dir_file = getcwd.'/t/fake_dir/fake_dir_file.txt';
    my $fake_sub_dir  = getcwd.'/t/fake_dir/fake_subdir';
    my $fake_sub_dir_file = $fake_sub_dir .'/fake_subdir_file.txt';

    my ($files, $subdirs) = locate_all_files($fake_dir);

    ok( ( grep { $_ eq $fake_dir_file } @{$files} ), 'Found fake_dir file OK' );
    ok( ( grep { $_ eq $fake_sub_dir } @{$subdirs} ), 'Found fake_subdir file OK' );
    ok( ( grep { $_ eq $fake_sub_dir_file } @{$files} ), 'Found subdirectory file OK');
};

subtest "Remove write permissions for file" => sub {

    my $cwd = getcwd;

    my $file = getcwd.'/testfile.txt';
    chmod(777, $file);
    my $mod = remove_world_write($file);
    print "HEREEE: ". stat($file),"\n";

        #chmod(777, $file);
};
done_testing;
