#!/usr/bin/env perl
use strict;
use warnings;
use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use FindBin;
use lib "$FindBin::Bin/lib";
use MoQa::Schema;
my $pass = `mypass`;
my $schema = MoQa::Schema->connect('DBI:mysql:database=moqa;host=localhost', 'root', $pass);

my $dh = DH->new({
   schema              => $schema,
   script_directory    => "$FindBin::Bin/dbicdh",
   databases           => 'MySQL',
   sql_translator_args => { add_drop_table => 0 },
   force_overwrite     => 1,
});

$dh->prepare_deploy;
$dh->prepare_upgrade({ from_version => 1, to_version => 2});
$dh->upgrade;
