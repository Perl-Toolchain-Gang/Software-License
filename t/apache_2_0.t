#!perl
use strict;
use warnings;
use Test::More tests => 2;

use Software::License::Apache_2_0;


my $software = Software::License::Apache_2_0->new( { holder => "me", year => 2021 } );

my $txt = $software->fulltext;

unlike $txt, qr{yyyy}, "yyyy does not appear in the license content";

like $txt, qr{Copyright 2021 me}, "Copyright [yyyy] is replaced";

done_testing;