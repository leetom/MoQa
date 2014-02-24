package MoQa::Question;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(url_escape url_unescape html_unescape);
use Data::Printer;
#use DateTime;


my $DB = $MoQa::DB;


# This action will render a template
sub ask {
  my $self = shift;

  if($self->session('user')){
      $self->render();
  }else{
      #$self->render(template => 'user/login');
      $self->flash(message => '请先登录');
      $self->flash(referer => 'ask');
      $self->redirect_to('user/login');
  }
}

sub save {
    my $self = shift;

    my $title = $self->param('title');
    my $content = $self->param('content');
    my $tag = $self->param('tag');

    my $uid = $self->session('user')->{id};

    my $file = $self->param('file'); # Mojo::Upload object, 直接可以用了


    p $file->move_to('./public/upload/' . $file->filename); # 注意路径的分隔符

    

    $DB->do("INSERT INTO question VALUES(NULL, ?, ?, ?, NOW(), NOW());", undef, $title, $uid, $content) or die $DB::errstr;

    $self->render( text => $title . $content . $tag);

}

sub view {
    my ($self) = @_;

    my $id = $self->param('id');;

    my $sth = $DB->prepare("SELECT q.*, u.name FROM `question` q LEFT JOIN `user` u ON q.uid=u.id WHERE q.id=?");
    $sth->execute($id);

    my $question = $sth->fetchrow_hashref;

    $self->redirect_to('notfound') unless $question;

    $self->stash(question => $question);

    $self->render();

}

sub update {
    my $self = shift;

    $self->render( text => "updated!");
}

sub list {

}


sub front {
    my $self = shift;
    # my $sth = $DB->prepare("SELECT q.*, u.name from question q, user u where q.uid = u.id limit 20");
    # my $sth = $DB->prepare("SELECT q.*, UNIX_TIMESTAMP(q.created) stamp, u.name from question q LEFT JOIN user u ON q.uid = u.id ORDER BY id desc limit 20"); #UNIX_TIMESTAM 将mysql的日期时间格式改成UNIX_TIMESTAM的形式
    my $sth = $DB->prepare("SELECT q.*, u.name from question q LEFT JOIN user u ON q.uid = u.id ORDER BY id desc limit 20");
    my $questions = $DB->selectall_arrayref($sth, { Slice => {} });


    $self->res->headers->add("Power" => "MoQa");
    $self->res->headers->add("Content-type" => "text/html;Charset=utf-8");
    
    p $questions;
    $self->stash(questions => $questions);

    $self->render();
}




1;
