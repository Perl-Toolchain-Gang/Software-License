use strict;
use warnings;
package Software::License::Perl_5;
use base 'Software::License';

require Software::License::GPL_1;
require Software::License::Artistic_1_0;

sub name { 'the same terms as perl 5 itself' }

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
__DATA__
__NOTICE__
This software is copyright (c) {{$self->year}} by {{$self->holder}}.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.
__LICENSE__
Terms of Perl itself

a) the GNU General Public License as published by the Free
   Software Foundation; either version 1, or (at your option) any
   later version, or
b) the "Artistic License"

--- {{ $self->_gpl->name }} ---

{{$self->_gpl->fulltext}}

--- {{ $self->_tal->name }} ---

{{$self->_tal->fulltext}}
