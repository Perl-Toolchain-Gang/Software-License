#!perl
use strict;
use warnings;

use Test::More tests => 5;

my $class = 'Software::License::Perl_5';
require_ok($class);

my $license = $class->new({ holder => 'X. Ample' });

like($license->name, qr/perl 5/i, "license name");
my $fulltext = $license->fulltext;
like($fulltext, qr/general public/i, 'license text');
like($fulltext, qr/refers to the collection/i, 'license text/Artistic');
like($fulltext, qr/software companies try/i, 'license text/GPL');
