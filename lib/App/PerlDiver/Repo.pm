package App::PerlDiver::Repo;

use 5.034000;

use Moose;
use Moose::Util::TypeConstraints;

use File::Find::Rule ();
use File::Find::Rule::Perl ();
use URI;
use File::Path 'remove_tree';
use Git::Repository;

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

  my (undef, $owner, $name) = split m[/]x, $self->uri->path;

  $self->{name} = $name;

  return $owner;
}

sub _build_name {
  my $self = shift;

  my (undef, $owner, $name) = split m[/]x, $self->uri->path;

  $self->{owner} = $owner;

  return $name;
}

has start_dir => (
  is => 'ro',
  isa => 'Str',
  lazy_build => 1,
);

sub _build_start_dir {
  my $self = shift;
  return $self->owner . '-' . $self->name;
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

sub clone {
  my $self = shift;

  Git::Repository->run( clone => $self->uri => $self->start_dir );

  return;
}

sub unclone {
  my $self = shift;

  remove_tree($self->start_dir);

  return;
}
1;
