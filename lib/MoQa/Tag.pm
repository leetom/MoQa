package MoQa::Tag;
use Mojo::Base 'Mojolicious::Controller';
use Data::Printer;

my $DB = $MoQa::DB;

# 不能用new, new应该继承来，否则会出问题(stash等)
sub add {
    my ($self, $name) = @_;

    my $sth = $DB->prepare("SELECT * FROM `tag` WHERE name=?");
    $sth->execute($name);

    my $tag = $sth->fetchrow_hashref;

    if($tag){
        $DB->do("UPDATE `tag` set related=related+1 WHERE name=?", undef, $name);
        return bless $tag;
    }else{
        #插入 tag;
        $DB->do("INSERT INTO `tag` (name, related) VALUES (?, 1)", undef, $name);

        return bless { name => $name, id => $DB->last_insert_id(undef, undef, undef, undef)};
    }

}

sub all {
    my $self = shift;

    my $sth = $DB->prepare("SELECT * FROM `tag` LIMIT 50");

    my $tags = $DB->selectall_arrayref($sth, { Slice => {} });

    $self->stash(tags => $tags);

    $self->render();
}



1;
