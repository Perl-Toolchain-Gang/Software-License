#!perl
use strict;
use warnings;

use Test::More tests => 6;

my $class = 'Software::LicenseUtils';
require_ok($class);

my $license = $class->new_from_short_name({ 
    short_name => 'GPL-1', 
    holder => 'X. Ample' 
});

is($license->holder, 'X. Ample', '(c) holder');
is($license->year, (localtime)[5]+1900, '(c) year');
isa_ok($license,'Software::License::GPL_1',"license class");
like($license->name, qr/version 1/i, "license name");
like($license->fulltext, qr/general public/i, 'license text');
