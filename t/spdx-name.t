#!perl
use strict;
use warnings;
use Test::More tests => 2;

use Software::License::BSD;
use Software::License::Mozilla_1_0;

is (scalar(Software::License::BSD->spdx_name()),
    'BSD',
    "BSD->spdx_name() is OK."
);

is (scalar(Software::License::Mozilla_1_0->spdx_name()),
    'MPL-1.0',
    "Mozilla_1_0->spdx_name() is OK."
);
