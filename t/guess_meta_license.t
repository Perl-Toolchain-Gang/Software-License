#!perl

use strict;
use warnings;

use Test::More tests => 23;
# use Data::Printer {caller_info => 1, colored => 1,};
use Software::LicenseUtils;
use Try::Tiny;

sub _hack_guess_license_from_meta {
	my $license_str = shift;
	my @guess;
	try {
		my $hack = 'license : ' . $license_str;
		# p $hack;
		@guess = Software::LicenseUtils->guess_license_from_meta($hack);
		# p @guess;
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
	my @guess_json = _hack_guess_license_from_meta($license_name);
	if (@guess_json) {
		ok(1, "$license_name -> @guess_json");
	}
	else {
		ok(0,"$license_name -> license unknown");
	}
}


done_testing;
