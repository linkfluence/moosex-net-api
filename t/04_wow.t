use strict;
use warnings;
use lib ('t/lib');

use Test::More;
use WoWArmory;

my ( $obj, $res );

ok $obj = WoWArmory->new();

ok $res = $obj->character( r => 'Elune', n => 'Aarnn' );
is $res->{characterInfo}->{character}->{name}, 'Aarnn',
    '... got valid player name';
done_testing();

