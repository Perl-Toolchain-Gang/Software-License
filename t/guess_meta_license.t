#!perl

use strict;
use warnings;

use Test::More tests => 26;
use Software::LicenseUtils;
use Try::Tiny;

sub _hack_guess_license_from_meta {
	my $license_str = shift;
	my @guess;
	try {
		my $hack = 'license : ' . $license_str;
		@guess = Software::LicenseUtils->guess_license_from_meta($hack);
	};
	return @guess;

}

my @cpan_meta_spec_licence_name = qw(
	agpl_3
	apache_1_1
	apache_2_0
	artistic_1
	artistic_2
	bsd
	freebsd
	gfdl_1_2
	gfdl_1_3
	gpl_1
	gpl_2
	gpl_3
	lgpl_2_1
	lgpl_3_0
	mit
	mozilla_1_0
	mozilla_1_1
	openssl
	perl_5
	qpl_1_0
	ssleay
	sun
	zlib
);

foreach my $license_name (@cpan_meta_spec_licence_name) {
	my @guess = _hack_guess_license_from_meta($license_name);
	ok(@guess, "$license_name -> @guess");
}

is_deeply(
  [ Software::LicenseUtils->guess_license_from_meta_key('artistic_2', 2) ],
  [ 'Software::License::Artistic_2_0' ],
);

is_deeply(
  [ Software::LicenseUtils->guess_license_from_meta_key('gpl_3', 2) ],
  [ 'Software::License::GPL_3' ],
);

is_deeply(
  [ Software::LicenseUtils->guess_license_from_meta_key('gpl_3', 1) ],
  [ ],
);

done_testing;
