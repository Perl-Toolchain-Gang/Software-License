#!perl
use strict;
use warnings;
use Test::More tests => 1;

use Software::License::BSD;

# TEST
is (scalar(Software::License::BSD->url()),
    'http://www.opensource.org/licenses/bsd-license.php',
    "BSD->url() is OK."
);

