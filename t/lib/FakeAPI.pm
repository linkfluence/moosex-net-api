package FakeAPI;
use Moose;
use MooseX::Net::API;

net_api_declare fake_api => (
    base_url               => 'http://identi.ca/api',
    format                 => 'json',
    format_mode            => 'append',
    require_authentication => 0,
);

net_api_method foo => (
    description => 'this does foo',
    method      => 'GET',
    path        => '/foo/',
    code        => sub { my $self = shift; $self->get_foo },
    params      => [qw/bar/],
);

net_api_method bar => (
    description => 'this does bar',
    method      => 'GET',
    path        => '/bar/',
    params      => [qw/bar baz/],
    required    => [qw/baz/],
);

net_api_method baz => (
    description => 'this one does baztwo',
    method      => 'BAZ',
    path        => '/baz/',
    params      => [qw/foo bla/],
    required    => [qw/bla/],
);

sub get_foo { return 1; }

1;
