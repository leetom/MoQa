package MoQa::Tag;
use Mojo::Base 'Mojolicious::Controller';
use Data::Printer;

my $DB = $MoQa::DB;

sub new {
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



1;
