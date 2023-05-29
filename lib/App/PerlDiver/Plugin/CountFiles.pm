package App::PerlDiver::Plugin::CountFiles;

use strict;
use warnings;
use 5.034000;

use JSON;
use Moose;

has name => (
  is => 'ro',
  isa => 'Str',
  default => 'CountFiles',
);

has json => (
  is => 'ro',
  isa => 'JSON',
  default => sub { JSON->new->pretty },
);

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

sub plot {
  my $self = shift;
  my ($repo) = @_;

  for ($repo->runs) {
    say $_->date, ' : ', $_->run_files->count;
  }

  return;
}

1;

