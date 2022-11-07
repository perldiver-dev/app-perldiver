package App::PerlDiver::Repo;

use 5.34.0;

use Moose;
use Moose::Util::TypeConstraints;
use URI;

subtype 'App::PerlDiver::URI' =>
  as 'URI';

coerce 'App::PerlDiver::URI' =>
  from Str =>
  via { URI->new($_) };

has uri => (
  is => 'ro',
  isa => 'App::PerlDiver::URI',
  required => 1,
  coerce => 1,
);

has [ qw[owner name] ] => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_owner {
  my $self = shift;

  warn $self->uri->path, "\n";

  my (undef, $owner, $name) = split m[/], $self->uri->path;

  $self->{name} = $name;

  return $owner;
}

sub _build_name {
  my $self = shift;

  my (undef, $owner, $name) = split m[/], $self->uri->path;

  $self->{owner} = $owner;

  return $name;
}

1;
