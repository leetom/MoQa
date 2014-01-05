package MoQa::Question;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

# This action will render a template
sub ask {
  my $self = shift;

  if($self->session('user')){
      $self->render();
  }else{
      #$self->render(template => 'user/login');
      $self->flash(message => '请先登录');
      $self->flash(referer => 'user/login');
      $self->redirect_to('user/login');
  }
}

sub save {
    my $self = shift;

}



1;
