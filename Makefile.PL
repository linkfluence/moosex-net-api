use inc::Module::Install;
name 'MooseX-Net-API';
all_from 'lib/MooseX/Net/API.pm';

requires 'Carp';
requires 'Moose';
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
build_requires 'Test::Exception';
use_test_base;
auto_include;
WriteAll;
