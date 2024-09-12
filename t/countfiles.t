use strict;
use warnings;

use Test::More;
use Test::Exception;
use App::PerlDiver::Plugin::CountFiles;

my $plugin = App::PerlDiver::Plugin::CountFiles->new;

isa_ok($plugin, 'App::PerlDiver::Plugin::CountFiles');

can_ok($plugin, qw(gather render data plot));

# Tests for the gather method
my $run = {
    run_files => {
        count => sub { return 5; }
    }
};
my $gather_result = $plugin->gather($run);
is($gather_result->{name}, 'CountFiles', 'gather method returns correct name');
is($gather_result->{value}, 5, 'gather method returns correct value');

# Tests for the render method
my $run_render = {
    data => '{"CountFiles":{"name":"CountFiles","value":5}}'
};
my $render_result = $plugin->render($run_render);
is($render_result, 5, 'render method returns correct value');

# Tests for the data method
my $repo = {
    runs => [
        {
            date => '2023-01-01',
            run_files => {
                count => sub { return 5; }
            },
            data => '{"CountFiles":{"name":"CountFiles","value":5}}'
        },
        {
            date => '2023-01-02',
            run_files => {
                count => sub { return 10; }
            },
            data => '{"CountFiles":{"name":"CountFiles","value":10}}'
        }
    ]
};
my $data_result = $plugin->data($repo);
is_deeply($data_result, [
    { date => '2023-01-01', value => 5 },
    { date => '2023-01-02', value => 10 }
], 'data method returns correct values');

# Tests for the plot method
my $repo_plot = {
    runs => [
        {
            date => '2023-01-01',
            run_files => {
                count => sub { return 5; }
            }
        },
        {
            date => '2023-01-02',
            run_files => {
                count => sub { return 10; }
            }
        }
    ]
};
my $plot_output;
{
    local *STDOUT;
    open STDOUT, '>', \$plot_output;
    $plugin->plot($repo_plot);
}
like($plot_output, qr/2023-01-01 : 5/, 'plot method outputs correct value for first run');
like($plot_output, qr/2023-01-02 : 10/, 'plot method outputs correct value for second run');

done_testing;
