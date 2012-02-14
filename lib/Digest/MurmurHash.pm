package Digest::MurmurHash;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.12';
our @EXPORT_OK = ('murmur_hash', 'murmurhash3_x86_32', 'murmurhash3_x86_128', 'murmurhash3_x64_128');

require XSLoader;
XSLoader::load('Digest::MurmurHash', $VERSION);

1;
__END__

=head1 NAME

Digest::MurmurHash - Perl XS interface to the MurmurHash algorithm

=head1 SYNOPSIS

  use Digest::MurmurHash qw(murmur_hash);
  murmur_hash($data_to_hash);

OR

  use Digest::MurmurHash;
  Digest::MurmurHash::murmur_hash($data_to_hash);

=head1 DESCRIPTION

The murmur hash algorithm by Austin Appleby is an exteremely fast
algorithm that combines both excellent collision resistence and
distribution characteristics.

This module requires Perl version > 5.8

=head1 BENCHMARK 

See attached contrib/benchmark.pl to check speed on your own length of data.
Real speeds may vary. Longer strings make murmurhash3_64 absolute leader.

=head1 SEE ALSO

For more information on the Murmur algorithm, visit Austin Appleby's
algorithm description page:

http://code.google.com/p/smhasher/

=head1 AUTHOR

Toru Maesaka, E<lt>dev@torum.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Toru Maesaka

MurmurHash algorithm comes from Austin Appleby.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
