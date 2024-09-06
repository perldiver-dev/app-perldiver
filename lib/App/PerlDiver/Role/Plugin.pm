package App::PerlDiver::Role::Plugin;

use Moose::Role;

requires qw(name data);

has json => (
    is => 'ro',
    isa => 'JSON',
    lazy_build => 1,
);

sub _build_json {
    return JSON->new->pretty->utf8;
}

sub gather {
    my $self = shift;
    # Placeholder method
}

sub render {
    my $self = shift;
    # Placeholder method
}

1;
