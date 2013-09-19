use strict;
use warnings;
package Software::LicenseUtils;
# ABSTRACT: little useful bits of code for licensey things

=method guess_license_from_pod

  my @guesses = Software::LicenseUtils->guess_license_from_pod($pm_text);

Given text containing POD, like a .pm file, this method will attempt to guess
at the license under which the code is available.  This method will either
a list of Software::License classes (or instances) or false.

Calling this method in scalar context is a fatal error.

=cut

my $_v = qr/(?:v(?:er(?:sion|\.))(?: |\.)?)/i;
my @phrases = (
  "under the same (?:terms|license) as perl $_v?6" => [],
  'under the same (?:terms|license) as (?:the )?perl'    => 'Perl_5',
  'affero g'                                    => 'AGPL_3',
  "GNU (?:general )?public license,? $_v?([123])" => sub { "GPL_$_[0]" },
  'GNU (?:general )?public license'             => [ map {"GPL_$_"} (1..3) ],
  "GNU (?:lesser|library) (?:general )?public license,? $_v?([23])\\D"  => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'GNU (?:lesser|library) (?:general )?public license'  => [ qw(LGPL_2_1 LGPL_3_0) ],
  'BSD license'                => 'BSD',
  "Artistic license $_v?(\\d)" => sub { "Artistic_$_[0]_0" },
  'Artistic license'           => [ map { "Artistic_$_\_0" } (1..2) ],
  "LGPL,? $_v?(\\d)"             => sub {
    $_[0] == 2 ? 'LGPL_2_1' : $_[0] == 3 ? 'LGPL_3_0' : ()
  },
  'LGPL'                       => [ qw(LGPL_2_1 LGPL_3_0) ],
  "GPL,? $_v?(\\d)"              => sub { "GPL_$_[0]_0" },
  'GPL'                        => [ map { "GPL_$_\_0" } (1..3) ],
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

my %meta_keys = (
  ## CPAN::Meta::Spec 2.0
  ##
  agpl_3       => 'AGPL_3',
  apache_1_1   => 'Apache_1_1',
  apache_2_0   => 'Apache_2_0',
  artistic_1   => 'Artistic_1_0',
  artistic_2   => 'Artistic_2_0',
  bsd          => 'BSD',
  freebsd      => 'FreeBSD',
  gfdl_1_2     => 'GFDL_1_2',
  gfdl_1_3     => 'GFDL_1_3',
  gpl_1        => 'GPL_1',
  gpl_2        => 'GPL_2',
  gpl_3        => 'GPL_3',
  lgpl_2_1     => 'LGPL_2_1',
  lgpl_3_0     => 'LGPL_3_0',
  mit          => 'MIT',
  mozilla_1_0  => 'Mozilla_1_0',
  mozilla_1_1  => 'Mozilla_1_1',
  openssl      => 'OpenSSL',
  perl_5       => 'Perl_5',
  qpl_1_0      => 'QPL_1_0',
  ssleay       => 'SSLeay',
  sun          => 'Sun',
  zlib         => 'Zlib',
  # open_source
  restricted   => 'None',
  # unrestricted
  # unknown
  
  ## META-spec 1.4
  ##
  apache       => [ map { "Apache_$_" } qw(1_1 2_0) ],
  # apache_1_1
  perl         => 'Perl_5',
  artistic     => 'Artistic_1_0',
  # artistic_2
  # bsd
  gpl          => [ map { "GPL_$_" } qw(1 2 3) ],
  lgpl         => [ map { "LGPL_$_" } qw(2_1 3_0) ],
  # mit
  mozilla      => [ map { "Mozilla_$_" } qw(1_0 1_1 2_0) ],
  # open_source
  restrictive  => 'None',
  # unrestricted
  # unknown
);

=method guess_license_from_meta

  my @guesses = Software::LicenseUtils->guess_license_from_meta($meta_str);

Given the content of the META.(yml|json) file found in a CPAN distribution, this
method makes a guess as to which licenses may apply to the distribution.  It
will return a list of zero or more Software::License instances or classes.

=cut

sub guess_license_from_meta {
  my ($class, $meta_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

  my ($license_text) = $meta_text =~ m{\b["']?license["']?\s*:\s*["']?([a-z_]+)["']?}gm
    or return;

  return $class->guess_license_from_meta_code($license_text);
}

*guess_license_from_meta_yml = \&guess_license_from_meta;

=method guess_license_from_meta_code

  my @guesses = Software::LicenseUtils->guess_license_from_meta_code($code);

Like C<guess_license_from_meta>, but rather than taking an entire
META.(yml|json) file, takes just the code from the "license" key.
e.g. "perl_5".

Supports codes from L<CPAN::Meta::Spec> 2.0 and META-spec 1.4.

=cut

sub guess_license_from_meta_code {
  my ($class, $code) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

  my $license = $meta_keys{$code} or return;
  return map { "Software::License::$_" } ref $license ? @$license : $license;
}

1;
