use strict;
use warnings;
package Data::LicenseText::License::Perl;
use base 'Data::LicenseText::License';

require Data::LicenseText::License::GPL_1;
require Data::LicenseText::License::Artistic_1_0;

sub name { 'the same terms as perl itself' }

sub _gpl {
  my ($self) = @_;
  return $self->{_gpl} ||= Data::LicenseText::License::GPL_1->new({
    year   => $self->year,
    holder => $self->holder,
  });
}

sub _tal {
  my ($self) = @_;
  return $self->{_tal} ||= Data::LicenseText::License::Artistic_1_0->new({
    year   => $self->year,
    holder => $self->holder,
  });
}

1;
__DATA__
__NOTICE__
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.
__FULLTEXT__
Terms of Perl itself

a) the GNU General Public License as published by the Free
   Software Foundation; either version 1, or (at your option) any
   later version, or
b) the "Artistic License"


--- {{ $self->_gpl->name }} ---
{{$self->_gpl->fulltext}}

--- {{ $self->_tal->name }} ---
{{$self->_tal->fulltext}}
