use strict;
use warnings;
package Software::LicenseUtils;
# ABSTRACT: little useful bits of code for licensey things

use File::Spec;
use IO::Dir;
use Module::Load;

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
  'BSD 2 Clause license'       => 'BSD_2_Clause',
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

my %meta_keys = ();

# find all known Software::License::* modules and get identification data
#
# XXX: Grepping over @INC is dangerous, as it means that someone can change the
# behavior of your code by installing a new library that you don't load.  rjbs
# is not a fan.  On the other hand, it will solve a real problem.  One better
# solution is to check "core" licenses first, then fall back, and to skip (but
# warn about) bogus libraries.  Another is, at least when testing S-L itself,
# to only scan lib/ blib. -- rjbs, 2013-10-20
for my $lib (map { "$_/Software/License" } @INC) {
  next unless -d $lib;
  for my $file (IO::Dir->new($lib)->read) {
    next unless $file =~ m{\.pm$};

    # if it fails, ignore it
    eval {
      (my $mod = $file) =~ s{\.pm$}{};
      my $class = "Software::License::$mod";
      load $class;
      $meta_keys{ $class->meta_name }{$mod}  = undef;
      $meta_keys{ $class->meta2_name }{$mod} = undef;
      my $name = $class->name;
      unshift @phrases, qr/\Q$name\E/, [$mod];
    };
  }
}

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
			$pattern =~ s{\s+}{\\s+}g
				unless ref $pattern eq 'Regexp';
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

=method guess_license_from_meta

  my @guesses = Software::LicenseUtils->guess_license_from_meta($meta_str);

Given the content of the META.(yml|json) file found in a CPAN distribution, this
method makes a guess as to which licenses may apply to the distribution.  It
will return a list of zero or more Software::License instances or classes.

=cut

sub guess_license_from_meta {
  my ($class, $meta_text) = @_;
  die "can't call guess_license_* in scalar context" unless wantarray;

  my ($license_text) = $meta_text =~ m{\b["']?license["']?\s*:\s*["']?([a-z_0-9]+)["']?}gm;

  return unless $license_text and my $license = $meta_keys{ $license_text };

  return map { "Software::License::$_" } sort keys %$license;
}

*guess_license_from_meta_yml = \&guess_license_from_meta;



1;
