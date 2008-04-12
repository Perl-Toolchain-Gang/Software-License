use strict;
use warnings;
package Software::LicenseUtils;

=head1 NAME

Software::LicenseUtils - little useful bits of code for licensey things

=head1 METHODS

=head2 guess_license_from_pod

  my @guesses = Software::LicenseUtils->guess_license_from_pod($pm_text);

Given text containing POD, like a .pm file, this method will attempt to guess
at the license under which the code is available.  This method will either
a list of Software::License classes (or instances) or false.

Calling this method in scalar context is a fatal error.

=cut

my $_v = qr/(?:v(?:er(?:sion|\.))(?: |\.)?)/i;
my @phrases = (
  "under the same (?:terms|license) as perl $_v?6" => [],
  'under the same (?:terms|license) as perl' => 'Perl_5',
  'affero g'                                 => 'AGPL_3',
  "GNU public license $_v?([123])"           => sub { "GPL_$_[0]_0" },
  'GNU public license'                       => [ map {"GPL_$_\_0"} (1..3) ],
  "GNU lesser public license $_v?([23])\\D"  => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'GNU lesser public license'  => [ qw(LGPL_2_1 LGPL_3_0) ],
  'BSD license'                => 'BSD',
  "Artistic license $_v?(\\d)" => sub { "Artistic_$_[0]_0" },
  'Artistic license'           => [ map { "Artistic_$_\_0" } (1..2) ],
  "GPL $_v?(\\d)"              => sub { "GPL_$_[0]_0" },
  'GPL'                        => [ map { "GPL_$_\_0" } (1..3) ],
  "LGPL $_v?(\\d)"             => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'LGPL'                       => [ qw(LGPL_2_1 LGPL_3_0) ],
  'BSD'                        => 'BSD',
  'Artistic'                   => [ map { "Artistic_$_\_0" } (1..2) ],
  'MIT'                        => 'MIT',
);

sub guess_license_from_pod {
  my ($class, $pm_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

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
			if ( $license_text =~ /$pattern/i ) {
        my $match = $1;
				# if ( $osi and $license_text =~ /All rights reserved/i ) {
				# 	warn "LEGAL WARNING: 'All rights reserved' may invalidate Open Source licenses. Consider removing it.";
				# }
        my @result = (ref $license||'') eq 'CODE'  ? $license->($match)
                   : (ref $license||'') eq 'ARRAY' ? @$license
                   :                                 $license;

        return unless @result;
				return map { "Software::License::$_" } @result;
			}
		}
	}

	return;
}

my %yaml_keys = (
  perl         => 'Perl_5',
  apache       => [ map { "Apache_$_" } qw(1_1 2_0) ],
  artistic     => 'Artistic_1_0',
  artistic_2   => 'Artistic_2_0',
  lgpl         => [ map { "LGPL_$_" } qw(2_1 3_0) ],
  bsd          => 'BSD',
  gpl          => [ map { "GPL_$_" } qw(1_0 2_0 3_0) ],
  mit          => 'MIT',
  mozilla      => [ map { "Mozilla_$_" } qw(1_0 1_1) ],
);

=head2 guess_license_from_meta_yml

  my @guesses = Software::LicenseUtils->guess_license_from_meta_yml($yaml_str);

Given the content of the META.yml file found in a CPAN distribution, this
method makes a guess as to which licenses may apply to the distribution.  It
will return a list of zero or more Software::License instances or classes.

=cut

sub guess_license_from_meta_yml {
  my ($class, $yaml_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

  my ($license_text) = $yaml_text =~ m{^license: (.+)}gm;

  return unless $license_text and my $license = $yaml_keys{ $license_text };
  return "Software::License::$license";
}

1;
