package MoQa;

use Mojo::Base 'Mojolicious';
use DBI;

# This method will run once at server start
#
#connect to db
#
my $pass = `mypass`;
print $pass;
our $DB = DBI->connect("DBI:mysql:database=moqa;host=localhost", "root", $pass, 
    {'RaiseError' => 1}
);


sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('question#front');

  $r->get('/ask')->to('question#ask');
  $r->post('/question/save')->to('question#save');

  $r->get('/user')->to('user#page'); # user's personal page

  $r->get('/user/login')->to('user#login');
  $r->post('/user/login')->to('user#check');

  $r->get('/user/logout')->to('user#logout');
}

1;
