use strict;
use warnings;
package Software::License::OpenSSL;
use base 'Software::License';
# ABSTRACT: The OpenSSL License

require Software::License::SSLeay;

sub _ssleay {
  my ($self) = @_;
  return $self->{_ssleay} ||= Software::License::SSLeay->new({
    year   => $self->year,
    holder => $self->holder,
  });
}

1;
