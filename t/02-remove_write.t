#!/usr/bin/perl
use strict;
use warnings;
use Cwd qw(getcwd);

use Test::More;

use File::Manager qw(locate_all_files remove_world_write);
use IPC::System::Simple qw(capture run);

subtest "Remove write permissions for file" => sub {

    my $cwd = getcwd;

    my $file = getcwd.'/testfile.txt';
    chmod(0777, $file);
    remove_world_write($file);

    my $result = capture("ls -l $file");

    my @split_results = split /\s/, $result;
    my $perm_string = '-rwxrwxr-x';
    ok( ( grep { $_ eq $perm_string } @split_results ) );
};
done_testing;
