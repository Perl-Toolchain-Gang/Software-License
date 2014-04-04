use strict;
use warnings;
use Test::More tests => 8;
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
   "abstract" : "packages that provide templated software licenses",
   "author" : [
      "Ricardo Signes <rjbs@cpan.org>"
   ],
   "dynamic_config" : 0,
   "generated_by" : "Dist::Zilla version 5.014, CPAN::Meta::Converter version 2.140640",
   "license" : [
      "perl_5"
   ],
   "meta-spec" : {
      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",
      "version" : "2"
   },
   "name" : "Software-License",
   "version" : "0.103010"
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

  is_deeply(
    Software::LicenseUtils->guess_license_from_meta_json($fake_json),
    { perl_5 => [ 'Software::License::Perl_5' ] },
    "guessed okay from META.json",
  );
  
}

{
  my $fake_json = <<'END_JSON';
{
   "abstract" : "packages that provide templated software licenses",
   "author" : [
      "Ricardo Signes <rjbs@cpan.org>"
   ],
   "dynamic_config" : 0,
   "generated_by" : "Dist::Zilla version 5.014, CPAN::Meta::Converter version 2.140640",
   "license" : [
      "perl_5", "gpl_1"
   ],
   "meta-spec" : {
      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",
      "version" : "2"
   },
   "name" : "Software-License",
   "version" : "0.103010"
}
END_JSON

  my @guesses = Software::LicenseUtils->guess_license_from_meta(
    $fake_json
  );

  is_deeply(
    \@guesses,
    [ 'Software::License::Perl_5' ],
    "guessed okay from multiple licenses are specified"
  );

  is_deeply(
    Software::LicenseUtils->guess_license_from_meta_json($fake_json),
    {
      perl_5 => [ 'Software::License::Perl_5' ],
      gpl_1  => [ 'Software::License::GPL_1'  ],
    },
    "guessed multiple okay from META.json",
  );

}

