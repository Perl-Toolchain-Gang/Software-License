use strict;
use warnings;
use Test::More tests => 1;
use Software::LicenseUtils;

my $fake_pm = <<'END_PM';

"magic true value";
__END__

=head1 LICENSE

This is released under the same terms as perl itself.

=cut

END_PM

my $guess = Software::LicenseUtils->guess_license_from_pm($fake_pm);

is($guess, 'Software::License::Perl_5', "guessed okay");
