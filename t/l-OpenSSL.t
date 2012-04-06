#!perl
use strict;
use warnings;

use Test::More tests => 4;

my $class = 'Software::License::OpenSSL';
require_ok($class);

my $license = $class->new({holder => 'X. Ample',});

like($license->name, qr/openssl/i, "license name");

my $fulltext = $license->fulltext;
like($fulltext, qr/OpenSSL Toolkit/, 'license text');
like($fulltext, qr/Copyright remains Eric Young/, 'license text (SSLeay)');
