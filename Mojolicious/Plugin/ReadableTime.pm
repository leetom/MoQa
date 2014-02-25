package Mojolicious::Plugin::ReadableTime;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Plugin';
use DateTime;
use DateTime::Format::MySQL;

sub register {
    my ($self, $app, $conf) = @_;
    my $tz = $conf->{timezone} || 'UTC';

    $app->helper(
        readable_time => sub {
            my $self = shift;
            my $time = shift;

            my $dt = DateTime::Format::MySQL->parse_datetime($time);
            $dt->set_time_zone($tz);


            #$app->log->debug($dt->epoch);
            #
            my $seconds = time() - $dt->epoch;
            use integer;

            if($seconds < 20){
                return 'just now';
            }elsif($seconds < 60){
                return 'in a minute';
            }elsif($seconds < 600){
                return 'in 10 minutes';
            }elsif($seconds < 3600){
                return $seconds / 60 . ' minutes ago';
            }elsif($seconds < 7200){
                return 'in an hour';
            }elsif($seconds < 86400){
                return $seconds / 3600 . ' hours ago';
            }else{
                return $time;
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

