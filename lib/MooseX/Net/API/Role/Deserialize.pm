package MooseX::Net::API::Roles::Deserialize;

use Moose::Role;
use JSON::XS;
use YAML::Syck;
use XML::Simple;

sub _from_json {
    return decode_json( $_[1] );
}

sub _from_yaml {
    return Dump $_[1];
}

sub _from_xml {
    my $xml = XML::Simple->new( ForceArray => 0 );
    $xml->XMLout( { data => $_[0] } );
}

1;
