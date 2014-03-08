#!/usr/bin/env perl

use strict;
use warnings;
use aliased 'DBIx::Class::DeploymentHandler' => 'DH';
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/lib";
use MoQa::Schema;

my $force_overwrite = 0;

# first, we have to create the database
# CREATE SCHEMA `moqa` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

unless ( GetOptions( 'force_overwrite=i' => \$force_overwrite ) ) {
    die "Invalid options";
}
my $pass = `mypass`;
my $schema = MoQa::Schema->connect('DBI:mysql:database=moqa;host=localhost', 'root', $pass);

my $dh = DH->new(
    {
        schema              => $schema,
        # script_directory    => "$FindBin::Bin/../dbicdh",
        script_directory    => "$FindBin::Bin/dbicdh",
        databases           => 'MySQL',
        sql_translator_args => { add_drop_table => 0 },
        force_overwrite     => $force_overwrite,
    }
);

$dh->prepare_install;
$dh->install;
