#! /usr/bin/env perl

use strict;
use warnings;
use Cwd qw(getcwd);

use Exporter;

use Carp qw(croak);

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(list_all_files remove_world_write);

# VERSION 0.1.0
# ABSTRACT: Module to look up all files in directory and subdirectory

=pod

=encoding utf8

=head1 NAME

File::Mananger - Module to locate all files in directory and subdirectories.
Also will provide funtionality to modify write permissions on world writable files.


=head1 SYNOPSIS

    use strict;
    use warnings;
    use File::Manager qw(locate_all_files);

    my (@files, @directories) = locate_all_files('/path/to/directory');

=head1 DESCRIPTION

Module to look up all files and subdirectories of a given path.
Also provides functionality to remove the write permissions on world
writable files.


=head1 METHODS

=head2 locate_all_files

Takes a path to directory, returns an array reference of all files and all subdirectores
in the path given as parameter.

=head2 remove_world_write

Takes a file path, removes the world write permission on the file.

=head1 CAVEATS/LIMITATIONS

This module assumes the user is utilizing a Linux operating system.
If you are not, please use a real operating system ;)

=head1 AUTHOR

Daniel Culver, C<< perlsufi@cpan.org >>


=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

sub locate_all_files {
    my $path = shift;

    my @dirs  = split( /\n/, `find $path -type d` );
    my @files = split( /\n/, `find $path -type f` );
    return ( \@files, \@dirs );
}

sub remove_world_write {

    my $file = shift;
    system `chmod o-w $file`;

    return;
}

1;
