#!perl
use strict;
use warnings;
use Test::More tests => 23;

# spdx names can be found: https://github.com/OpenSourceOrg/licenses/blob/master/licenses/spdx/spdx.json

use Software::License::AGPL_3;
use Software::License::Apache_1_1;
use Software::License::Apache_2_0;
use Software::License::Artistic_1_0;
use Software::License::Artistic_2_0;
use Software::License::BSD;
use Software::License::CC0_1_0;
use Software::License::FreeBSD;
use Software::License::GFDL_1_2;
use Software::License::GFDL_1_3;
use Software::License::GPL_1;
use Software::License::GPL_2;
use Software::License::GPL_3;
use Software::License::LGPL_2_1;
use Software::License::LGPL_3_0;
use Software::License::MIT;
use Software::License::Mozilla_1_0;
use Software::License::Mozilla_1_1;
use Software::License::Mozilla_2_0;
use Software::License::OpenSSL;
use Software::License::PostgreSQL;
use Software::License::QPL_1_0;
use Software::License::Zlib;

is (scalar(Software::License::AGPL_3->spdx_name()),
    'AGPL-3.0', 
    "AGPL_3->spdx_name() is OK."
);

is (scalar(Software::License::Apache_1_1->spdx_name()),
    'Apache-1.1',
    "Apache_1_1->spdx_name() is OK."
);

is (scalar(Software::License::Apache_2_0->spdx_name()),
    'Apache-2.0',
    "Apache_2_0->spdx_name() is OK."
);

is (scalar(Software::License::Artistic_1_0->spdx_name()),
    'Artistic-1.0',
    "Artistic_1_0->spdx_name() is OK."
);

is (scalar(Software::License::Artistic_2_0->spdx_name()),
    'Artistic-2.0',
    "Artistic_2_0->spdx_name() is OK."
);

is (scalar(Software::License::BSD->spdx_name()),
    'BSD',
    "BSD->spdx_name() is OK."
);

is (scalar(Software::License::CC0_1_0->spdx_name()),
    'CC0-1.0',
    "CC0_1_0->spdx_name() is OK."
);

is (scalar(Software::License::FreeBSD->spdx_name()),
    'BSD-2-Clause-FreeBSD',
    "FreeBSD->spdx_name() is OK."
);

is (scalar(Software::License::GFDL_1_2->spdx_name()),
    'GFDL-1.2', 
    "GFDL-1_2->spdx_name() is OK."
);

is (scalar(Software::License::GFDL_1_3->spdx_name()),
    'GFDL-1.3', 
    "GFDL_1_3->spdx_name() is OK."
);

is (scalar(Software::License::GPL_1->spdx_name()),
    'GPL-1.0',
    "GPL_1->spdx_name() is OK."
);

is (scalar(Software::License::GPL_2->spdx_name()),
    'GPL-2.0', 
    "GPL_2->spdx_name() is OK."
);

is (scalar(Software::License::GPL_3->spdx_name()),
    'GPL-3.0',
    "GPL_3->spdx_name() is OK."
);

is (scalar(Software::License::LGPL_2_1->spdx_name()),
    'LGPL-2.1',
    "LGPL_2_1->spdx_name() is OK."
);

is (scalar(Software::License::LGPL_3_0->spdx_name()),
    'LGPL-3.0',
    "LGPL_3_0->spdx_name() is OK."
);

is (scalar(Software::License::MIT->spdx_name()),
    'MIT',
    "MIT->spdx_name() is OK."
);

is (scalar(Software::License::Mozilla_1_0->spdx_name()),
    'MPL-1.0',
    "Mozilla_1_0->spdx_name() is OK."
);

is (scalar(Software::License::Mozilla_1_1->spdx_name()),
    'MPL-1.1',
    "Mozilla_1_1->spdx_name() is OK."
);

is (scalar(Software::License::Mozilla_2_0->spdx_name()),
    'MPL-2.0',
    "Mozilla_2_0->spdx_name() is OK."
);

is (scalar(Software::License::OpenSSL->spdx_name()),
    'OpenSSL',
    "OpenSSL->spdx_name() is OK."
);

is (scalar(Software::License::PostgreSQL->spdx_name()),
    'PostgreSQL',
    "PostgreSQL->spdx_name() is OK."
);

is (scalar(Software::License::QPL_1_0->spdx_name()),
    'QPL-1.0',
    "QPL_1_0->spdx_name() is OK."
);

is (scalar(Software::License::Zlib->spdx_name()),
    'Zlib',
    "Zlib->spdx_name() is OK."
);

