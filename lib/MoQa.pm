package MoQa;

use Mojo::Base 'Mojolicious';
use DBI;

# This method will run once at server start
#
#connect to db
#
my $pass = `mypass`;
our $DB = DBI->connect("DBI:mysql:database=moqa;host=localhost", "root", $pass, 
    {'RaiseError' => 1, mysql_enable_utf8 => 1,}
);

$DB->do("SET CHARSET 'UTF8'");
$DB->do("SET NAMES 'UTF8'");


sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');

  $self->plugin(
      'captcha',
      {
              session_name    => 'captcha_string',
              out                     => {force => 'jpeg'},
              particle                => [200,0],
              create                  => ["normal", "rect", "#cc0000"],
              new                     => {
                  rnd_data        => [2..9, 'A'..'H', 'J'..'Z'],
                  width           => 80,
                  height          => 30,
                  lines           => 1,
                  gd_font         => 'giant',
              }
      }
  );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('question#front');

  $r->get('/ask')->to('question#ask');
  $r->post('/question/save')->to('question#save');

  $r->get('/user')->to('user#page'); # user's personal page

  $r->get('/user/login')->to('user#login');
  $r->post('/user/login')->to('user#check');

  $r->get('/user/reg')->to('user#reg');
  $r->post('/user/reg')->to('user#save');
  $r->get('/user/captcha')->to('user#captcha');

  $r->get('/user/logout')->to('user#logout');


  $r->get('/admin/init')->to('admin#init');
}

1;
