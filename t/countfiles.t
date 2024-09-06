use strict;
use warnings;

use Test::More;
use Test::Exception;
use App::PerlDiver::Plugin::CountFiles;

my $plugin = App::PerlDiver::Plugin::CountFiles->new;

isa_ok($plugin, 'App::PerlDiver::Plugin::CountFiles');

can_ok($plugin, qw(gather render data plot));

done_testing;
