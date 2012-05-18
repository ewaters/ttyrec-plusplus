package ParseANSISequences;

use strict;
use warnings;
use utf8;
use Term::ANSIColor qw(colored);

# http://www.xfree86.org/current/ctlseqs.html

my %csi_codes = (
	'@' => 'insert_blank_characters',
	A => 'cursor_up',
	B => 'cursor_down',
	C => 'cursor_forward',
	D => 'cursor_back',
	E => 'cursor_next_line',
	F => 'cursor_previous_line',
	H => 'cursor_position',
	I => 'cursor_forward_tab_stops',
	J => 'erase_data', # 0: below, 1: above, 2: all, 3: saved lines
	K => 'erase_in_line',
	S => 'scroll_up',
	T => 'scroll_down',
	f => 'horizontal_vertical_position',
	l => 'mode_reset',
	h => 'mode_set',
	m => 'select_graphic_rendition',
	n => 'device_status_report',
	r => 'set_scrolling_region',
	s => 'save_cursor_position',
	u => 'restore_cursor_position',
);

my %csi_private_modes = (
	1 => [ 'application_cursor_keys', 'normal_cursor_keys' ],
	25 => [ 'show_cursor', 'hide_cursor' ],
	47 => [ 'use_alt_screen_buffer', 'use_normal_screen_buffer' ],
	1049 => [ 'save_cursor_use_alt_screen_buffer', 'use_normal_screen_buffer_restore_cursor' ],
);

my %csi_bit_modes = (
	2 => 'keyboard_action_mode',
	4 => 'insert_mode',
	12 => 'send_receive',
	20 => 'automatic_newline',
);

my %simple_sequences = (
	'=' => 'application_keypad',
	'>' => 'normal_keypad',
	'7' => 'save_cursor',
	'8' => 'restore_cursor',
);

my $bell = chr(7);

sub print_line {
	my $line = shift;
	while (length $line) {
		my $char = substr $line, 0, 1, '';
		my $ord = ord($char);
		if ($ord == 27) {
			my $next_char = substr $line, 0, 1;
			if ($next_char eq '[') {
				# Look for CSI
				if (my ($private, $count, $code) = $line =~ m{^\[ (\?)? (\d* (?:; \d+)*)  ([A-Za-z])}x) {
					my @counts = $count ? split /;/, $count : ();
					my $description = $csi_codes{$code} || 'unknown_code_' . $code;
					$description = 'private_' . $description if $private;

					my $argument = join ';', @counts;
					# mode_reset or mode_set
					if ($code eq 'l' || $code eq 'h') {
						if ($private && $csi_private_modes{$argument}) {
							$argument = colored($csi_private_modes{$argument}[ $code eq 'h' ? 0 : 1 ], 'magenta');
						}
						elsif (! $private) {
							# Figure out additive modes
							my @modes;
							foreach my $bit (sort { $b <=> $a } keys %csi_bit_modes) {
								if ($argument >= $bit) {
									push @modes, $csi_bit_modes{$bit};
								}
							}
							$argument = colored(join(' + ', @modes), 'magenta');
						}
					}

					print colored($description . '(' . $argument . ')', 'yellow') . "\n";
					$line =~ s{^.+?$code}{};
				}
				else {
					print colored(' ESC ', 'blue');
				}
			}
			elsif ($simple_sequences{$next_char}) {
				print colored($simple_sequences{$next_char}, 'yellow') . "\n";
				substr $line, 0, 1, '';
			}
			elsif ($next_char eq ']') {
				# Look for OSC
				if (my ($p_s, $p_t) = $line =~ m{^\] (\d+) ; (.+?) $bell}x) {
					print colored('osc(' . colored("$p_s;$p_t", 'magenta') . ')', 'yellow') . "\n";
					substr $line, 0, length("]$p_s;$p_t") + 1, '';
				}
				else {
					print colored(' ESC ', 'blue');
				}
			}
			else {
				print colored(' ESC ', 'blue');
			}
		}
		elsif ($ord == 13) {
			print colored('\r', 'cyan');
		}
		elsif ($ord == 10) {
			print colored('\n', 'cyan');
			print "\n";
		}
		elsif ($ord < 32) {
			print colored(" [$ord] ", 'cyan');
		}
		elsif ($ord > 126) {
			print colored(" [$ord] ", 'cyan');
		}
		else {
			print $char;
		}
	}
}

1;
