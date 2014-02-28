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

  #时间插件(自己写的)
  $self->plugin('ReadableTime', {timezone => 'Asia/Shanghai', lang => 'cn'});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  # main nav links
  $r->get('/')              ->to('question#front')  ->name('home');
  $r->get('/tags')          ->to('tag#all')         ->name('tags');
  $r->get('/users')         ->to('user#all')        ->name('users');
  $r->get('/badges')        ->to('badge#all')       ->name('badges');
  $r->get('/ask')           ->to('question#ask')    ->name('questionask');
  $r->post('/question/save')->to('question#save')   ->name('questionsave');

  #显示问题，by id
  $r->get('/question/:id' => [ id => qr/\d+$/ ])->to('question#view')->name('questionview');
  $r->get('/q/:id' => [ id => qr/\d+$/ ])->to('question#view')->name('qview');

  # $r->get('/question/:name' => [ id => qr/\d+$/ ])->to('question#view'); #考虑要不要加这个

  $r->get('/user')->to('user#page'); # user's personal page

  $r->get('/user/login')->to('user#login');
  $r->post('/user/login')->to('user#check');

  $r->get('/user/reg')->to('user#reg');
  $r->post('/user/reg')->to('user#save');
  $r->get('/user/captcha')->to('user#captcha');

  $r->get('/user/logout')->to('user#logout');


  $r->get('/admin/init')->to('admin#init');

  $r->get('/error/404')->to('admin#error404')->name('notfound');
  $r->get('/error/403')->to('admin#error403')->name('notallowed');
}

1;
