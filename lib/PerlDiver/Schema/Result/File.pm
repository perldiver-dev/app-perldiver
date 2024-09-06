use utf8;
package PerlDiver::Schema::Result::File;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PerlDiver::Schema::Result::File

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

=head1 TABLE: C<file>

=cut

__PACKAGE__->table("file");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 repo_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 path

  data_type: 'varchar'
  is_nullable: 0
  size: 200

=head2 name

  data_type: 'char'
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "repo_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "path",
  { data_type => "varchar", is_nullable => 0, size => 200 },
  "name",
  { data_type => "char", is_nullable => 0, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 repo

Type: belongs_to

Related object: L<PerlDiver::Schema::Result::Repo>

=cut

__PACKAGE__->belongs_to(
  "repo",
  "PerlDiver::Schema::Result::Repo",
  { id => "repo_id" },
  { is_deferrable => 0, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 run_files

Type: has_many

Related object: L<PerlDiver::Schema::Result::RunFile>

=cut

__PACKAGE__->has_many(
  "run_files",
  "PerlDiver::Schema::Result::RunFile",
  { "foreign.file_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2024-09-06 16:04:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X109DBxVfjHQGwskeU33ww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
