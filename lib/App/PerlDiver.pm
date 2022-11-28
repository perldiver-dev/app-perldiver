package App::PerlDiver;

use 5.034000;
use feature 'say';

use Moose;
use Moose::Util::TypeConstraints;

use Module::Pluggable instantiate => 'new';
use Path::Tiny;
use Template;
use Carp;

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

has tt => (
  is => 'ro',
  isa => 'Template',
  lazy_build => 1,
);

sub _build_tt {
  my $self = shift;
  return Template->new( $self->tt_config );
}

has tt_config => (
  is => 'ro',
  isa => 'HashRef',
  lazy_build => 1,
);

sub _build_tt_config {
  return {
    INCLUDE_PATH => [qw/src tt_lib/],,
    OUTPUT_PATH => 'out',
  };
}

sub run {
  my $self = shift;

  my ($db_repo) = $self->schema->resultset('Repo')->search({
    name => $self->repo->name,
    owner => $self->repo->owner,
  });

  my $run = $db_repo->add_to_runs({});

  $self->repo->clone;

  $self->gather($run);
  $self->render($run);

  $self->repo->unclone;

  return;
}

sub gather {
  my $self = shift;
  my ($run) = @_;

  for (@{$self->repo->files}) {
    say $_;
    my $file = path($_);
    my $path = $file->parent->stringify;
    my $name = $file->basename;

    my $db_file = $run->repo->files->find_or_create({
      path => $path,
      name => $name,
    });

    $run->add_to_run_files({
      file_id => $db_file->id,
    });
  }

  for ($self->plugins) {
    if ($_->can('gather')) {
      say "[Gather] Running ", ref $_;
      $_->gather($run);
    } else {
      say "[Gather] Skipping " . ref $_;
    }
  }

  return;
}

sub render {
  my $self = shift;
  my ($run) = @_;

  my @plugins = map { $_->can('render') } $self->plugins;

  my $config = {
    run => $run,
    plugins => \@plugins,
  };

  $self->tt->process('index.html.tt', $config, 'index.html')
    or croak $self->tt->error;

  return;
}

1;
