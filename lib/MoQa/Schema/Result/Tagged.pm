use utf8;
package MoQa::Schema::Result::Tagged;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MoQa::Schema::Result::Tagged

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<tagged>

=cut

__PACKAGE__->table("tagged");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 qid

  data_type: 'integer'
  is_nullable: 0

=head2 tid

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "qid",
  { data_type => "integer", is_nullable => 0 },
  "tid",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-03-08 11:03:48
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nVzequ43jN+PUNMgao6BoQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
