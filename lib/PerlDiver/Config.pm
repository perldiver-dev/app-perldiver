use Feature::Compat::Class;

class PerlDiver::Config {

  use YAML::XS 'LoadFile';

  field $database;

  method load_config {
    my $config_data = LoadFile('perldiver.yml');
    $database = $config_data->{database};
  }
}

1;
