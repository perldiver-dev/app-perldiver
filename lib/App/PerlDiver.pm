package App::PerlDiver;

use 5.034000;
use feature 'say';

use Moose;
use Moose::Util::TypeConstraints;

use Module::Pluggable instantiate => 'new';
use Path::Tiny;
use Template;
use JSON;
use Carp;

use App::PerlDiver::Repo;
use PerlDiver::Schema;
use PerlDiver::AuthClient;
use PerlDiver::Config;

has do_gather => (
  is => 'ro',
  isa => 'Bool',
  init_arg => 'gather',
  default => 1,
);

has do_render => (
  is => 'ro',
  isa => 'Bool',
  init_arg => 'render',
  default => 1,
);

coerce 'App::PerlDiver::Repo' =>
  from 'Str' =>
  via { App::PerlDiver::Repo->new(uri => $_) };

has repo => (
  is => 'ro',
  isa => 'App::PerlDiver::Repo',
  required => 1,
  coerce => 1,
);

has token => (
  is => 'ro',
  isa => 'Str',
  required => 1,
);

has schema => (
  is => 'ro',
  isa => 'PerlDiver::Schema',
  lazy_build => 1,
);

sub _build_schema {
  my $self = shift;
  return PerlDiver::Schema->get_schema($self->config);
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

has json => (
  is => 'ro',
  isa => 'JSON',
  lazy_build => 1,
);

sub _build_json {
  return JSON->new->pretty->utf8;
}

has config => (
  is => 'ro',
  isa => 'PerlDiver::Config',
  lazy_build => 1,
);

sub _build_config {
  my $self = shift;
  my $config = PerlDiver::Config->new;
  $config->load_config;
  return $config;
}

sub run {
  my $self = shift;

  PerlDiver::AuthClient->new->check_auth(
    $self->repo->owner,
    $self->repo->name,
    $self->token,
  );

  my ($db_repo) = $self->schema->resultset('Repo')->search({
    name => $self->repo->name,
    owner => $self->repo->owner,
  });

  my $run;
  
  if ($self->do_gather) {
    $run = $db_repo->add_to_runs({});
    $run->discard_changes;
  } else {
    ($run) = $db_repo->runs->search({}, {
      order_by => { -desc => 'date' },
      rows => 1,
    });

    die "No runs found. Please rerun including a gather phase.\n" unless $run;
  }

  $self->repo->clone;

  $self->gather($run) if $self->do_gather;
  $self->render($run) if $self->do_render;

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

  my %data;
  for ($self->plugins) {
    if ($_->can('gather')) {
      say "[Gather] Running ", ref $_;
      my $data = $_->gather($run);
      my $name = delete $data->{name};
      $data{$name} = $data;
    } else {
      say "[Gather] Skipping " . ref $_;
    }
  }

  $run->update({ data => $self->json->encode(\%data) });

  return;
}

sub render {
  my $self = shift;
  my ($run) = @_;

  my @plugins;
  
  for ($self->plugins) {
    if ($_->can('render')) {
      say "[Render] Running ", ref $_;
      push @plugins, $_;
    } else {
      say "[Render] Skipping " . ref $_;
    }
  }

  my $config = {
    run => $run,
    plugins => \@plugins,
  };

  $self->tt->process('index.html.tt', $config, 'index.html')
    or croak $self->tt->error;

  return;
}

1;
