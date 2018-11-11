use strict;
use warnings;
package Software::License::None;

use parent 'Software::License';
# ABSTRACT: describes a "license" that gives no license for re-use

sub name      { q("No License" License) }
sub url       { undef }

sub meta_name  { 'restrictive' }
sub meta2_name { 'restricted'  }

1;
__DATA__
__NOTICE__
This software is copyright (c) {{$self->year}} by {{$self->_dotless_holder}}.  No
license is granted to other entities.
__LICENSE__
All rights reserved.
