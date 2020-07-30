#!perl

use strict;
use warnings;

use Test::More;
use Software::LicenseUtils;

{
  # excerpt from BSD License
  my $license = <<'LICENSE';
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

  * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  * Neither the name of {{$self->holder}} nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.
LICENSE

  my $pod = "=head1 LICENSE\n\n".$license."\n=cut\n";
  is_deeply(
    [ Software::LicenseUtils->guess_license_from_pod($pod) ],
    [ 'Software::License::None' ], # should eventually be [ 'Software::License::BSD' ],
  );
}

{
  my $license = <<'LICENSE';
Do what you want.
LICENSE

  my $pod = "=head1 LICENSE\n\n".$license."\n=cut\n";
  is_deeply(
    [ Software::LicenseUtils->guess_license_from_pod($pod) ],
    [ ],
  );
}

done_testing;
