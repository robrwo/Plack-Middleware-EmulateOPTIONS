package Plack::Middleware::EmulateOPTIONS;

# ABSTRACT: handle OPTIONS requests as HEAD

use v5.10;

use strict;
use warnings;

use parent 'Plack::Middleware';

use Plack::Util;
use Plack::Util::Accessor qw/ filter /;
use HTTP::Status          qw/ is_success /;

our $VERSION = 'v0.1.2';

=head1 SYNOPSIS

  use Plack::Builder;

  builder {

    enable "EmulateOPTIONS",
      filter => sub {
          my $env = shift;
          return $env->{PATH_INFO} =~ m[^/static/];
        };

    ...

  };

=head1 DESCRIPTION

This middleware adds support for handling HTTP C<OPTIONS> requests, by internally rewriting them as C<HEAD> requests.

If the requests succeed, then it will add C<Allow> headers set to C<GET, HEAD, OPTIONS> to the responses.

If the requests do not succeed, then the responses are passed unchanged.

You can add the L</filter> attribute to determine whether it will proxy C<HEAD> requests.

=attr filter

This is an optional code reference for a function that takes the L<PSGI> environment and returns true or false as to
whether the request should be proxied.

For instance, if you have CORS handler for a specific path, you might return false for those requests.

If you need a different value for the C<Allow> headers, then you should handle the requests separately.

=cut

sub call {
    my ( $self, $env ) = @_;

    my $filter = $self->filter;

    if ( $env->{REQUEST_METHOD} eq "OPTIONS" && ( !$filter || $filter->($env) ) ) {

        my $res = $self->app->( { %$env, REQUEST_METHOD => "HEAD" } );

        return Plack::Util::response_cb(
            $res,
            sub {
                my ($res) = @_;
                if ( is_success($res->[0]) ) {
                    Plack::Util::header_set( $res->[1], 'allow', "GET, HEAD, OPTIONS" );
                }
                return;
            }
        );

    }
    else {

        return $self->app->($env);

    }
}

=head1 SEE ALSO

L<Plack>

L<PSGI>

=cut

1;
