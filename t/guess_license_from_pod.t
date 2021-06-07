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
    [ ], # should eventually be [ 'Software::License::BSD' ],
  );
}

subtest 'apache_1_1' => sub {
  my $license = << 'LICENSE';
Apache Software License
Version 1.1

Copyright (c) 2000 The Apache Software Foundation.  All rights reserved.
LICENSE

  my @license_strings = (
    $license,
    "apache 1.1", "Apache 1.1", "APACHE 1.1",
    "apache-1.1", "Apache-1.1", "APACHE-1.1",
  );

  foreach my $license_text (@license_strings) {
    my $pod = "=head1 LICENSE\n\n" . $license_text . "\n=cut\n";

    is_deeply(
      [ Software::LicenseUtils->guess_license_from_pod($pod) ],
      [ 'Software::License::Apache_1_1' ],
      $license_text
    );
  }
};

subtest 'apache_2_0' => sub {
  my $license = << 'LICENSE';
                                 Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION
LICENSE

  my @license_strings = (
    $license,
    "apache 2.0", "Apache 2.0", "APACHE 2.0",
    "apache-2.0", "Apache-2.0", "APACHE-2.0",
  );

  foreach my $license_text (@license_strings) {
    my $pod = "=head1 LICENSE\n\n" . $license_text . "\n=cut\n";

    is_deeply(
      [ Software::LicenseUtils->guess_license_from_pod($pod) ],
      [ 'Software::License::Apache_2_0' ],
      $license_text
    );
  }
};

done_testing;
