use inc::Module::Install;
name 'MooseX-Net-API';
all_from 'lib/MooseX/Net/API.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
