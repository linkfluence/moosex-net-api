package MooseX::Net::API::Roles::Serialize;

use Moose::Role;
use JSON::XS;
use YAML::Syck;
use XML::Simple;

sub _to_json {
    return encode_json( $_[1] );
}

sub _to_yaml {
    return Load $_[1];
}

sub _to_xml {
    my $xml = XML::Simple->new( ForceArray => 0 );
    $xml->XMLin("$_[0]");
}

1;
