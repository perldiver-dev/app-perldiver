use strict;
use warnings;

use Test::More;
use URI;

use_ok('App::PerlDiver::Repo') or BAIL_OUT('Nope');

ok(my $repo = App::PerlDiver::Repo->new(uri => URI->new('https://github.com/davorg/app-perldiver')),
   'Got an object');
isa_ok($repo, 'App::PerlDiver::Repo');

is($repo->owner, 'davorg',        'Correct owner');
is($repo->name,  'app-perldiver', 'Correct name');

ok(my $repo = App::PerlDiver::Repo->new(uri => 'https://github.com/davorg/app-perldiver'),
   'Got an object');
isa_ok($repo, 'App::PerlDiver::Repo');

done_testing;
