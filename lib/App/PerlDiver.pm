package App::PerlDiver;

use 5.34.0;

use Moose;
use Moose::Util::TypeConstraints;

use Module::Pluggable;

use App::PerlDiver::Repo;
use PerlDiver::Schema;

coerce 'App::PerlDiver::Repo' =>
  from 'Str' =>
  via { App::PerlDiver::Repo->new(uri => $_) };

has repo => (
  is => 'ro',
  isa => 'App::PerlDiver::Repo',
  required => 1,
  coerce => 1,
);

has schema => (
  is => 'ro',
  isa => 'PerlDiver::Schema',
  lazy_build => 1,
);

sub _build_schema {
  return PerlDiver::Schema->get_schema;
}

sub gather {
  my $self = shift;
}

1;
