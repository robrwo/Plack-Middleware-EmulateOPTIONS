package Plack::Middleware::EmulateOPTIONS;

# ABSTRACT: handle OPTIONS requests as HEAD

use v5.8;

use strict;
use warnings;

use parent 'Plack::Middleware';

use Plack::Util;
use Plack::Util::Accessor qw/ filter /;
use HTTP::Status          qw/ is_success /;
use Try::Tiny;

our $VERSION = 'v0.1.0';

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

1;
