#!perl
use strict;
use warnings;

use Test::More tests => 10;

my $class = 'Software::License::Artistic_1_0';
require_ok($class);

for my $aggregation (1 .. 2) {
   my $license = $class->new({
      holder => 'X. Ample',
      ($aggregation < 2 ? (aggregation_clause => $aggregation) : ())
   });

   like($license->name, qr/artistic/i, "license name");
   unlike($license->name, qr/without/i, "license name has no exclusion");

   my $fulltext = $license->fulltext;
   like($fulltext, qr/^8\./mxsi, 'license text');
}

my $license = $class->new({
   holder => 'X. Ample',
   aggregation_clause => 0,
});

like($license->name, qr/artistic/i, "license name");
like($license->name, qr/without/i, "license name has exclusion");

my $fulltext = $license->fulltext;
unlike($fulltext, qr/^8\./mxsi, 'license text');
