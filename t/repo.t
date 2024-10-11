use strict;
use warnings;

use Test::More;
use URI;
use File::Path 'remove_tree';
use Git::Repository;
use File::Find::Rule;

use_ok('PerlDiver::Repo') or BAIL_OUT('Nope');

ok(my $repo = PerlDiver::Repo->new(uri => URI->new('https://github.com/davorg/app-perldiver')),
   'Got an object');
isa_ok($repo, 'PerlDiver::Repo');

is($repo->owner, 'davorg',        'Correct owner');
is($repo->name,  'app-perldiver', 'Correct name');

ok($repo = PerlDiver::Repo->new(uri => 'https://github.com/davorg/app-perldiver'),
   'Got an object');
isa_ok($repo, 'PerlDiver::Repo');

# Tests for the clone method
lives_ok { $repo->clone } 'clone method executes without error';

# Tests for the unclone method
lives_ok { $repo->unclone } 'unclone method executes without error';

# Tests for the files method
my $files = $repo->files;
isa_ok($files, 'ARRAY', 'files method returns an array reference');
ok(@$files > 0, 'files method returns non-empty array reference');

done_testing;
