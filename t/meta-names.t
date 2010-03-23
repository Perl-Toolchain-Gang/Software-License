#!perl
use strict;
use warnings;

use Test::More 0.88;

my @files = <lib/Software/License/*.pm>;

for my $module (@files) {
  # It's retired.  Dunno if it's okay to be open_source.  Punt!
  next if $module =~ /Sun.pm$/;

  my $pkg = $module;
  $pkg =~ s{^lib/}{};
  $pkg =~ s{\.pm$}{};
  $pkg =~ s{/}{::}g;

  eval "require $pkg; 1";

  ok(defined $pkg->meta_name, "$pkg provide meta_name");
}

done_testing;
