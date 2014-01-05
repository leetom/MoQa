package MoQa;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');

  $r->get('/ask')->to('question#ask');

  $r->get('/user')->to('user#page'); # user's personal page

  $r->get('/user/login')->to('user#login');
  $r->post('/user/login')->to('user#check');

  $r->get('/user/logout')->to('user#logout');
}

1;
