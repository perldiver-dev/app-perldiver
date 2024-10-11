package PerlDiver::Plugin::CountFiles;

use strict;
use warnings;
use 5.034000;

use Moose;

has name => (
  is => 'ro',
  isa => 'Str',
  default => 'CountFiles',
);

with 'PerlDiver::Role::Plugin';

sub gather {
  my $self = shift;
  my ($run) = @_;

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
