use strict;
use warnings;
use lib '.';
use HTTP::Request;
use HTTPEx::Declare;
use Test::More tests => 1;

interface Test => {};
my $response = run {
    my $c = shift;
    $c->res->body('OK!');
} HTTP::Request->new( GET => 'http://localhost/' );

is $response->content, 'OK!';
