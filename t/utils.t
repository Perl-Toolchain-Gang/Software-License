use strict;
use warnings;
use Test::More tests => 5;
use Software::LicenseUtils;

{
  my $fake_pm = <<'END_PM';

"magic true value";
__END__

=head1 LICENSE

This is released under the same terms as perl itself.

=cut

END_PM

  my @guesses = Software::LicenseUtils->guess_license_from_pod($fake_pm);

  is_deeply(
    \@guesses,
    [ 'Software::License::Perl_5' ],
    "guessed okay"
  );
}

{
  my $fake_pm = <<'END_PM';

"magic true value";
__END__

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

END_PM

  my @guesses = Software::LicenseUtils->guess_license_from_pod($fake_pm);

  is_deeply(
    \@guesses,
    [ 'Software::License::Apache_2_0' ],
    "guessed okay"
  );
}

{
    my $fake_yaml = <<'END_YAML';
---
abstract: 'packages that provide templated software licenses'
author:
  - 'Ricardo Signes <rjbs@cpan.org>'
distribution_type: module
generated_by: 'Module::Install version 0.71'
license: perl
meta-spec:
  url: http://module-build.sourceforge.net/META-spec-v1.3.html
  version: 1.3
name: Software-License
no_index:
  directory:
    - inc
    - t
requires:
  Class::ISA: 0.000
  Sub::Install: 0.000
  Text::Template: 0.000
  perl: 5.6.0
tests: 't/*.t xt/*.t'
version: 0.002
END_YAML

    my @guesses = Software::LicenseUtils->guess_license_from_meta_yml(
      $fake_yaml
    );

    is_deeply(
      \@guesses,
      [ 'Software::License::Perl_5' ],
      "guessed okay"
    );
}

{
  my $fake_yaml = <<'END_YAML';
---
abstract: 'packages that provide templated software licenses'
author:
  - 'Ricardo Signes <rjbs@cpan.org>'
distribution_type: module
generated_by: 'Module::Install version 0.71'
license: gpl
meta-spec:
  url: http://module-build.sourceforge.net/META-spec-v1.3.html
  version: 1.3
name: Software-License
no_index:
  directory:
    - inc
    - t
requires:
  Class::ISA: 0.000
  Sub::Install: 0.000
  Text::Template: 0.000
  perl: 5.6.0
tests: 't/*.t xt/*.t'
version: 0.002
END_YAML

  my @guesses = Software::LicenseUtils->guess_license_from_meta(
    $fake_yaml
  );

  is_deeply(
    \@guesses,
    [ qw(
      Software::License::GPL_1
      Software::License::GPL_2
      Software::License::GPL_3
    ) ],
    "guessed okay"
  );
}

{
  my $fake_json = <<'END_JSON';
{
   "resources" : {
      "repository" : "http://github.com/rjbs/dist-zilla"
   },
   "generated_by" : "Dist::Zilla::Plugin::MetaJSON version 1.091370",
   "version" : "1.091370",
   "name" : "Dist-Zilla",
   "requires" : {
      "DateTime" : "0.44",
      "Config::INI::MVP::Reader" : "0.018",
      "Pod::Eventual" : "0",
      "App::Cmd" : "0.200",
      "String::RewritePrefix" : "0.002",
      "Data::Section" : "0.004",
      "File::chdir" : "0",
      "YAML::XS" : "0",
      "String::Formatter" : "0",
      "Perl::Version" : "0",
      "autobox" : "2.53",
      "Software::License" : "0",
      "Archive::Tar" : "0",
      "MooseX::ClassAttribute" : "0",
      "List::MoreUtils" : "0",
      "Moose" : "0.65",
      "ExtUtils::Manifest" : "1.54",
      "String::Flogger" : "1",
      "File::Find::Rule" : "0",
      "Mixin::ExtraFields::Param" : "0",
      "File::HomeDir" : "0",
      "ExtUtils::MakeMaker" : "0",
      "CPAN::Uploader" : "0",
      "Moose::Autobox" : "0.09",
      "Test::More" : "0",
      "MooseX::Types::Path::Class" : "0",
      "Hash::Merge::Simple" : "0",
      "File::Temp" : "0",
      "Path::Class" : "0",
      "Text::Template" : "0"
   },
   "abstract" : "distribution builder; installer not included!",
   "author" : [
      "Ricardo SIGNES <rjbs@cpan.org>"
   ],
   "license" : "perl"
}
END_JSON

  my @guesses = Software::LicenseUtils->guess_license_from_meta(
    $fake_json
  );

  is_deeply(
    \@guesses,
    [ 'Software::License::Perl_5' ],
    "guessed okay"
  );
}

