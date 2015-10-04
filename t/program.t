#!perl
use strict;
use warnings;

use Test::More tests => 5;

my $class = 'Software::License::Perl_5';
require_ok($class);

subtest 'Default' => sub {
    plan tests => 2;
    my $lic = $class->new({ holder => 'X. Ample' });
    is($lic->program, 'this program', 'program');
    is($lic->Program, 'This program', 'Program');
};

subtest 'program only' => sub {
    my $lic = $class->new({ holder => 'X. Ample', program => 'assa' });
    is($lic->program, 'assa', 'program');
    is($lic->Program, 'assa', 'Program ');
};

subtest 'Program only' => sub {
    my $lic = $class->new({ holder => 'X. Ample', Program => 'Assa' });
    is($lic->program, 'Assa', 'program ');
    is($lic->Program, 'Assa', 'Program');
};

subtest 'both program and Program' => sub {
    my $lic = $class->new({ holder => 'X. Ample', program => 'assa', Program => 'Assa' });
    is($lic->program, 'assa', 'program');
    is($lic->Program, 'Assa', 'Program ');
};
