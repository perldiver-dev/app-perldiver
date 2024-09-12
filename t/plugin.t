use strict;
use warnings;

use Test::More;
use Test::Exception;
use App::PerlDiver::Role::Plugin;

{
    package MockPlugin;
    use Moose;
    with 'App::PerlDiver::Role::Plugin';

    sub name { 'MockPlugin' }
    sub data { return { name => 'MockPlugin', value => 5 } }
    sub gather { return { name => 'MockPlugin', value => 5 } }
    sub render { return 5 }
}

my $plugin = MockPlugin->new;

isa_ok($plugin, 'MockPlugin');

can_ok($plugin, qw(name data gather render));

# Tests for the name method
is($plugin->name, 'MockPlugin', 'name method returns correct value');

# Tests for the data method
my $repo = {
    runs => [
        {
            date => '2023-01-01',
            data => '{"MockPlugin":{"name":"MockPlugin","value":5}}'
        },
        {
            date => '2023-01-02',
            data => '{"MockPlugin":{"name":"MockPlugin","value":10}}'
        }
    ]
};
my $data_result = $plugin->data($repo);
is_deeply($data_result, [
    { date => '2023-01-01', value => 5 },
    { date => '2023-01-02', value => 10 }
], 'data method returns correct values');

# Tests for the gather method
my $run = {
    run_files => {
        count => sub { return 5; }
    }
};
my $gather_result = $plugin->gather($run);
is($gather_result->{name}, 'MockPlugin', 'gather method returns correct name');
is($gather_result->{value}, 5, 'gather method returns correct value');

# Tests for the render method
my $run_render = {
    data => '{"MockPlugin":{"name":"MockPlugin","value":5}}'
};
my $render_result = $plugin->render($run_render);
is($render_result, 5, 'render method returns correct value');

done_testing;
