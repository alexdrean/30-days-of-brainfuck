use strict;
use warnings;

foreach my $filename(@ARGV) {
	if (open(my $fh, '<', $filename)) {
		my $rom = do { local $/; <$fh> };
		my @t;
		my $i = 0;
		my $compiled = '';
		
		my %brainfuck = (
			'+' => '$t[$i]++;$t[$i]=0 if $t[$i]==256;',
			'-' => '$t[$i]--;$t[$i]=255 if $t[$i]==-1;',
			'>' => '$i++;',
			'<' => '$i--;',
			'.' => 'print chr($t[$i]);',
			',' => '$t[$i] = ord(getc());',
			'[' => 'while ($t[$i]) {',
			']' => '}'
		);
		foreach my $char (split //, $rom) {
			if ($char =~ /[\[\]\.,\+\-\<\>]/) {
				$compiled .= $brainfuck{$char};
			}
		}
		eval $compiled;
	}
}
