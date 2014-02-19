package MoQa::Question;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(url_escape url_unescape);

use Data::Dumper;
use DateTime;
#use utf8;

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


    $DB->do("INSERT INTO question VALUES(NULL, ?, ?, ?, NOW(), NOW());", undef, $title, 1, $content) or die $DB::errstr;

    $self->render( text => url_escape($title . $content . $tag));

}

sub update {
    my $self = shift;

    $self->render( text => "updated!");
}

sub list {

}


sub front {
    my $self = shift;
    my $sth = $DB->prepare("SELECT * from question limit 20");
    my $questions = $DB->selectall_arrayref($sth, { Slice => {} });

    
    $self->res->headers->add("Power" => "MoQa");
    $self->res->headers->add("Content-type" => "text/html;Charset=utf-8");
    $self->render(questions => $questions, test => "THI这个很不错");
}




1;
