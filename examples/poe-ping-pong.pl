use strict;
use warnings;
use lib 'lib';
use HTTPEx::Declare;


my $count;
my $flag;
sub init {
    $count = 0;
    $flag  = '1978';
}
sub next_uri {
    my $req = shift;
    my $uri = $req->uri->clone;
    $uri->port( $flag eq '1978' ? '1977' : '1978' );
    $uri;
}
sub bad_request {
    my $c = shift;
    init;
    my $uri = next_uri($c->req);
    $c->res->body(sprintf qq{Bad Request!: <a href="%s">%s</a>}, $uri, $uri);
}

sub handler {
    my $c = shift;
    my $port = $flag;
    return bad_request($c) if $flag eq $c->req->uri->port;

    $flag = $c->req->uri->port;
    $count++;

    my $uri = next_uri($c->req);
    $c->res->body(sprintf qq{%s: %s<br /><a href="%s">%s</a>\n}, $flag, $count, $uri, $uri);
    print STDERR "ping-pong: $flag, $count\n";
}

interface POE => { port => 1977 };
run \&handler;

interface POE => { port => 1978 };
run \&handler;

init;
print "ping-pong start: \n";
POE::Kernel->run;
