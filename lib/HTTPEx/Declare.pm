package HTTPEx::Declare;
use strict;
use warnings;
our $VERSION = '0.01';
use HTTP::Engine;
use Sub::Exporter -setup => {
    exports => [qw/middlewares interface run/],
    groups  => { default => [':all'] }
};

my ($module, $args);

sub middlewares (@)  { HTTP::Engine->load_middlewares(@_) }

sub interface   ($$) { ( $module, $args ) = @_ }

sub run(&;@) {
    unless ($module && $args) {
        require Carp;
        Carp::croak 'please define interface previously';
    }
    my $request_handler = shift;
    my $engine          = HTTP::Engine->new(
        interface => {
            module          => $module,
            args            => $args,
            request_handler => $request_handler,
        },
    );
    undef $module;
    undef $args;
    $engine->run(@_);
}

1;
__END__

=for stopwords Tokuhiro Matsuno

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

Tokuhiro Matsuno

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
