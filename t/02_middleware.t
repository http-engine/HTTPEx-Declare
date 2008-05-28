use strict;
use warnings;
use lib '.';
use HTTPEx::Declare;
use Test::More tests => 2;

middlewares '+t::DummyMiddlewareWrap';

interface Test => {};
my $response = run {
    my $c = shift;
    $c->res->body('OK!');
} HTTP::Request->new( GET => 'http://localhost/' );

our $wrap;
is $main::wrap, 'ok';
is $response->content, 'OK!';
