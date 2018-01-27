#!/usr/bin/perl

use strict;
use warnings;
use LWP;
use URI::Escape;

if (@ARGV != 2){
	print "Usage: $0 [KEY(s)] [PAGES NUMBER]\n";
	print "\tEx 1: $0 perl 4\n";
	print "\tEx 2: $0 hacker,pentester 1\n";
	exit 1;
}

sub uniq {
	my %seen;
	grep !$seen{$_}++, @_;
}


my $browser = LWP::UserAgent->new;
$browser->agent("Mozilla/5.0");
$browser->cookie_jar({});

my $pages = $ARGV[1];
my @keys = split(/,/,$ARGV[0]);

my @all_links;

foreach my $key (@keys){
	print "\n===============[ KEYWORD : $key ]===============\n\n";
	for (my $i=1; $i <= $pages; $i++){
		my $start = ($i*10)-10;
		my $url = "https://www.google.com/search?q=$key&start=$start";
	
		print "=====================[ PAGE $i ]=====================\n";

		my $req = $browser->get($url);
		my $res = $req->content;

		my @links;

		while ($res =~ s/<a href="\/url\?q=([^"&;\s]*).*>//){
			push @links, $1;
		}
	
		foreach my $link (uniq(@links)){
			push @all_links, $link;
			$link = uri_unescape($link);
			print "$link\n";
		}
	}
	sleep 2;
}
print "\nTOTAL FOUND: " . scalar @all_links . "\n";
