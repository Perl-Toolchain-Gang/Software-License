use strict;
use warnings;
package Software::LicenseUtils;
use File::Basename qw( dirname );
use Carp;
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


# Cache for associating one or more classes to a meta_name
my %classes_for;
sub _may_load_meta_keys {
  return if scalar keys %classes_for;

  # Load one of the licenses in order to get its filename in %INC
  require Software::License::Perl_5; # this surely exists
  my $dirname = dirname($INC{'Software/License/Perl_5.pm'});

  # Scan the directory for Perl modules, load them and get the meta_name
  opendir my $dh, $dirname or croak "opendir('$dirname'): $!";
  for my $file (readdir $dh) {
    (my $submodule = $file) =~ s/\.pm\z//mxs or next;
    require "Software/License/$file";
    my $class = "Software::License::$submodule";
    push @{$classes_for{$class->meta_name()}}, $class;
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

  my ($license_text) =
    $meta_text =~ m{\b["']?license["']?\s*:\s*["']?(\w+)["']?}gm;
  return unless $license_text;
  return $class->classes_for_meta_name($license_text);
}

*guess_license_from_meta_yml = \&guess_license_from_meta;


=method classes_for_meta_name

  my @classes = Software::LicenseUtil->classes_for_meta_name($name);

Given the name of a license according to what can be included in
META.(yml|json) file found in a CPAN distribution, this method returns
the name of all the classes that may apply to the license name. It will
return a list of zero or more Software::License instances or classes.

=cut

sub classes_for_meta_name {
  my ($class, $meta_name) = @_;
  die "can't call classes_for_meta_name in scalar context" unless wantarray;
  _may_load_meta_keys();
  return @{$classes_for{$meta_name} || []};
}

1;
