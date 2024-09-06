use Test::More;
use Test::Exception;
use DBI;

use_ok('PerlDiver::Schema');

my $schema;
lives_ok { $schema = PerlDiver::Schema->get_schema } 'Connected to database';

isa_ok($schema, 'PerlDiver::Schema');

my $dbh = $schema->storage->dbh;
isa_ok($dbh, 'DBI::db');

my $tables = $dbh->selectcol_arrayref('SELECT name FROM sqlite_master WHERE type="table"');
is_deeply($tables, [qw(file repo run run_file)], 'Correct tables in database');

done_testing;
