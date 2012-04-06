use strict;
use warnings;
package Software::License::Artistic_1_0;
use base 'Software::License';
# ABSTRACT: The Artistic License

=head1 OPTIONS

The Artistic License 1.0 has a sometimes-omitted "aggregation clause" which
reads:

  8. The name of the Copyright Holder may not be used to endorse or promote
  products derived from this software without specific prior written
  permission.

By default, this clause will be included.  To disable it, include the following
pair when instantiating the license:

  aggregation_clause => 0

=head1 METHODS

=head2 aggregation_clause

This method returns whether the aggregation clause is allowed on this instance.
By default this method returns true on instances and dies on the class.

=cut

sub aggregation_clause {
  exists $_[0]->{aggregation_clause} ? $_[0]->{aggregation_clause} : 1
}

1;
