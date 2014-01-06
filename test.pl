use 5.010;
use Mojo::Util qw(url_escape url_unescape);

my $es = url_escape("<h1>good'");

say $es;

say url_unescape($es);


