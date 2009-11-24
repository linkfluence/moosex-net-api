use strict;
use warnings;
use Test::More;
use YAML::Syck;

{

    package fake::api;
    use Moose;
    use MooseX::Net::API;

    has api_base_url => (
        is      => 'ro',
        isa     => 'Str',
        default => 'http://identi.ca/api',
    );
    has format => ( is => 'ro', isa => 'Str', default => 'json', );
    has api_username => ( is => 'rw', isa => 'Str', );
    has api_password => ( is => 'rw', isa => 'Str', );
    has api_key      => ( is => 'rw', isa => 'Str', );

    format_query 'format' => ( mode => 'content-type' );

    net_api_method foo => (
        description => 'this does foo',
        method      => 'GET',
        path        => '/foo/',
        code        => sub { my $self = shift; $self->get_foo },
    );

    net_api_method public => (
        description => 'this does bar',
        method      => 'GET',
        path        => '/statuses/public_timeline',
    );

    sub get_foo { return 1; }
}

{

    package test::fake::api;
    use Moose;
    use MooseX::Net::API::Test;
    extends 'fake::api';

    test_api_method foo => (
        arguments => [qw//],
        expect    => sub {
            my $self = shift;
            warn Dump \@_;
        }
    );
}

my $obj = fake::api->new();
ok $obj, '... object created';
is $obj->foo, 1, '... get foo returns 1';
ok my $res = $obj->public, '... get public';

my $test_obj = test::fake::api->new();

#my @methods = $obj->meta->get_all_methods;
#foreach (@methods) {
    #if ( $_->name =~ /foo/ ) {
        #my @foo = $_->meta->get_attribute_list;
        #warn $_->name . " : " . Dump \@foo;
    #}
#}

#is $res->code, 200, '... request ok';
#warn $res->content;
done_testing;
