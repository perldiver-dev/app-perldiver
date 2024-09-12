use Test::More;
use Test::Exception;
use PerlDiver::Config;

my $config = PerlDiver::Config->new_from_file;

isa_ok($config, 'PerlDiver::Config');

can_ok($config, qw(new_from_file database));

lives_ok { $config = PerlDiver::Config->new_from_file } 'Config loaded without error';

is($config->database, 'db/perldiver.db', 'Database attribute is correct');

done_testing;
