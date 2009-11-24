package MooseX::Net::API;

use Moose::Exporter;
use Carp;
use Try::Tiny;

our $VERSION = '0.01';

our $list_content_type = {
    'json' => 'application/json',
    'yaml' => 'text/x-yaml',
    'xml'  => 'text/xml',
};
our $reverse_content_type = { 'application/json' => 'json', };

Moose::Exporter->setup_import_methods(
    with_caller => [ qw/net_api_method format_query require_authentication/ ],
);

sub format_query {
    my ( $caller, $name, %options ) = @_;

    Moose::Meta::Class->initialize($caller)->add_method(
        _format => sub {
            { format => $_[1]->$name, mode => $options{mode} }
        }
    );
}

my $do_authentication;
sub require_authentication { $do_authentication = $_[1] }

sub net_api_method {
    my $caller  = shift;
    my $name    = shift;
    my %options = @_;

    my $class = Moose::Meta::Class->initialize($caller);

    for (qw/api_base_url format/) {
        if ( !$caller->meta->has_attribute($_) ) {
            croak "attribut $_ is missing";
        }
    }

    if ( !$class->meta->has_attribute('useragent') ) {
        _init_useragent($class);
    }

    my $code;
    if ( !$options{code} ) {
        $code = sub {
            my $self = shift;
            my %args = @_;

            if (!$self->meta->does_role('MooseX::Net::API::Roles::Deserialize')){
                MooseX::Net::API::Roles::Deserialize->meta->apply($self);
            }
            if (!$self->meta->does_role('MooseX::Net::API::Roles::Serialize')){
                MooseX::Net::API::Roles::Serialize->meta->apply($self);
            }

            # XXX apply to all
            if ( $options{path} =~ /\$(\w+)/ ) {
                my $match = $1;
                if ( my $value = delete $args{$match} ) {
                    $options{path} =~ s/\$$match/$value/;
                }
            }
            my $url = $self->api_base_url . $options{path};

            my $format = $caller->_format($self);
            $url .= "." . $self->format if ( $format->{mode} eq 'append' );

            my $req;
            my $uri = URI->new($url);

            my $method = $options{method};
            if ( $method =~ /^(?:GET|DELETE)$/ ) {
                $uri->query_form(%args);
                $req = HTTP::Request->new( $method => $uri );
            }
            elsif ( $method =~ /^(?:POST|PUT)$/ ) {
                $req = HTTP::Request->new( $method => $uri );

                # XXX handle POST and PUT for params
            }
            else {
                croak "$method is not defined";
            }

            # XXX check presence content type
            $req->header( 'Content-Type' =>
                    $list_content_type->{ $format->{format} }->{header} )
                if $format->{mode} eq 'content-type';

            my $res = $self->useragent->request($req);
            my $content_type = $res->headers->{"content-type"};

            if ( $res->is_success ) {
                if ( my $type = $reverse_content_type->{$content_type} ) {
                    my $method = '_from_' . $type;
                    return $self->$method( $res->content );
                }else{
                }
            }
            else {
                return MooseX::Net::API::Error->new(
                    code  => $res->code,
                    error => $res->content
                );
            }
        };
    }
    else {
        $code = delete $options{code};
    }

    $class->add_method(
        $name,
        MooseX::Net::API::Meta::Method->new(
            name         => $name,
            package_name => $caller,
            body         => $code,
            %options,
        ),
    );
}

sub _request {
    my $class = shift;
}

sub _init_useragent {
    my $class = shift;
    try {
        require LWP::UserAgent;
    }
    catch {
        croak "no useragent defined and LWP::UserAgent is not available";
    };
    my $ua = LWP::UserAgent->new();
    $ua->env_proxy;

    $class->add_attribute(
        'useragent',
        is      => 'rw',
        isa     => 'LWP::UserAgent',
        lazy    => 1,
        default => sub {$ua},
    );
}

package MooseX::Net::API::Meta::Method;

use Moose;
extends 'Moose::Meta::Method';
use Carp;

has description => ( is => 'ro', isa => 'Str' );
has path        => ( is => 'ro', isa => 'Str', required => 1 );
has method      => ( is => 'ro', isa => 'Str', required => 1 );
has params      => ( is => 'ro', isa => 'ArrayRef', required => 0 );
has required    => ( is => 'ro', isa => 'ArrayRef', required => 0 );

sub new {
    my $class = shift;
    my %args  = @_;
    $class->SUPER::wrap(@_);

}

1;

__END__

=head1 NAME

MooseX::Net::API - Easily create client for net API

=head1 SYNOPSIS

  package My::Net::API;
  use Moose;
  use MooseX::Net::API;

  net_api_method => (
    description => 'this get foo',
    method      => 'GET',
    path        => '/foo/',
    params      => [qw/user group/],
    required    => [qw/user/],
  );

=head1 DESCRIPTION

MooseX::Net::API is module to help to easily create a client to a web
 API

=head2 METHODS

=over 4

=item B<net_api_method>

=over 2

=item B<description>

description of the method (this is a documentation)

=item B<method>

HTTP method (GET, POST, PUT, DELETE)

=item B<path>

path of the query

=item B<params>

list of params

=item B<required>

list of required params

=back

=back

=head1 AUTHOR

franck cuny E<lt>franck.cuny@rtgi.frE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
