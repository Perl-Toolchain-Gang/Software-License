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

subtest 'apache_1_1' => sub {
  my $license = << 'LICENSE';
Apache Software License
Version 1.1

Copyright (c) 2000 The Apache Software Foundation.  All rights reserved.
LICENSE

  # https://www.apache.org/licenses/LICENSE-1.1
  # "An example Apache Software License 1.1 file"
  my $license_as_example = <<'LICENSE_AS_EXAMPLE';
The Apache Software License, Version 1.1

Copyright (c) 2000 The Apache Software Foundation.  All rights
reserved.
LICENSE_AS_EXAMPLE

  my @license_strings = (
    $license,
    $license_as_example,
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

  # https://www.apache.org/licenses/LICENSE-2.0 suggests:
  #
  #    To apply the Apache License to specific files in your work, attach
  #    the following boilerplate declaration, ...
  my $boilerplate = << 'BOILERPLATE';
Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
BOILERPLATE

  my @license_strings = (
    $license,
    $boilerplate,
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

subtest 'Unlicense' => sub {
    my $license = << 'LICENSE';
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
LICENSE

    is_deeply(
        [ Software::LicenseUtils->guess_license_from_pod( build_pod($license) ) ],
        [ 'Software::License::Unlicense' ],
        $license
    );
};


done_testing;

sub build_pod { "=head1 LICENSE\n\n" . shift . "\n=cut\n" }
