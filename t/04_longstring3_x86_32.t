use warnings;
use strict;

use Test::More 'no_plan';
use Digest::MurmurHash qw(murmurhash3_x86_32);

use constant { ITERATIONS => 1000 };

sub randstr {
    my ($len) = @_;
    my @chars = ("a".."z", 'A'..'Z', '0'..'9');
    my $buf = ""; 

    foreach (1..$len) {
        $buf .= $chars[rand @chars];
    }
    return $buf;
}

my ($test_str, $i);
my %results = ();

for ($i=0; $i<ITERATIONS; $i++) {
    $test_str = randstr(2048);
    $results{$test_str} = murmurhash3_x86_32($test_str, 0); 
}

is(keys(%results), ITERATIONS, "Collision Found");

# Test for consistent result.
for my $key (keys %results) {
    is(murmurhash3_x86_32($key, 0), $results{$key}, "Inconsistent Hash");
}
