#!perl
use strict;
use warnings;
use Test::More tests => 2;

use Software::License::BSD;
use Software::License::Mozilla_1_0;

# TEST
is (scalar(Software::License::BSD->url()),
    'http://opensource.org/licenses/BSD-3-Clause',
    "BSD->url() is OK."
);

# TEST
is (scalar(Software::License::Mozilla_1_0->url()),
    'http://www.mozilla.org/MPL/MPL-1.0.txt',
    "Mozilla_1_0->url() is OK."
);
