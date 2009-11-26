package MooseX::Net::API::Error;

use Moose;

has code  => ( is => 'ro', isa => 'Str' );
has error => ( is => 'ro', isa => 'Str' );

1;
