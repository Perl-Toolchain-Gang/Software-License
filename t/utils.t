use strict;
use warnings;
use Test::More tests => 2;
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
