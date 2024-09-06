use Test::More;
use Test::Exception;
use DBI;

use_ok('PerlDiver::Schema');

my $dbh = DBI->connect('dbi:SQLite:dbname=db/perldiver.db', '', '', { RaiseError => 1, PrintError => 0 });
isa_ok($dbh, 'DBI::db');

my $sql = do {
    open my $fh, '<', 'db/perldiver.sql' or die $!;
    local $/;
    <$fh>;
};

$dbh->do($_) for split /;/, $sql;

my $schema = PerlDiver::Schema->get_schema();
isa_ok($schema, 'PerlDiver::Schema');

my $tables = $dbh->selectcol_arrayref('SELECT name FROM sqlite_master WHERE type="table"');
is_deeply($tables, [qw(file repo run run_file)], 'Correct tables in database');

done_testing;
