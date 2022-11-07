package App::PerlDiver;

use 5.34.0;

use Moose;

use Module::Pluggable;

use File::Find::Rule ();
use File::Find::Rule::Perl ();

has repo => (
  is => 'ro',
  isa => 'App::PerlDiver::Repo',
  required => 1,
);

has start_dir => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_start_dir {
  return '.';
}

has files => (
  is => 'ro',
  isa => 'ArrayRef',
  lazy_build => 1,
);

sub _build_files {
  my $self = shift;

  return [ File::Find::Rule->perl_file->in($self->start_dir) ];
}

sub gather {
  my $self = shift;
}

1;
