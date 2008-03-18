use strict;
use warnings;
use 5.006; # warnings
package Software::License;

=head1 NAME

Software::License - packages that provide templated software licenses

=head1 VERSION

version 0.000

=cut

our $VERSION = '0.000';

use Class::ISA ();
use Sub::Install ();
use Text::Template ();

=head1 SYNOPSIS

  my $license = Software::License::Discordian->new({
    holder => 'Ricardo Signes',
  });

  print $output_fh $license->fulltext;

=head1 DESCRIPTION

=head1 METHODS

=head2 new

  my $license = $subclass->new(\%arg);

This method returns a new license object for the given license class.  Valid
arguments are:

  holder - the holder of the copyright; required
  year   - the year of copyright; defaults to current year

=cut

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no copyright holder specified" unless $arg->{holder};

  my $guts = {
    holder => $arg->{holder},
    year   => $arg->{year},
  };

  bless $guts => $class;
}

=head1 year

=head2 holder

These methods are attribute readers.

=cut

sub year   { defined $_[0]->{year} ? $_[0]->{year} : (localtime)[5]+1900 }
sub holder { $_[0]->{holder}     }

=head2 notice

This method returns a snippet of text, usually a few lines, indicating the
copyright holder and year of copyright, as well as an indication of the license
under which the software is distributed.

=cut

sub notice { shift->_fill_in('NOTICE') }

=head2 license

This method returns the full text of the license.

=cut

sub license { shift->_fill_in('LICENSE') }

=head2 fulltext

This method returns the complete text of the license, preceded by the copyright
notice.

=cut

sub fulltext {
  my ($self) = @_;
  return join "\n", $self->notice, $self->_fill_in('LICENSE')
}

=head2 version

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

sub _fill_in {
  my ($self, $which) = @_;

  Carp::confess "couldn't build $which section" unless
    my $template = $self->_templates->{$which};

  return Text::Template->fill_this_in(
    $template,
    HASH => { self => \$self },
    DELIMITERS => [ qw({{ }}) ],
  );
}

sub _templates {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;

  Carp::croak "the templates method must be called on a subclass"
    if $pkg eq __PACKAGE__;

  my $dh  = do { no strict 'refs'; \*{"$pkg\::DATA"} };

  my %template;

  my @super_path = Class::ISA::super_path($pkg);
  if (@super_path != 1 or $super_path[0] ne __PACKAGE__) {
    my $super_method = "$super_path[0]\::templates";
    %template = %{ $self->$super_method };
  } elsif (@super_path == 1 and $super_path[0] eq __PACKAGE__) {
    %template = $self->_root_templates;
  }

  my $current;
  while (my $line = <$dh>) {
    chomp $line;

    if ($line =~ /\A__([^_]+)__\z/) {
      $current = $1;
      $template{$current} = '';
      next;
    }
 
    Carp::confess "bogus data section: text outside of file" unless $current;

    $line =~ s/\A\\//;

    $template{$current} .= "$line\n";
  }

  my $new_code = sub { \%template };
  Sub::Install::install_sub({
    code => $new_code,
    into => $pkg,
    as   => '_templates',
  });

  return $self->_templates;
}

sub _root_templates {
  return (NOTICE => <<'END_NOTICE');
This software is Copyright (c) {{$self->year}} by {{$self->holder}}.

This is free software, licensed under:

  {{ $self->name }}
END_NOTICE
}

=head1 TODO

=over

=item * register licenses with aliases to allow $registry->get('gpl', 2);

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2008 by Ricardo SIGNES.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
