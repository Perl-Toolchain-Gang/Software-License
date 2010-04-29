package Software::License::None;

use base 'Software::License';

sub name      { q("No License" License) }
sub url       { undef }
sub meta_name { 'restricted' }

1;

=head1 NAME

Software::License::None - describes a "license" that gives no license for re-use

=cut

__DATA__
__NOTICE__
This software is copyright (c) {{$self->year}} by {{$self->holder}}

All rights reserved.
__LICENSE__
This software is copyright (c) {{$self->year}} by {{$self->holder}}

All rights reserved.
