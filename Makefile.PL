use strict;
use warnings;

use inc::Module::Install;

name          ('Software-License');
author        ('Ricardo Signes <rjbs@cpan.org>');
license       ('perl');
all_from      ('lib/Software/License.pm');

requires('Data::Section'       => '0.000'); # minimum unknown
requires('Sub::Install'        => '0.000'); # minimum unknown
requires('Text::Template'      => '0.000'); # minimum unknown

build_requires('Test::More'    => '0.88'); # done_testing!

extra_tests;

repository('http://github.com/rjbs/software-license');
auto_manifest;

WriteAll();
