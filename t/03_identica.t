use strict;
use warnings;
use lib ('t/lib');

use Test::More;
use Identica;

BEGIN {
    plan skip_all =>
        'set $ENV{IDENTICA_USER} and $ENV{IDENTICA_PWD} for this test'
        unless $ENV{IDENTICA_USER} && $ENV{IDENTICA_PWD};
}

my ($obj, $res);

ok $obj = Identica->new(
    api_username => $ENV{IDENTICA_USER},
    api_password => $ENV{IDENTICA_PWD}
);

ok $res = $obj->public_timeline;
ok $res = $obj->update_status( status => 'this is a test' );

done_testing();
