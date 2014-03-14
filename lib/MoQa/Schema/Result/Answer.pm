use utf8;
package MoQa::Schema::Result::Answer;

use strict;
use warnings;

use base 'DBIx::Class::Core';


__PACKAGE__->load_components("InflateColumn::DateTime");

__PACKAGE__->table("answer");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "uid",
  { data_type => "integer", is_nullable => 0 },
  "qid",
  { data_type => "integer", is_nullable => 0 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "vote_up",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "vote_down",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");


1;
