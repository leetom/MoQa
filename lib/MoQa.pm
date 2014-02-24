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

  #验证码插件
  $self->plugin(
      'captcha',
      {
              session_name    => 'captcha_string',
              out                     => {force => 'jpeg'},
              particle                => [200,0], #干扰粒子的密度
              create                  => ["normal", "rect", "#cc0000"], #参数, 详见perldoc GD::SecurityImage
              new                     => {
                  rnd_data        => [2..9, 'A'..'H', 'J'..'Z'], #选择的数字
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
  # main nav links
  $r->get('/')->name('home')->to('question#front');
  $r->get('/tags')->name('tags')->to('tag#all');
  $r->get('/users')->name('users')->to('user#all');
  $r->get('/badges')->name('badges')->to('badge#all');

  $r->get('/ask')->to('question#ask');
  $r->post('/question/save')->to('question#save');

  #显示问题，by id
  $r->get('/question/:id' => [ id => qr/\d+$/ ])->to('question#view');
  $r->get('/q/:id' => [ id => qr/\d+$/ ])->to('question#view');

  # $r->get('/question/:name' => [ id => qr/\d+$/ ])->to('question#view'); #考虑要不要加这个

  $r->get('/user')->to('user#page'); # user's personal page

  $r->get('/user/login')->to('user#login');
  $r->post('/user/login')->to('user#check');

  $r->get('/user/reg')->to('user#reg');
  $r->post('/user/reg')->to('user#save');
  $r->get('/user/captcha')->to('user#captcha');

  $r->get('/user/logout')->to('user#logout');


  $r->get('/admin/init')->to('admin#init');

  $r->get('/error/404')->name('notfound')->to('admin#error404');
  $r->get('/error/403')->name('notallowed')->to('admin#error403');
}

1;
