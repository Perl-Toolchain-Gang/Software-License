use strict;
use warnings;
package Software::LicenseUtils;

=head1 NAME

Software::LicenseUtils - little useful bits of code for licensey things

=head1 METHODS

=head2 license_from_pm

  my $license_class = Software::LicenseUtils->guess_license_from_pm($pm_text);

Given text containing POD, like a .pm file, this method will attempt to guess
at the license under which the code is available.  This method will either
return a Software::License class, Software::License object, or undef.

=cut

my @phrases = (
  'under the same (?:terms|license) as perl' => 'Perl_5',
  'GNU public license'                       => 'GPL_2_0',
  'GNU lesser public license'                => 'LGPL_2_0',
  'BSD license'                              => 'BSD',
  'Artistic license'                         => 'Artistic_1_0',
  'GPL'                                      => 'GPL',
  'LGPL'                                     => 'LGPL_2_0',
  'BSD'                                      => 'BSD',
  'Artistic'                                 => 'Artistic_1_0',
  'MIT'                                      => 'MIT',
  'proprietary'                              => 'proprietary',
);

sub guess_license_from_pm {
  my ($class, $pm_text) = @_;

	if (
		$pm_text =~ m/
      (
        =head \d \s+
        (?:licen[cs]e|licensing|copyright|legal)\b
        .*?
      )
      (=head\\d.*|=cut.*|)
      \z
    /ixms
  ) {
		my $license_text = $1;

    for (my $i = 0; $i < @phrases; $i += 2) {
      my ($pattern, $license) = @phrases[ $i .. $i+1 ];
			$pattern =~ s{\s+}{\\s+}g;
			if ( $license_text =~ /\b$pattern\b/i ) {
				# if ( $osi and $license_text =~ /All rights reserved/i ) {
				# 	warn "LEGAL WARNING: 'All rights reserved' may invalidate Open Source licenses. Consider removing it.";
				# }
				return "Software::License::$license";
			}
		}
	}

	return;
}

1;
