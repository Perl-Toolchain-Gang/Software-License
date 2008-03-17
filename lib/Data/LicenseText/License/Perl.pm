
    perl            => { function => \&License_Perl,
                         fullname =>'Same terms as Perl itself',
                       },

################################################ subroutine header begin ##

=head2 License_Perl

 Purpose   : Get the copyright pod text and LICENSE file text for this license

=cut

################################################## subroutine header end ##

sub License_Perl {
    my %license;

    my $gpl         = License_GPL_2 ();
    my $artistic    = License_Artistic_w_Aggregation ();

    $license{COPYRIGHT} = <<EOFCOPYRIGHT;
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.
EOFCOPYRIGHT

    $license{LICENSETEXT} = <<EOFLICENSETEXT;
Terms of Perl itself

a) the GNU General Public License as published by the Free
   Software Foundation; either version 1, or (at your option) any
   later version, or
b) the "Artistic License"

---------------------------------------------------------------------------

$gpl->{LICENSETEXT}

---------------------------------------------------------------------------

$artistic->{LICENSETEXT}

EOFLICENSETEXT

    return (\%license);
}
