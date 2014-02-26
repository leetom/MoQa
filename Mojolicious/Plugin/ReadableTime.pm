package Mojolicious::Plugin::ReadableTime;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';
use DateTime;
use DateTime::Format::MySQL;

sub register {
    my ($self, $app, $conf) = @_;
    my $tz = $conf->{timezone} || 'UTC';
    my $lang = $conf->{lang} || 'en';
    my $showago = $conf->{showago} || 'ago';

    my %output = (
        cn => [
            '刚刚',
            '1分钟之内',
            '%d分钟之前',
            '1小时之前',
            '%d小时之前',
            '1天之前',
            '%d天之前',
            '1个月之前',
            '%d个月之前',
            '1年之前',
            '%d年之前',
        ],

        en => [
            'just now',
            'in a minute',
            '%d minutes ago',
            'an hour ago',
            '%d hours ago',
            'a day ago',
            '%d days ago',
            'a month ago',
            '%d months ago',
            'a year ago',
            '%d years ago',
        ]
    );



    $app->helper(
        readable_time => sub {
            my $self = shift;
            my $time = shift;

            my $dt = DateTime::Format::MySQL->parse_datetime($time);
            $dt->set_time_zone($tz);

            use integer;
            my $seconds = time() - $dt->epoch;
            sub rep {
                my($str, $num) = @_;
                $str =~ s/%d/$num/ if $num;
                $str;
            }

            if($seconds < 20){
                return $output{$lang}->[0]; #刚刚
            }elsif($seconds < 60){
                return $output{$lang}->[1]; #1分钟之内
            }elsif($seconds < 3600){
                my $min = $seconds / 60;
                return rep($output{$lang}->[2], $min); #n分钟之前
            }elsif($seconds < 7200){
                return $output{$lang}->[3]; #一小时之前
            }elsif($seconds < 86400){
                my $hours = $seconds / 3600;
                return rep($output{$lang}->[4], $hours); #n小时之前
            }elsif($seconds < 172800){
                return $output{$lang}->[5]; #1天之前
            }elsif($seconds < 2592000){
                my $days = $seconds / 86400; 
                return rep($output{$lang}->[6], $days);
            }elsif($seconds < 5184000){
                return $output{$lang}->[7]; #一个月之前
            }elsif($seconds < 31536000){
                my $months = $seconds / 2592000;
                return rep($output{$lang}->[8], $months); #n个月之前
            }elsif($seconds < 63072000){
                return $output{$lang}->[9]; #一年之前
            }else{
                my $years = $seconds / 31536000;
                return rep($output{$lang}->[10], $years);
            }
        }
    );
}

1;

=head1 NAME

Mojolicious::Plugin::ReadableTime

=head1 VERSION
0.01

=head1 SYNOPSIS
    $self->plugin('ReadableTime', {timezone => 'Asia/Shanghai'});
    timezone option should the the timezone of the running MySQL
=cut

