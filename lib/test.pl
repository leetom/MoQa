#!/usr/bin/perl
#
use Mojo::Util qw(:all);

my $str = "<h1>good&nbsp;&copy;</h1>";

print html_unescape($str);
