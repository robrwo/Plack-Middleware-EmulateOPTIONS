# This file is generated by Dist::Zilla::Plugin::CPANFile v6.025
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "HTTP::Status" => "0";
requires "Plack::Middleware" => "0";
requires "parent" => "0";
requires "perl" => "v5.10.0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "HTTP::Request::Common" => "6.21";
  requires "Module::Metadata" => "0";
  requires "Plack::Builder" => "0";
  requires "Plack::Middleware::ContentLength" => "0";
  requires "Plack::Middleware::Static" => "0";
  requires "Plack::Response" => "0";
  requires "Plack::Test" => "0";
  requires "Test::Differences" => "0";
  requires "Test::More" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::EOF" => "0";
  requires "Test::EOL" => "0";
  requires "Test::Kwalitee" => "1.21";
  requires "Test::MinimumVersion" => "0";
  requires "Test::More" => "0.88";
  requires "Test::NoTabs" => "0";
  requires "Test::Perl::Critic" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Pod::LinkCheck" => "0";
  requires "Test::Portability::Files" => "0";
  requires "Test::TrailingSpace" => "0.0203";
  requires "Test::Vars" => "0.015";
};
