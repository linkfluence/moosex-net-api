package FakeAPI;
use Moose;
use MooseX::Net::API;

has api_base_url => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://identi.ca/api',
);

has format => ( is => 'ro', isa => 'Str', default => 'json', );
format_query 'format' => ( mode => 'content-type' );

net_api_method foo => (
    description => 'this does foo',
    method      => 'GET',
    path        => '/foo/',
    required    => [qw/bar/],
);

1;
