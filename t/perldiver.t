use strict;
use warnings;

use Test::More;
use Test::Exception;
use App::PerlDiver;

my $repo_uri = 'https://github.com/davorg/app-perldiver';
my $token = 'test_token';

dies_ok { App::PerlDiver->new() } 'Dies without required parameters';

lives_ok {
    my $diver = App::PerlDiver->new(
        repo => $repo_uri,
        token => $token,
    );
} 'Lives with required parameters';

my $diver = App::PerlDiver->new(
    repo => $repo_uri,
    token => $token,
);

isa_ok($diver, 'App::PerlDiver');

can_ok($diver, qw(run gather render));

done_testing;
