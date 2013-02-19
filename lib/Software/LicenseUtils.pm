use strict;
use warnings;
use Carp;

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
  perl         => 'Perl_5',
  apache       => [ map { "Apache_$_" } qw(1_1 2_0) ],
  artistic     => 'Artistic_1_0',
  artistic_2   => 'Artistic_2_0',
  lgpl         => [ map { "LGPL_$_" } qw(2_1 3_0) ],
  bsd          => 'BSD',
  gpl          => [ map { "GPL_$_" } qw(1 2 3) ],
  mit          => 'MIT',
  mozilla      => [ map { "Mozilla_$_" } qw(1_0 1_1 2_0) ],
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

  my ($license_text) = $meta_text =~ m{\b["']?license["']?\s*:\s*["']?([a-z_]+)["']?}gm;

  return unless $license_text and my $license = $meta_keys{ $license_text };

  return map { "Software::License::$_" } ref $license ? @$license : $license;
}

*guess_license_from_meta_yml = \&guess_license_from_meta;

my %short_name = (
    'GPL-1'      =>  [ 'GPL_1' ],
    'GPL-2'      =>  [ 'GPL_2' ],
    'GPL-3'      =>  [ 'GPL_3' ],
    'LGPL-2'     =>  [ 'LGPL_2' ],
    'LGPL-2.1'   =>  [ 'LGPL_2_1' ],
    'LGPL-3'     =>  [ 'LGPL_3_0' ],
    'LGPL-3.0'   =>  [ 'LGPL_3_0' ],
    'Artistic'   =>  [ 'Artistic_1_0' ],
    'Artistic-1' =>  [ 'Artistic_1_0' ],
    'Artistic-2' =>  [ 'Artistic_2_0' ],
);


=method new_from_short_name

  my $license_object = Software::LicenseUtils->new_from_short_name( {
     short_name => 'GPL-1',
     holder => 'X. Ample'
  }) ;

Create a new L<Software::License> object from the license specified
with C<short_name>. Known short license names are C<GPL-*>, C<LGPL-*> ,
C<Artistic> and C<Artistic-*>

=cut

sub new_from_short_name {
  my ( $class, $arg ) = @_;

  Carp::croak "no license short name specified"
    unless defined $arg->{short_name};
  my $short = delete $arg->{short_name};
  Carp::croak "Unknow license with short name $short"
    unless $short_name{$short};
  my @lic_data = @{ $short_name{$short} };

  my $lic_file = my $lic_class = 'Software::License::' . shift @lic_data;
  $lic_file =~ s!::!/!g;
  require "$lic_file.pm";
  return $lic_class->new( { %$arg, @lic_data } );
}

1;
