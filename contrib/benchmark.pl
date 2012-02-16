#!/usr/bin/perl -w


## DISCLAIMER: benchmarking is not performance report and cannot
## replace profiling!

use warnings;
use strict;

use String::CRC32;
use Digest::JHash;
use Digest::MurmurHash 0.12;
use Digest::SHA1;
use Digest::MD5;
use Digest::Pearson;
use Digest::FNV;
use UUID;
use Benchmark ':hireswallclock';

my $len = shift || 32;
my $teststring = join '', map { chr(int rand 256) } (0..$len);

my $murmur = sub { return Digest::MurmurHash::murmur_hash($teststring) };
my $murmur1 = sub { return Digest::MurmurHash::murmurhash1($teststring,0) };
my $murmur3_32 = sub { return Digest::MurmurHash::murmurhash3_x86_32($teststring,0) };
my $murmur3_128 = sub { return Digest::MurmurHash::murmurhash3_x86_128($teststring,0) };
my $murmur3_64_128 = sub { return Digest::MurmurHash::murmurhash3_x64_128($teststring,0) };

my $jhash  = sub { return Digest::JHash::jhash($teststring) };
my $crc32  = sub { return String::CRC32::crc32($teststring) };
my $sha1  = sub { return Digest::SHA1::sha1($teststring) };
my $md5  = sub { return Digest::MD5::md5($teststring) };
my $pearson = sub { return Digest::Pearson::pearson($teststring) };
my $fnv = sub { return Digest::FNV::fnv($teststring) };
my $uuid = sub { return UUID::generate($teststring) };

my $results = Benchmark::timethese(10000000, {
	murmur => $murmur,
	murmur1 => $murmur1,
	murmur3_32 => $murmur3_32,
	murmur3_128 => $murmur3_128,
	murmur3_64_128 => $murmur3_64_128,
	jhash => $jhash,
	crc32 => $crc32,
	md5 => $md5,
	sha1 => $sha1,
	pearson => $pearson,
	fnv => $fnv,
	uuid => $uuid
});

my $rows = Benchmark::cmpthese( $results, "none" ) ;

for my $reslt (@$rows) {
	print join "\t", @$reslt[0,1];
	print "\n";
}
