use inc::Module::Install;
name 'HTTPEx-Declare';
all_from 'lib/HTTPEx/Declare.pm';

requires 'HTTP::Engine' => '0.0.8';
requires 'Sub::Name';
requires 'Sub::Exporter';
requires 'Carp';

build_requires 'Test::More';

use_test_base;
auto_include;
auto_install;
WriteAll;
