use Test::More;
use Test::LWP::UserAgent;
use Test::Exception;
use HTTP::Response;

use_ok('PerlDiver::AuthClient');

ok(my $auth_client = PerlDiver::AuthClient->new, 'Got an object');
isa_ok($auth_client, 'PerlDiver::AuthClient', 'Object is correct class');

can_ok($auth_client, qw[ua base_url json]);

my %fields = (
  ua => 'LWP::UserAgent',
  base_url => 'URI',
  json => 'JSON',
);

for my $field (keys %fields) {
  isa_ok($auth_client->$field, $fields{$field});
}

# We're about to start testing actual HTTP requests, so we set
# up a Test::LWP::UserAgent instance and create a PerlDiver::AuthClient
# object that uses it

my $ua = Test::LWP::UserAgent->new;

my $root_response = HTTP::Response->new(
  200, 'OK', [ 'Content-Type' => 'application/json' ],
  '{"version":"0.1","status":"ok","code":200}'
);

my $auth_good_response = HTTP::Response->new(
  200, 'OK', [ 'Content-Type' => 'application/json' ],
  '{"status":"ok","user":"Dave Cross","token":"test token","code":200}'
);

my $auth_err_response = HTTP::Response->new(
  400, 'ERROR', [ 'Content-Type' => 'application/json' ],
  '{"status":"error","message":"No key provided","code":400}'
);

$ua->map_response(
  qr[/$] => $root_response
);
$ua->map_response(
  qr[/auth/test/test\?key=testkey$] => $auth_good_response,
);
$ua->map_response(
  qr[/auth/test/test\?key=$] => $auth_err_response,
);

$auth_client = PerlDiver::AuthClient->new( ua => $ua );

my $resp = $auth_client->get_root;
is($resp->{code},   200,  'Correct response code');
is($resp->{status}, 'ok', 'Correct response status');

my $token = $auth_client->get_auth('test', 'test', 'testkey');
is($token, 'test token', 'Correct auth token');

dies_ok { $auth_client->get_auth('test', 'test') };

done_testing;
