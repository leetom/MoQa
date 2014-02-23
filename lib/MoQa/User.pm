package MoQa::User;
use Mojo::Base 'Mojolicious::Controller';

use Data::Printer;
use Digest::MD5 qw(md5_hex);
use Mojo::JSON qw(decode_json encode_json);

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
    my ($self, $name, $pass) = @_;


    my $secret = md5_hex($pass);
    say $name . $secret;

    my $sth = $DB->prepare("SELECT * FROM user WHERE name=? and pass=?");

    $sth->execute($name, $secret);
    my $row = $sth->fetchrow_hashref;

    p $row; # hash ref to the user.

    if($row){ # 查找出来有此用户
        return $row ; #登录成功, 0为uid
    }
    0;
}

sub check {
  my $self = shift;

  my $username = $self->param('username');
  my $password = $self->param('password');
  my $redirect = $self->param('referer');

  my $user = $self->_check_user($username, $password);

  if($user){
      $self->session('user' => $user);
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

  $self->redirect_to('/');
}

# register page, GET user/reg
sub reg {
    my $self = shift;

    $self->render();
}

# reg help methods
sub check_username{
    my $self = shift;
    my $name = shift;
    if($name !~ /^\w+$/){ #格式
        return { msg => "只能使用字母/数字/下划线", code => 1, field => "username"};
    }
    my $sth = $DB->prepare("SELECT COUNT(*) FROM user WHERE name=?");
    $sth->execute($name);
    my @row = $sth->fetchrow_array;

    if($row[0] > 0){ # 是否重复
        return { msg => "用户名已存在", code => 2, field => "username"};
    }

    0; #检查通过
}

sub check_email{
    my $self = shift;

    my $email = shift;
    if($email !~ /^.+@\w+(?:\.\w+)+$/){ # 格式
        return { msg => "邮箱格式不正确", code => 1, field => "email"};
    }
    my $sth = $DB->prepare("SELECT COUNT(*) FROM user WHERE email=?");
    $sth->execute($email);
    my @row = $sth->fetchrow_array;

    if($row[0] > 0){ # 是否重复
        return { msg => "邮箱已经注册", code => 2, field => "email"};
    }

    0; #检查通过
}

# register, POST user/reg
sub save {
    my $self = shift;

    if($self->validate_captcha($self->param('captcha'))){ #验证码
        my $username = $self->param("username");
        my $email = $self->param("email");
        my $password = $self->param("password");

        my $check_name = $self->check_username($username);
        my $check_email = $self->check_email($email);

        my @message;

        if($check_name == 0){
            #名字检查通过
        }else{
            push @message, $check_name;
        }
        if($check_email == 0){
            #邮箱检查通过
        }else{
            push @message, $check_email;
        }

        if(@message  == 0){
            #没有错误
            eval{ $DB->do("INSERT INTO `user` (`name`, `pass`, `email`) VALUES (?, ?, ?);", 
                    undef, # attributes, options. normally undef
                    $username, md5_hex($password), $email); 
            };

            $self->render(text => "good");
        }else{
            #将错误信息flash到注册页面
            $self->flash(message => encode_json(\@message));
            $self->redirect_to("user/reg");
        }
    }else{
        $self->render(text => '验证码错误');
    }
}


sub captcha{
    my $self = shift;

    $self->res->headers->add("Content-type" => "image/jpg");

    $self->render(data => $self->create_captcha);
}



sub page {
    my $self = shift;
    if($self->session('user')){

        my $uid = $self->session('user')->{id};

        my $sth = $DB->prepare('SELECT q.*, u.name from `question` q LEFT JOIN `user` u ON q.uid = u.id where `uid`= ? LIMIT 20');

        p $uid;

        my $questions = $DB->selectall_arrayref($sth, { Slice => {} }, $uid);

        # while($row = $sth->fetchrow_hashref){ #也可以用 selectall_arrayref
        # }
        
        p $questions;
        $self->render(questions => $questions);
    }else{
        $self->redirect_to('user/login');
    }
}

1;
