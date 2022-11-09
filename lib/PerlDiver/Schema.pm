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

sub get_schema {
  my @errors;

  foreach (qw[DIVER_DB_HOST DIVER_DB_NAME DIVER_DB_USER DIVER_DB_PASS]) {
    push @errors, $_ unless defined $ENV{$_};
  }

  if (@errors) {
    die 'Please set the following environment variables: ',
        join(', ', @errors), "\n";
  }

  my $dsn = "dbi:mysql:host=$ENV{DIVER_DB_HOST};database=$ENV{DIVER_DB_NAME}";
  if ($ENV{DIVER_DB_PORT}) {
    $dsn .= ";port=$ENV{DIVER_DB_PORT}";
  }

  my $sch = __PACKAGE__->connect(
    $dsn, $ENV{DIVER_DB_USER}, $ENV{DIVER_DB_PASS},
    { mysql_enable_utf8 => 1, quote_char => '`' },
  );

  # For caching.
  $DBIx::Class::ResultSourceHandle::thaw_schema = $sch;

  return $sch;
}

1;
