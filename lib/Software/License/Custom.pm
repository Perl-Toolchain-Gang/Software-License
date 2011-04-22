package Software::License::Custom;
use strict;
use warnings;
use Carp;
use English qw( -no_match_vars );

use base 'Software::License';

# ABSTRACT: custom license handler

=method new

   my $license = Software::License::Custom->new({
      filename => '/path/to/license/description/file',
      %other_Software_License_arguments_to_new,
   });

The C<filename> field is added to the set of allowed parameters that are
recognised by this method. This new field allows you to set the filename
where all the configurations for your custom license should be read from.

=cut

sub new {
   my ($class, $arg) = @_;

   my $filename = delete $arg->{filename};

   my $self = $class->SUPER::new($arg);

   $self->load_sections_from($filename) if defined $filename;

   return $self;
} ## end sub new

sub load_sections_from {
   my ($self, $filename) = @_;

   # Sections are kept inside a hash
   $self->{'Software::License::Custom'}{section_for} = \my %section_for;

   my $current_section = '';
   open my $fh, '<', $filename
      or croak "open('$filename'): $OS_ERROR";
   while (<$fh>) {
      if (my ($section) = m{\A __ (.*) __ \n\z}mxs) {
         ($current_section = $section) =~ s/\W+//gmxs;
      }
      else {
         $section_for{$current_section} .= $_;
      }
   }
   close $fh;

   # strip last newline from all items
   s{\n\z}{}mxs for values %section_for;

   return $self;
}

sub section_data {
   my ($self, $name) = @_;
   my $section = $self->{'Software::License::Custom'}{section_for}{$name};
   return defined($section) ? \$section : undef;
}

sub name       { shift->_fill_in('NAME') }
sub url        { shift->_fill_in('URL') }
sub meta2_name { shift->_fill_in('META2_NAME') }

# This is (also) a class method in the other modules, so we stick to this
# convention and the tests will be happy.
sub meta_name  {
   my $self = shift;
   return 'custom' unless ref $self;
   return $self->_fill_in('META_NAME')
}

1;
__END__

=head1 SYNOPSIS

In your code:

   my $license = Software::License::Custom->new({
      holder => 'A. U. Thor',
      filename => '/path/to/LEGAL',
   });

Then, in F</path/to/LEGAL>:

   __[ NAME ]__
   The Foo-Bar License
   __[ URL ]__
   http://www.example.com/foo-bar.txt
   __[ META_NAME ]__
   foo_bar_meta
   __[ META2_NAME ]__
   foo_bar_meta2
   __[ NOTICE ]__
   Copyright (C) 2000-2002 by O.R. Iginal
   Copyright (C) 2002-2005 by P.R. Evious
   Copyright (C) {{$self->year}} by {{$self->holder}}.
   
   This is free software, licensed under {{$self->name}}.

   Take care and leave in peace.
   
   __[ LICENSE ]__
               The Foo-Bar License
   
   Well... this is only some sample text. I'm true... only sample text!!!
   
   Yes, spanning more lines and more paragraphs.


=head1 DESCRIPTION

This module gives the possibility of
specifying all aspects related to a software license in a custom file.
This allows for setting custom dates, notices, etc. while still preserving
compatibility with all places where L<Software::License> is used, e.g.
L<Dist::Zilla>.

In this way, you should be able to customise some aspects of the licensing
messages that would otherwise be difficult to tinker, e.g. adding a note
in the notice, setting multiple years for the copyright notice or set multiple
authors and/or copyright holders.

The license details should be put inside a file that contains different
sections. Each section has the following format:

=over

=item *

header line

a line that begins and ends with two underscores C<__>. The string
between the begin and the end of the line is first depured of any
non-word character (in Perl terms, i.e. the underscore character C<_>
is considered to be a word character), then used as the name of the
section;

=item *

body

a L<Text::Template> (possibly a plain text file) where items to be
expanded are enclosed between double braces.

=back

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

   Well... this is only some sample text. I'm true... only sample text!!!

   Yes, spanning more lines and more paragraphs.

The different formats for specifying the section name in the example
above are only examples, you're invited to use a consistent approach.

=cut
