use warnings;
use strict;

## trying to prove collision-free hashing
use constant { ITERATIONS => 10000 };

use Test::More tests => ITERATIONS*2 + 4;
use Digest::MurmurHash qw(murmur_hash);


sub randstr {
    my $len = shift;
    return join '', map { chr(int rand 256) } (0..$len);
}

my (%tests, %results);

# perl rand should not give same sequence on 5-char strings but it can...
$tests{randstr(5+int(rand 300))} = 1 while keys %tests < ITERATIONS;

for my $test_str ( keys %tests ) {
    my $hash = murmur_hash($test_str);
    is(++$results{$hash}, 1, "Not colliding hash on 5+ byte string");
    is(murmur_hash($test_str), $hash, "Consistent hash result");
}


is(scalar(keys %tests), scalar(keys %results), "All test strings hashed");

is(murmur_hash(''), '', "Empty value makes empty result");
is(murmur_hash(undef), '', "Empty value makes empty result");
ok(murmur_hash(0) > 0, "Zero value makes good result");
