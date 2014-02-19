package MoQa::User;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;
use Digest::MD5 qw(md5_hex);

my $DB = $MoQa::DB;

# This action will render a template
sub login {
  my $self = shift;

  if($self->session('user')){
      $self->render(text => 'hello ' . $self->session('user'), format => 'txt');
  }else{
      $self->render();
  }
}

# check user against DB
sub _check_user{
    my ($name, $pass) = @_;


    my $secret = md5_hex($pass);
    say $name . $secret;

    my $sth = $DB->prepare("SELECT COUNT(*) FROM user WHERE name=? and pass=?");

    $sth->execute($name, $secret);
    my @row = $sth->fetchrow_array;


    if($row[0] > 0){ # 查找出来有此用户
        return 1;
    }
    0;
}

sub check {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');
  my $redirect = $self->param('referer');

  if(_check_user($username, $password)){
      $self->session('user' => $username);
      $self->session('uid' => 1);
      if($redirect){
          $self->redirect_to($redirect);
      }else{
          $self->redirect_to('user');
      }
  }else{
      $self->flash(message => '用户名或密码错误');
      $self->redirect_to('user/login');
  }
}

sub logout {
  my $self = shift;
  delete $self->session->{user};
  delete $self->session->{uid};

  $self->redirect_to('/');
}

sub reg {
    my $self = shift;

    $self->render();
}

sub save {
    my $self = shift;
    $self->render();
}


sub page {
    my $self = shift;
    $self->render(text => "hello, " . $self->session('user'));
}

1;
