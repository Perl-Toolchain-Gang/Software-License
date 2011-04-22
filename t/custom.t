#!perl
use strict;
use warnings;

use Test::More;

use Software::License::Custom;

my $slc = Software::License::Custom->new({
   holder => 'A. U. Thor',
   year   => 1972,
   filename => 't/custom-license'
});
isa_ok($slc, 'Software::License');

is($slc->name, 'The Foo-Bar License', 'name');
is($slc->url, 'http://www.example.com/foo-bar.txt', 'url');
is($slc->meta_name, 'foo_bar_meta', 'meta_name');
is($slc->meta2_name, 'foo_bar_meta2', 'meta2_name');
is($slc->notice, <<'END_OF_NOTICE', 'notice');
Copyright (C) 1972 by A. U. Thor.

This is free software, licensed under The Foo-Bar License.
END_OF_NOTICE
is($slc->license, <<'END_OF_LICENSE', 'license');
              The Foo-Bar License

Well... this is only some sample text. I'm true... only sample text!!!

Yes, spanning more lines and more paragraphs.
END_OF_LICENSE
is($slc->fulltext, <<'END_OF_FULLTEXT', 'fulltext');
Copyright (C) 1972 by A. U. Thor.

This is free software, licensed under The Foo-Bar License.

              The Foo-Bar License

Well... this is only some sample text. I'm true... only sample text!!!

Yes, spanning more lines and more paragraphs.
END_OF_FULLTEXT

done_testing;
