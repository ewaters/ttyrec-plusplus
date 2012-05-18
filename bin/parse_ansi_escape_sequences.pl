#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use FindBin;
use lib $FindBin::Bin . '/../lib';
use ParseANSISequences;

foreach my $fn (@ARGV) {
	open my $in, '<', $fn or die "Can't read $fn: $!";
	while (my $line = <$in>) {
		ParseANSISequences::print_line($line);
	}
	close $in;
	print "\n";
}
