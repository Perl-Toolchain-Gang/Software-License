#!perl
use strict;
use warnings;

use Test::More tests => 5;

my $class = 'Software::License::Perl_5';
require_ok($class);

my $license = $class->new({ holder => 'X. Ample' });

is($license->holder, 'X. Ample', '(c) holder');
is($license->year, (localtime)[5]+1900, '(c) year');
like($license->name, qr/perl 5/i, "license name");
like($license->fulltext, qr/general public/i, 'license text');
