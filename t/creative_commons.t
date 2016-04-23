#!perl

use strict;
use warnings;
use Test::More;
use Software::LicenseUtils;

BEGIN {
  eval "require Software::License::CC_BY_1_0; 1"
  or plan skip_all => "requires Software::License::CCpack to test this";
}

{
  my $license = Software::License::CC_BY_1_0->new({holder => 'DUMMY'})->notice;
  my $pod = "=head1 LICENSE\n\n$license\n=cut\n";
  is_deeply(
    [Software::LicenseUtils->guess_license_from_pod($pod)],
    ['Software::License::CC_BY_1_0'],
  );
}

done_testing;
