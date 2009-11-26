use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib ('t/lib');
use FakeAPI;

my $obj = FakeAPI->new;
ok $obj, "... object created";
ok $obj->meta->has_attribute('useragent'),
    "... useragent attribute have been added";

ok my $method = $obj->meta->find_method_by_name('bar'),
    '... method bar have been created';

ok $method->meta->has_attribute('path'), '... method bar have attribute path';

throws_ok { $obj->baz } qr/bla is declared as required, but is not present/,
    "... check required params";

throws_ok {
    $obj->bar( bar => 1, );
}
qr/baz is declared as required, but is not present/,
    "... check required params are present";

throws_ok {
    $obj->bar( bar => 1, foo => 2, );
}
qr/foo is not declared as a param/, "... check declared params";

done_testing;
