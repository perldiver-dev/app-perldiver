use utf8;
package PerlDiver::Schema::Result::Repo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlDiver::Schema::Result::Repo

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<repo>

=cut

__PACKAGE__->table("repo");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 0
  size: 50

=head2 uri

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 owner

  data_type: 'char'
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 0, size => 50 },
  "uri",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "owner",
  { data_type => "char", is_nullable => 0, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 files

Type: has_many

Related object: L<PerlDiver::Schema::Result::File>

=cut

__PACKAGE__->has_many(
  "files",
  "PerlDiver::Schema::Result::File",
  { "foreign.repo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 runs

Type: has_many

Related object: L<PerlDiver::Schema::Result::Run>

=cut

__PACKAGE__->has_many(
  "runs",
  "PerlDiver::Schema::Result::Run",
  { "foreign.repo_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-11-09 19:25:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6A2vHhI86c5zYTiEucdDYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
