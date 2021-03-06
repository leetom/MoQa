package MoQa::Question;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(url_escape url_unescape html_unescape);
use Data::Printer;
use MoQa::Tag;
use Data::Dumper;
#use DateTime;


sub unique {
    my $arf = shift;
    my @array = @$arf;
    my %count;
    @array = grep { ! $count{$_} ++} @array;
    return \@array;
}


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
    if($file->filename and $file->size > 0){ #上传文件了
        $file->move_to('./public/upload/' . $file->filename); # 注意路径的分隔符
    }


    my @Tags;
    if($tag){
        my @tags = split /,|\s/, $tag;
        @tags = @{unique(\@tags)};
        for my $t (@tags){
            push @Tags, MoQa::Tag->add($t);
        }
    }

    # $DB->do("INSERT INTO question VALUES(NULL, ?, ?, ?, NOW(), NOW(), 0, 0, 0);", undef, $title, $uid, $content) or die $DB::errstr;
    # my $qid = $DB->last_insert_id(undef, undef, undef, undef);

    # relate question to all tags
    #  my $sth = $DB->prepare("INSERT INTO `tagged` VALUES(NULL, ?, ?)");
    for my $tag(@Tags){
        # $sth->execute($qid, $tag->{id});
    }

    # $self->redirect_to('questionview', id => $qid);
}

sub view {
    my ($self) = @_;

    my $id = $self->param('id');;

    # $self->redirect_to('notfound') unless $question;

    # $self->stash(question => $question);

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
    #
    my $rs = $self->db->resultset('Question')->search(
        undef,
        {
            page => 1,
            rows => 20,
        });

    my @questions = $rs->all;

    p $questions[0]->created;


    $self->render(questions =>  \@questions);


=head1
    $self->res->headers->add("Power" => "MoQa");
    $self->res->headers->add("Content-type" => "text/html;Charset=utf-8");
    
    # $self->readable_time($questions->[0]->{created});
    $self->stash(questions => $questions);
=cut

}




1;
