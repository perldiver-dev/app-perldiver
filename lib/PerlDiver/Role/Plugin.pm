package PerlDiver::Role::Plugin;

use Moose::Role;

requires qw(name data gather render);

has json => (
    is => 'ro',
    isa => 'JSON',
    lazy_build => 1,
);

sub _build_json {
    return JSON->new->pretty->utf8;
}

1;
