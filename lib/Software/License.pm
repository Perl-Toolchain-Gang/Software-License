use strict;
use warnings;
use 5.006; # warnings
package Software::License;
# ABSTRACT: packages that provide templated software licenses

use Data::Section -setup => { header_re => qr/\A__([^_]+)__\Z/ };
use Sub::Install ();
use Text::Template ();

=head1 SYNOPSIS

  my $license = Software::License::Discordian->new({
    holder => 'Ricardo Signes',
  });

  print $output_fh $license->fulltext;

=method new

  my $license = $subclass->new(\%arg);

This method returns a new license object for the given license class.  Valid
arguments are:

  holder - the holder of the copyright; required
  year   - the year of copyright; defaults to current year

=cut

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no copyright holder specified" unless $arg->{holder};

  bless $arg => $class;
}

=method year

=method holder

These methods are attribute readers.

=cut

sub year   { defined $_[0]->{year} ? $_[0]->{year} : (localtime)[5]+1900 }
sub holder { $_[0]->{holder}     }

=method name

This method returns the name of the license, suitable for shoving in the middle
of a sentence, generally with a leading capitalized "The."

=method url

This method returns the URL at which a canonical text of the license can be
found, if one is available.  If possible, this will point at plain text, but it
may point to an HTML resource.

=method notice

This method returns a snippet of text, usually a few lines, indicating the
copyright holder and year of copyright, as well as an indication of the license
under which the software is distributed.

=cut

sub notice { shift->_fill_in('NOTICE') }

=method license

This method returns the full text of the license.

=cut

sub license { shift->_fill_in('LICENSE') }

=method fulltext

This method returns the complete text of the license, preceded by the copyright
notice.

=cut

sub fulltext {
  my ($self) = @_;
  return join "\n", $self->notice, $self->license;
}

=method version

This method returns the version of the license.  If the license is not
versioned, this method will return false.

=cut

sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;

  return unless @vparts;
  return join '.', @vparts;
}

=method meta_name

This method returns the string that should be used for this license in the CPAN
META.yml file, according to the CPAN Meta spec v1, or undef if there is no
known string to use.

This method may also be invoked as C<meta_yml_name> for legacy reasons.

=method meta2_name

This method returns the string that should be used for this license in the CPAN
META.json or META.yml file, according to the CPAN Meta spec v2, or undef if
there is no known string to use.  If this method does not exist, and
C<meta_name> returns open_source, restricted, unrestricted, or unknown, that
value will be used.

=cut

# sub meta1_name    { return undef; } # sort this out later, should be easy
sub meta_name     { return undef; }
sub meta_yml_name { $_[0]->meta_name }

sub meta2_name {
  my ($self) = @_;
  my $meta1 = $self->meta_name;

  return undef unless defined $meta1;

  return $meta1
    if $meta1 =~ /\A(?:open_source|restricted|unrestricted|unknown)\z/;

  return undef;
}

sub _fill_in {
  my ($self, $which) = @_;

  Carp::confess "couldn't build $which section" unless
    my $template = $self->section_data($which);

  return Text::Template->fill_this_in(
    $$template,
    HASH => { self => \$self },
    DELIMITERS => [ qw({{ }}) ],
  );
}

=head1 TODO

=for :list
* register licenses with aliases to allow $registry->get('gpl', 2);

=head1 SEE ALSO

The specific license:

=for :list
* L<Software::License::AGPL_3>
* L<Software::License::Apache_1_1>
* L<Software::License::Apache_2_0>
* L<Software::License::Artistic_1_0>
* L<Software::License::Artistic_2_0>
* L<Software::License::BSD>
* L<Software::License::CC0>
* L<Software::License::FreeBSD>
* L<Software::License::GFDL_1_2>
* L<Software::License::GPL_1>
* L<Software::License::GPL_2>
* L<Software::License::GPL_3>
* L<Software::License::LGPL_2_1>
* L<Software::License::LGPL_3_0>
* L<Software::License::MIT>
* L<Software::License::Mozilla_1_0>
* L<Software::License::Mozilla_1_1>
* L<Software::License::None>
* L<Software::License::OpenSSL>
* L<Software::License::Perl_5>
* L<Software::License::QPL_1_0>
* L<Software::License::SSLeay>
* L<Software::License::Sun>
* L<Software::License::Zlib>

=cut

1;

__DATA__
__NOTICE__
This software is Copyright (c) {{$self->year}} by {{$self->holder}}.

This is free software, licensed under:

  {{ $self->name }}
