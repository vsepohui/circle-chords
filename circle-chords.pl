#!/usr/bin/perl

use strict;
use warnings;
use 5.022;

my $chords = {
	maj    => [0, 4, 7, 12],
	min    => [0, 3, 7, 12],
	maj7   => [0, 4, 7, 10],
	min7   => [0, 3, 7, 10],
	sus    => [0, 5, 7, 12],
	sus2   => [0, 2, 7, 12],
	'maj+' => [0, 4, 7, 11],
	jazz   => [0, 2, 5, 11],
};

my @notes = qw(C C# D D# E F F# G G# A A# B C);


sub calc_a {
	my $tp = shift;
	my @notes = @_;
	
	my @gamma;
	for my $n (@notes) {
		push @gamma, $n + $tp;
	}
	my $sum = 0;
	for my $n (@gamma) {
		$sum += ($n * 30) / scalar @gamma;
	}
	while ($sum >= 360) {
		$sum -= 360;
	}
	$sum = int $sum;
	
	return $sum;
}

for my $n (0..359) {
	my @buff;
	for my $ch (keys %$chords) {
		for my $tp (0..12) {
			my $sum = calc_a($tp, @{$chords->{$ch}});
			push @buff, {
				a  => $sum,
				ch => $ch,
				tp => $tp,
			};
			
			for my $sept (0..12) {
				next if ($sept == $tp);
				next if ($sept ~~ $chords->{$ch});
				my $sum = calc_a($tp, @{$chords->{$ch}}, $sept);
				push @buff, {
					a  => $sum,
					ch => $ch,
					tp => $tp,
					sept => $sept,
				};				
			}
		}
	}
	
	@buff = sort {abs($a->{a} - $n) <=> abs($b->{a} - $n)} @buff;
	say "$n:";
	for (0..20) {
		my $b = $buff[$_];
		say "\t" . $notes[$b->{tp}] . (exists ($b->{sept}) ? '/' . $notes[$b->{sept}]  : ''). ': ' . $b->{ch} . ' dt='.abs($b->{a} - $n);
	}
	


}


1;
