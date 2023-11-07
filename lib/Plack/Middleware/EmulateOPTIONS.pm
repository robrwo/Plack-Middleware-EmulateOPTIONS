package Plack::Middleware::EmulateOPTIONS;

# ABSTRACT: handle OPTIONS requests as HEAD

use v5.14;

use warnings;

use parent 'Plack::Middleware';

use Plack::Util;
use Plack::Util::Accessor qw/ filter callback /;
use HTTP::Status ();

our $VERSION = 'v0.3.3';

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

If the requests succeed, then it will add C<Allow> headers using the L</callback> method.

If the requests do not succeed, then the responses are passed unchanged.

You can add the L</filter> attribute to determine whether it will proxy C<HEAD> requests.

=attr filter

This is an optional code reference for a function that takes the L<PSGI> environment and returns true or false as to
whether the request should be proxied.

For instance, if you have CORS handler for a specific path, you might return false for those requests. Alternatively,
you might use the L</callback>.

If you need a different value for the C<Allow> headers, then you should handle the requests separately.

=attr callback

This is an optional code reference that modifies the response headers.

By default, it sets the C<Allow> header to "GET, HEAD, OPTIONS".

If you override this, then you will need to manually set the header yourself, for example:

    use Plack::Util;

    enable "EmulateOPTIONS",
      callback => sub {
          my $res = shift;
          my $env = shift;

          my @allowed = qw( GET HEAD OPTIONS );
          if ( $env->{PATH_INFO} =~ m[^/api/] ) {
             push @allowed, qw( POST PUT DELETE );
          }

          Plack::Util::header_set( $res->[1], 'allow', join(", ", @allowed) );

        };

This was added in v0.2.0.

=cut

sub prepare_app {
    my ($self) = @_;

    unless (defined $self->callback) {

        $self->callback( sub {
            my ($res) = @_;
            Plack::Util::header_set( $res->[1], 'allow', "GET, HEAD, OPTIONS" );
        });

    }
}

sub call {
    my ( $self, $env ) = @_;

    my $filter = $self->filter;
    my $callback = $self->callback;

    if ( $env->{REQUEST_METHOD} eq "OPTIONS" && ( !$filter || $filter->($env) ) ) {

        my $res = $self->app->( { %$env, REQUEST_METHOD => "HEAD" } );

        return Plack::Util::response_cb(
            $res,
            sub {
                my ($res) = @_;
                if ( HTTP::Status::is_success($res->[0]) ) {
                    $callback->( $res, $env );
                }
            }
        );

    }
    else {

        return $self->app->($env);

    }
}

=head1 SUPPORT FOR OLDER PERL VERSIONS

Since v0.3.0, the this module requires Perl v5.14 or later.

If you need this module on Perl v5.10, please use one of the v0.2.x
versions of this module.  Significant bug or security fixes may be
backported to those versions.

=cut

1;
