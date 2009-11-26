package Identica;
use Moose;
use MooseX::Net::API;

has [qw/api_username api_password/] => ( is => 'ro', isa => 'Str' );

net_api_declare identica => (
    base_url       => 'http://identi.ca/api',
    format         => 'json',
    format_mode    => 'append',
    authentication => 1,
);
net_api_method public_timeline => (
    path   => '/statuses/public_timeline',
    method => 'GET',
);

net_api_method update_status => (
    path          => '/statuses/update',
    method        => 'POST',
    params        => [qw/status/],
    required      => [qw/status/],
    params_in_url => 1,
);
