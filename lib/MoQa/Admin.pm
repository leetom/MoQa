package MoQa::Admin;
use Mojo::Base 'Mojolicious::Controller';

my $DB = $MoQa::DB;

sub init{
    my $self = shift;

    # init database;

}


sub error404 {
    my $self = shift;

    $self->render(text => '404 NOT FOUND' , status => 404);
}

sub error403 {
    my $self = shift;

    $self->render(text => '403 NOT ALLOWED' , status => 403);
}
