#!perl
use strict;
use warnings;
use Test::More;

use Software::License;
use Software::LicenseUtils;

my @round_trippable = qw(
  AGPL_3
  Artistic_1_0 Artistic_2_0
  BSD
  GPL_1 GPL_2 GPL_3
  LGPL_2_1 LGPL_3_0
  MIT
  Perl_5 
);

plan tests => 2 * @round_trippable;

for my $name (@round_trippable) {
  my $class = "Software::License::$name";
  eval "require $class; 1" or die $@;
  my $notice = $class->new({ holder => 'J. Phred Bloggs' })->notice;
  my $pod    = "=head1 LEGAL\n\n$notice\n\n=cut\n";

  my @guess  = Software::LicenseUtils->guess_license_from_pod($pod);

  is(@guess, 1, "$name: only 1 guess for license we build")
    or diag "guesses: @guess";
  is($guess[0], $class, "$name: ...and we got it right");
}
