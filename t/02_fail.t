use strict;
use warnings;
use Test::More;
use Test::Exception;
use lib ('t/lib');

dies_ok { require FakeAPIFail }
"... can't declare a required param that have not been declared";

dies_ok {require FakeAPIFail2 }
"... can't declare a required param that have not been declared";

done_testing;
