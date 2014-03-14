use utf8;
package MoQa::Schema::Result::Role;


use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("role");


__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "perm",
  { data_type => "integer", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");


1;
