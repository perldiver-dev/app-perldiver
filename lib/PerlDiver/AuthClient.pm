use Feature::Compat::Class;

class PerlDiver::AuthClient {

  use LWP::UserAgent;
  use JSON;
  use URI;

  field $ua :param ||= LWP::UserAgent->new;
  field $base_url :param ||= URI->new($ENV{PD_AUTH_URL} or 'https://pdauth.perlhacks.com/');
  field $json :param ||= JSON->new;

  method ua { return $ua }
  method base_url { return $base_url }
  method json { return $json }

  method get {
    my $resp = $ua->get(@_);

    if ($resp->is_error) {
      die $resp->status_line;
    }

    return $json->decode($resp->decoded_content);
  }

  method get_root {
    return $self->get($base_url->as_string);
  }

  method get_auth {
    my ($repo_owner, $repo_name, $key) = @_;

    my $resp = $self->get("${base_url}auth/$repo_owner/$repo_name?key=$key");

    if ($resp->{status} eq 'error' or $resp->{code} != 200) {
      die "$resp->{code} $resp->{message}";
    }

    die "Missing token in auth response" unless $resp->{token};

    return $resp->{token};
  }

  method check_auth {
    my ($repo_owner, $repo_name, $token) = @_;
    
    my $resp = $self->get("${base_url}check/$repo_owner/$repo_name?token=$token");

    die "Unauthorised\n" unless $resp->{authorised};

    return 1;
  }
}

1;
