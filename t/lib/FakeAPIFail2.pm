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

net_api_method baz => (
    description => 'this one does baztwo',
    method      => 'BAZ',
    path        => '/baz/',
    params      => [qw/foo/],
    required    => [qw/bla/],
);

sub get_foo { return 1; }

1;
