use strict;
use warnings;
package Software::License::Custom;
# ABSTRACT: custom license handler

use base 'Software::License';

use Carp;
use Software::License::Template;

=head1 DESCRIPTION

This module extends L<Software::License> to give the possibility of specifying
all aspects related to a software license in a custom file.  This allows for
setting custom dates, notices, etc. while still preserving compatibility with
all places where L<Software::License> is used, e.g. L<Dist::Zilla>.

In this way, you should be able to customise some aspects of the licensing
messages that would otherwise be difficult to tinker, e.g. adding a note
in the notice, setting multiple years for the copyright notice or set multiple
authors and/or copyright holders.

The license details should be put inside a file that contains different
sections. Each section has the following format:

=begin :list

= header line

This is a line that begins and ends with two underscores C<__>. The string
between the begin and the end of the line is first depured of any non-word
character, then used as the name of the section;

= body

a L<Text::Template> (possibly a plain text file) where items to be
expanded are enclosed between double braces

=end :list

Each section is terminated by the header of the following section or by
the end of the file. Example:

   __[ NAME ]__
   The Foo-Bar License
   __URL__
   http://www.example.com/foo-bar.txt
   __[ META_NAME ]__
   foo_bar_meta
   __{ META2_NAME }__
   foo_bar_meta2
   __[ NOTICE ]__
   Copyright (C) 2000-2002 by P.R. Evious
   Copyright (C) {{$self->year}} by {{$self->holder}}.

   This is free software, licensed under {{$self->name}}.

   __[ LICENSE ]__
               The Foo-Bar License

   Well... this is only some sample text.  Verily... only sample text!!!

   Yes, spanning more lines and more paragraphs.

The different formats for specifying the section name in the example
above are only examples, you're invited to use a consistent approach.

=method new

   my $slc = Software::License::Custom->new({filename => 'LEGAL'});

Create a new object. Arguments are passed through an anonymous hash, the
following keys are allowed:

  filename - the file where the custom software license details are stored

=cut

sub new {
   my ($class, $arg) = @_;

   my $filename = delete $arg->{filename};

   my $self = $class->SUPER::bare_new($arg);

   if (defined $filename) {
      my $slt = Software::License::Template->new(expand => 1);
      my $license_data = $slt->load_file($filename);
      $self->set_license_data($license_data);
   }

   return $self;
}

sub meta_name {
   my $self = shift;
   my $meta_name = $self->SUPER::meta_name();
   return $meta_name if defined $meta_name;
   return 'custom';
}

1;
