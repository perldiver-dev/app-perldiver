use Test::More;
use Test::Exception;
use PerlDiver::Config;

my $config = PerlDiver::Config->new;

isa_ok($config, 'PerlDiver::Config');

can_ok($config, qw(load_config database));

lives_ok { $config->load_config } 'Config loaded without error';

is($config->database, 'db/perldiver.db', 'Database attribute is correct');

done_testing;
