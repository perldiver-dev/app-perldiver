use strict;
use warnings;

use Test::More;
use Test::Exception;
use PerlDiver::App;

my $repo_uri = 'https://github.com/davorg/app-perldiver';
my $token = 'test_token';

dies_ok { PerlDiver::App->new() } 'Dies without required parameters';

lives_ok {
    my $diver = PerlDiver::App->new(
        repo => $repo_uri,
        token => $token,
    );
} 'Lives with required parameters';

my $diver = PerlDiver::App->new(
    repo => $repo_uri,
    token => $token,
);

isa_ok($diver, 'PerlDiver::App');

can_ok($diver, qw(run gather render));

# Tests for the run method
lives_ok { $diver->run } 'run method executes without error';

# Tests for the gather method
my $run = $diver->schema->resultset('Run')->create({});
lives_ok { $diver->gather($run) } 'gather method executes without error';

# Tests for the render method
lives_ok { $diver->render($run) } 'render method executes without error';

done_testing;
