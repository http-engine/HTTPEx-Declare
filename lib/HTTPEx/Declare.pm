package HTTPEx::Declare;

use strict;
use warnings;
our $VERSION = '0.01';

use Sub::Name 'subname';
use Sub::Exporter;

use HTTP::Engine;

my $interface;

my %exports = (
    middlewares => sub {
        subname 'HTTPEx::Declare::middlewares' => sub (@) {
            HTTP::Engine->load_middlewares( @_ );
        }
    },
    interface => sub {
        subname 'HTTPEx::Declare::interface' => sub ($$) {
            $interface = {
                module => shift,
                args   => shift,
            };
        }
    },
    run => sub {
        subname 'HTTPEx::Declare::run' => sub (&;@) {
            unless ($interface) {
                require Carp;
                Carp::croak 'please define interface previously';
            }
            my $request_handler = shift;
            my $engine = HTTP::Engine->new(
                interface => {
                    module          => $interface->{module},
                    args            => $interface->{args},
                    request_handler => $request_handler,
                },
            );
            undef $interface;
            $engine->run(@_);
        }
    },
);

Sub::Exporter::setup_exporter({
    exports => \%exports,
    groups  => { default => [':all'] }
});

1;
__END__

=head1 NAME

HTTPEx::Declare - Declarative HTTP::Engine

=head1 SYNOPSIS

  use HTTPEx::Declare;

  interface ServerSimple => {
      host => 'localhost',
      port => 1978,
  };

  use Data::Dumper;
  run {
      my $c = shift;
      $c->res->body( Dumper($c->req) );
  };

  # middlewares preload
  middlewares 'DebugScreen', 'ModuleReload';

=head1 DESCRIPTION

HTTPEx::Declare is DSL to use L<HTTP::Engine> easily. 

=head1 AUTHOR

Kazuhiro Osawa E<lt>ko@yappo.ne.jpE<gt>

=head1 SEE ALSO

L<HTTP::Engine>

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/HTTPEx-Declare/trunk HTTPEx-Declare

HTTPEx::Declare's Subversion repository is hosted at L<http://coderepos.org/share/>.
patches and collaborators are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
