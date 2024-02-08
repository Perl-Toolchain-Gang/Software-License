#!perl
use strict;
use warnings;
use Test::More tests => 25;

# spdx names can be found: https://github.com/OpenSourceOrg/licenses/blob/master/licenses/spdx/spdx.json

use Software::License::AGPL_3;
use Software::License::Apache_1_1;
use Software::License::Apache_2_0;
use Software::License::Artistic_1_0;
use Software::License::Artistic_2_0;
use Software::License::BSD;
use Software::License::CC0_1_0;
use Software::License::EUPL_1_1;
use Software::License::EUPL_1_2;
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

is (scalar(Software::License::AGPL_3->spdx_expression()),
    'AGPL-3.0',
    "AGPL_3->spdx_expression() is OK."
);

is (scalar(Software::License::Apache_1_1->spdx_expression()),
    'Apache-1.1',
    "Apache_1_1->spdx_expression() is OK."
);

is (scalar(Software::License::Apache_2_0->spdx_expression()),
    'Apache-2.0',
    "Apache_2_0->spdx_expression() is OK."
);

is (scalar(Software::License::Artistic_1_0->spdx_expression()),
    'Artistic-1.0',
    "Artistic_1_0->spdx_expression() is OK."
);

is (scalar(Software::License::Artistic_2_0->spdx_expression()),
    'Artistic-2.0',
    "Artistic_2_0->spdx_expression() is OK."
);

is (scalar(Software::License::BSD->spdx_expression()),
    'BSD-3-Clause',
    "BSD->spdx_expression() is OK."
);

is (scalar(Software::License::CC0_1_0->spdx_expression()),
    'CC0-1.0',
    "CC0_1_0->spdx_expression() is OK."
);

is (scalar(Software::License::EUPL_1_1->spdx_expression()),
    'EUPL-1.1',
    "EUPL_1_1->spdx_expression() is OK."
);

is (scalar(Software::License::EUPL_1_2->spdx_expression()),
    'EUPL-1.2',
    "EUPL_1_2->spdx_expression() is OK."
);

is (scalar(Software::License::FreeBSD->spdx_expression()),
    'BSD-2-Clause-FreeBSD',
    "FreeBSD->spdx_expression() is OK."
);

is (scalar(Software::License::GFDL_1_2->spdx_expression()),
    'GFDL-1.2-or-later',
    "GFDL-1_2->spdx_expression() is OK."
);

is (scalar(Software::License::GFDL_1_3->spdx_expression()),
    'GFDL-1.3-or-later',
    "GFDL_1_3->spdx_expression() is OK."
);

is (scalar(Software::License::GPL_1->spdx_expression()),
    'GPL-1.0-only',
    "GPL_1->spdx_expression() is OK."
);

is (scalar(Software::License::GPL_2->spdx_expression()),
    'GPL-2.0-only',
    "GPL_2->spdx_expression() is OK."
);

is (scalar(Software::License::GPL_3->spdx_expression()),
    'GPL-3.0-only',
    "GPL_3->spdx_expression() is OK."
);

is (scalar(Software::License::LGPL_2_1->spdx_expression()),
    'LGPL-2.1',
    "LGPL_2_1->spdx_expression() is OK."
);

is (scalar(Software::License::LGPL_3_0->spdx_expression()),
    'LGPL-3.0',
    "LGPL_3_0->spdx_expression() is OK."
);

is (scalar(Software::License::MIT->spdx_expression()),
    'MIT',
    "MIT->spdx_expression() is OK."
);

is (scalar(Software::License::Mozilla_1_0->spdx_expression()),
    'MPL-1.0',
    "Mozilla_1_0->spdx_expression() is OK."
);

is (scalar(Software::License::Mozilla_1_1->spdx_expression()),
    'MPL-1.1',
    "Mozilla_1_1->spdx_expression() is OK."
);

is (scalar(Software::License::Mozilla_2_0->spdx_expression()),
    'MPL-2.0',
    "Mozilla_2_0->spdx_expression() is OK."
);

is (scalar(Software::License::OpenSSL->spdx_expression()),
    'OpenSSL',
    "OpenSSL->spdx_expression() is OK."
);

is (scalar(Software::License::PostgreSQL->spdx_expression()),
    'PostgreSQL',
    "PostgreSQL->spdx_expression() is OK."
);

is (scalar(Software::License::QPL_1_0->spdx_expression()),
    'QPL-1.0',
    "QPL_1_0->spdx_expression() is OK."
);

is (scalar(Software::License::Zlib->spdx_expression()),
    'Zlib',
    "Zlib->spdx_expression() is OK."
);

