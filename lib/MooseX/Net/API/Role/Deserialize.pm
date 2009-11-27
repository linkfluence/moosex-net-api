package MooseX::Net::API::Role::Deserialize;

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
    $xml->XMLin( $_[1] );
}

1;
