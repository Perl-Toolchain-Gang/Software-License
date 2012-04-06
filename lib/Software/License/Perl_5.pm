use strict;
use warnings;
package Software::License::Perl_5;
use base 'Software::License';
# ABSTRACT: The Perl 5 License (Artistic 1 & GPL 1)

require Software::License::GPL_1;
require Software::License::Artistic_1_0;

sub _gpl {
  my ($self) = @_;
  return $self->{_gpl} ||= Software::License::GPL_1->new({
    year   => $self->year,
    holder => $self->holder,
  });
}

sub _tal {
  my ($self) = @_;
  return $self->{_tal} ||= Software::License::Artistic_1_0->new({
    year   => $self->year,
    holder => $self->holder,
  });
}

1;
