use Feature::Compat::Class;

class PerlDiver::Config {

  use YAML::XS 'LoadFile';

  field $database :reader;
  field $type :reader;
  field $user :reader;
  field $pass :reader;

  method load_config {
    my $config_data = LoadFile('perldiver.yml');
    $database = $config_data->{database};
    $type = $config_data->{type};
    $user = $config_data->{user};
    $pass = $config_data->{pass};
  }

  method dsn {
    return "dbi:$type:dbname=$database";
  }
}

1;
