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

  is_deeply(
    [ Software::LicenseUtils->guess_license_from_pod(build_pod($license)) ],
    [ ], # should eventually be [ 'Software::License::BSD' ],
  );
}

{
  # excerpt from Software::License::None
  my $license = <<'LICENSE';
This software is copyright (c) 2020 by Holder.  No
license is granted to other entities.
LICENSE

  is_deeply(
    [ Software::LicenseUtils->guess_license_from_pod(build_pod($license)) ],
    [ 'Software::License::None' ],
  );
}

done_testing;

sub build_pod { "=head1 LICENSE\n\n" . shift . "\n=cut\n" }
