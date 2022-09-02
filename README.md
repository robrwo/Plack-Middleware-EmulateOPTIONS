# NAME

Plack::Middleware::EmulateOPTIONS - handle OPTIONS requests as HEAD

# VERSION

version v0.1.1

# SYNOPSIS

```perl
use Plack::Builder;

builder {

  enable "EmulateOPTIONS",
    filter => sub {
        my $env = shift;
        return $env->{PATH_INFO} =~ m[^/static/];
      };

  ...

};
```

# DESCRIPTION

This middleware adds support for handling HTTP `OPTIONS` requests, by internally rewriting them as `HEAD` requests.

If the requests succeed, then it will add `Allow` headers set to `GET, HEAD, OPTIONS` to the responses.

If the requests do not succeed, then the responses are passed unchanged.

You can add the ["filter"](#filter) attribute to determine whether it will proxy `HEAD` requests.

# ATTRIBUTES

## filter

This is an optional code reference for a function that takes the [PSGI](https://metacpan.org/pod/PSGI) environment and returns true or false as to
whether the request should be proxied.

For instance, if you have CORS handler for a specific path, you might return false for those requests.

If you need a different value for the `Allow` headers, then you should handle the requests separately.

# SEE ALSO

[Plack](https://metacpan.org/pod/Plack)

[PSGI](https://metacpan.org/pod/PSGI)

# SOURCE

The development version is on github at [https://github.com/robrwo/Plack-Middleware-EmulateOPTIONS](https://github.com/robrwo/Plack-Middleware-EmulateOPTIONS)
and may be cloned from [git://github.com/robrwo/Plack-Middleware-EmulateOPTIONS.git](git://github.com/robrwo/Plack-Middleware-EmulateOPTIONS.git)

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://github.com/robrwo/Plack-Middleware-EmulateOPTIONS/issues](https://github.com/robrwo/Plack-Middleware-EmulateOPTIONS/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Robert Rothenberg <rrwo@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2022 by Robert Rothenberg.

This is free software, licensed under:

```
The Artistic License 2.0 (GPL Compatible)
```
