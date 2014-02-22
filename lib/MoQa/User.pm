package MoQa::User;
use Mojo::Base 'Mojolicious::Controller';

use Data::Printer;
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
        p @message;
        #将错误信息flash到注册页面
        $self->flash(message => \@message);
        $self->redirect_to("user/reg");
    }
}

sub myrand { 
    my $max = shift; 
    my $result; 
    my $randseed = $LBCGI::randseed ; 
    $max ||= 1; 
    eval("\$result = rand($max);"); 
    return $result unless ($@); 
    $randseed = time unless ($randseed); 
    my $x = 0xffffffff; 
    $x++; 
    $randseed *= 134775813; 
    $randseed++; 
    $randseed %= $x; 
    return $randseed * $max / $x; 
} 

sub captcha_img{
    no strict "refs";
    my $verifynum=shift; 
    my @n0 = ("3c","66","66","66","66","66","66","66","66","3c"); 
    my @n1 = ("1c","0c","0c","0c","0c","0c","0c","0c","1c","0c"); 
    my @n2 = ("7e","60","60","30","18","0c","06","06","66","3c"); 
    my @n3 = ("3c","66","06","06","06","1c","06","06","66","3c"); 
    my @n4 = ("1e","0c","7e","4c","2c","2c","1c","1c","0c","0c"); 
    my @n5 = ("3c","66","06","06","06","7c","60","60","60","7e"); 
    my @n6 = ("3c","66","66","66","66","7c","60","60","30","1c"); 
    my @n7 = ("30","30","18","18","0c","0c","06","06","66","7e"); 
    my @n8 = ("3c","66","66","66","66","3c","66","66","66","3c"); 
    my @n9 = ("38","0c","06","06","3e","66","66","66","66","3c"); 

    for (my $i = 0; $i < 10; $i++){ 
        for (1 .. 6){ 
            my $a1 = substr("012", int(myrand(3)), 1) . substr("012345", int(myrand(6)), 1); 
            my $a2 = substr("012345",int(myrand(6)),1) . substr("0123", int(myrand(4)), 1); 
            int(myrand(2)) eq 1 ? push(@{"n$i"}, $a1) : unshift(@{"n$i"},$a1); 
            int(myrand(2)) eq 0 ? push(@{"n$i"}, $a1) : unshift(@{"n$i"},$a2); 
        } 
    } 

    my @bitmap = (); 

    for (my $i = 0; $i < 20; $i++){ 
        for (my $j = 0; $j < 4; $j++){ 
            my $n = substr($verifynum, $j, 1); 
            my $bytes = ${"n$n"}[$i]; 
            my $a = int(myrand(15)); 
            $a eq 1 ? $bytes =~ s/9/8/g : $a eq 3 ? $bytes =~ s/c/e/g : $a eq 6 ? $bytes =~ s/3/b/g : $a eq 8 ? $bytes =~ s/8/9/g : $a eq 0 ? $bytes =~ s/e/f/g : 1; 
            push(@bitmap, $bytes); 
        } 
    } 
    for (my $i = 0; $i < 8; $i++){ 
        my $a = substr("012", int(myrand(3)), 1) . substr("012345", int(myrand(6)), 1); 
        unshift(@bitmap, $a); 
        push(@bitmap, $a); 
    } 

    my $image = '424d9e000000000000003e0000002800'; 
    $image .= "00002000000018000000010001000000"; 
    $image .= "00006000000000000000000000000000"; 
    $image .= "00000000000000000000FFFFFF00"; 
    $image .= join('', @bitmap); 
    $image = pack ('H*', $image); 

    return $image; 
}

sub captcha{
    my $self = shift;

    $self->res->headers->add("Content-type" => "image/bmp");

    my $image = captcha_img(0000); 

    $self->render(data => $image);
}



sub page {
    my $self = shift;
    if($self->session('user')){

        my $uid = $self->session('user')->{id};

        my $sth = $DB->prepare('SELECT * from `question` where `uid`= ? LIMIT 20');

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
