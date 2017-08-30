#!perl
use strict;
use warnings;

use Test::More;

my @licenses = qw(
    AGPL_3
    Apache_1_1
    Apache_2_0
    Artistic_1_0
    Artistic_2_0
    BSD
    CC0_1_0
    EUPL_1_1
    EUPL_1_2
    FreeBSD
    GFDL_1_2
    GPL_1
    GPL_2
    GPL_3
    LGPL_2_1
    LGPL_3_0
    MIT
    Mozilla_1_0
    Mozilla_1_1
    Mozilla_2_0
    None
    OpenSSL
    Perl_5
    QPL_1_0
    SSLeay
    Sun
    Zlib
);

for my $l (@licenses) {
    my $class = 'Software::License::' . $l;
    require_ok($class);

    my $license = $class->new( { holder => 'Corporation, Inc.' } );

    unlike(
        $license->notice, qr/\QCorporation, Inc../,
        "holder with trailing dot does not leave two dots in notice text - $l"
    );
    unlike(
        $license->license, qr/\QCorporation, Inc../,
        "holder with trailing dot does not leave two dots in license text - $l"
    );
}

done_testing;
