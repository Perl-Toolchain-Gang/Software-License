use strict;
use warnings;
package Data::LicenseText::License;

use Class::ISA ();
use Sub::Install ();
use Text::Template ();

sub new {
  my ($class, $arg) = @_;

  Carp::croak "no copyright holder specified" unless $arg->{holder};

  my $guts = {
    holder => $arg->{holder},
    year   => $arg->{year},
  };

  bless $guts => $class;
}

sub year   { defined $_[0]->{year} ? $_[0]->{year} : (localtime)[5]+1900 }
sub holder { $_[0]->{holder}     }

sub fulltext { shift->_fill_in('FULLTEXT') }
sub notice   { shift->_fill_in('NOTICE')   }

sub version  {
  my ($self) = @_;
  my $pkg = ref $self ? ref $self : $self;
  $pkg =~ s/.+:://;
  my (undef, @vparts) = split /_/, $pkg;
  return join '.', @vparts;
}

sub _fill_in {
  my ($self, $which) = @_;

  my $template = $self->_templates->{$which};

  return Text::Template->fill_this_in(
    $template,
    HASH => { self => \$self }
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
This program is free software, licensed under:

  {{ $self->name }}

The full text of the license can be found in the LICENSE file included with
this distribution.
END_NOTICE
}

1;
