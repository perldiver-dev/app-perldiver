use utf8;
package PerlDiver::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-11-08 18:05:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n/czIebb5x2gqLteRODsqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

use PerlDiver::Config;

sub get_schema {
    my $self = shift;
    my ($config) = @_;
    $config //= PerlDiver::Config->new_from_file;
    return $self->connect($config->dsn, $config->user, $config->pass);
}

1;
