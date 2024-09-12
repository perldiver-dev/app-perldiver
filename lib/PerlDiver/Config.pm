package PerlDiver::Config;

use Moose;
use YAML::XS 'LoadFile';

has 'database' => (
    is => 'ro',
    isa => 'Str',
);

has 'type' => (
    is => 'ro',
    isa => 'Str',
);

has 'user' => (
    is => 'ro',
    isa => 'Str',
);

has 'pass' => (
    is => 'ro',
    isa => 'Str',
);

sub new_from_file {
    my $class = shift;
    my $file = (@_ ? $_[0] : 'perldiver.yml');
    my $config_data = LoadFile($file);
    return $class->new(
        database => $config_data->{database},
        type => $config_data->{type},
        user => $config_data->{user},
        pass => $config_data->{pass},
    );
}

sub dsn {
    my $self = shift;
    return "dbi:" . $self->type . ":dbname=" . $self->database;
}

1;
