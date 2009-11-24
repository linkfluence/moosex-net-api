package MooseX::Net::API::Test;

use Moose::Exporter;

Moose::Exporter->setup_import_methods( with_caller => [qw/test_api_method/] );

sub test_api_method {
    my $caller  = shift;
    my $name    = shift;
    my %options = @_;
}

1;
