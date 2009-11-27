package WoWArmory;
use Moose;
use MooseX::Net::API;
use LWP::UserAgent;

net_api_declare wowarmory => (
    base_url    => 'http://eu.wowarmory.com/',
    format      => 'xml',
    format_mode => 'append',
    useragent   => sub {
        my $ua = LWP::UserAgent->new;
        $ua->agent(
            "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1"
        );
        return $ua;
    },
);

net_api_method character => (
    method   => 'GET',
    path     => '/character-sheet',
    params   => [qw/r n/],
    required => [qw/r n/],
);
1;
