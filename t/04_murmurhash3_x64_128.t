use warnings;
use strict;

## trying to prove collision-free hashing
use constant { ITERATIONS => 10000 };
use Test::More tests => ITERATIONS*3 + 4;
use Digest::MurmurHash qw(murmurhash3_x64_128);


sub randstr {
    my $len = shift;
    return join '', map { chr(int rand 256) } (0..$len);
}


my $str; eval { die; $str = pack("Q", 1) };

my (%tests, %results);

SKIP: {


skip "Missing 64 bit support", ITERATIONS*3 + 4 unless $str;
$tests{randstr(5+int(rand 300))} = 1 while keys %tests < ITERATIONS;
for my $test_str ( keys %tests ) {
    my $hash = murmurhash3_x64_128($test_str, 0);
    is(length($hash), 16, "Correct result strlen");
    is(++$results{$hash}, 1, "Not colliding hash on 5+ byte string");
    is(murmurhash3_x64_128($test_str, 0), $hash, "Consistent hash result");
}


is(scalar(keys %tests), scalar(keys %results), "All test strings hashed");

is(murmurhash3_x64_128('',0), '', "Empty value makes empty result");
is(murmurhash3_x64_128(undef,0), '', "Empty value makes empty result");
is(length(murmurhash3_x64_128(0,0)), 16, "Zero value makes good result");

};
