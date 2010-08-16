use strict;
use warnings;
package Software::License::PostgreSQL;
use base 'Software::License';
# ABSTRACT: The PostgreSQL License

sub name { 'The PostgreSQL License' }
sub url  { 'http://www.opensource.org/licenses/postgresql' }

sub meta_name  { 'postgresql' }

1;
__DATA__
__LICENSE__
The PostgreSQL License

Copyright (c) $YEAR, $ORGANIZATION

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

IN NO EVENT SHALL $ORGANISATION BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING
OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF $ORGANISATION
HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$ORGANISATION SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS,
AND $ORGANISATION HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.
