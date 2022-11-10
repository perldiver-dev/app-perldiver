package App::PerlDiver::Plugin::CountFiles;

use strict;
use warnings;
use 5.34.0;

use Moose;

sub render {
  my $self = shift;
  my ($run) = @_;

  say $run->run_files->count;

  $self->plot($run->repo);
}

sub plot {
  my $self = shift;
  my ($repo) = @_;

  for ($repo->runs) {
    say $_->date, ' : ', $_->run_files->count;
  }
}

1;

