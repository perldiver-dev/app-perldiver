package App::PerlDiver::Plugin::CountFiles;

use strict;
use warnings;
use 5.034000;

use Moose;

has name => (
  is => 'ro',
  isa => 'Str',
  default => 'CountFiles',
);

with 'App::PerlDiver::Role::Plugin';

sub gather {
  my $self = shift;
  my ($run) = @_;

  # Ensure $run is a blessed reference
  die "Invalid run object" unless ref($run) && ref($run) ne 'HASH';

  return {
    name => 'CountFiles',
    value => $run->run_files->count
  };
}

sub render {
  my $self = shift;
  my ($run) = @_;

  my $data = $self->json->decode($run->data);

  return $data->{$self->name}{value};
}

sub data {
  my $self = shift;
  my ($repo) = @_;

  my @data;

  for ($repo->runs) {
    push @data, {
      date => $_->date,
      value => $self->render($_),
    };
  }

  return \@data;
}

sub plot {
  my $self = shift;
  my ($repo) = @_;

  for ($repo->runs) {
    say $_->date, ' : ', $_->run_files->count;
  }

  return;
}

1;
