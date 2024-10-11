package PerlDiver::Plugin::PodCoverage;

use strict;
use warnings;
use 5.034000;

use Moose;
use Pod::Coverage;

has name => (
  is => 'ro',
  isa => 'Str',
  default => 'PodCoverage',
);

with 'PerlDiver::Role::Plugin';

sub gather {
  my $self = shift;
  my ($run) = @_;
    
  return {
    name => 'PodCoverage',
    value => $self->pod_coverage($run),
  };
}

sub pod_coverage {
  my $self = shift;
  my ($run) = @_;

  my $data;

  for my $file ($run->run_files) {
    my $pod = $file->pod_coverage;
    my $total = $file->pod_coverage_total;
    my $covered = $file->pod_coverage_covered;

    say $file->path, ' : ', $pod, ' : ', $total, ' : ', $covered;
  }
}

1;
