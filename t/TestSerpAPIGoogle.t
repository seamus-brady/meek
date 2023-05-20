#!/usr/bin/perl
#!/usr/bin/perl

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Test::More;
use Tools::GoogleSearch;

subtest 'Tools::GoogleSearch Class Tests' => sub {
  plan tests => 3;
  my $google = Tools::GoogleSearch->new();
  isa_ok($google, 'Tools::GoogleSearch', 'Object is an instance of Tools::SerpAPIGoogle');
  ok($google->api_key, 'API Key attribute is not null');
  ok($google->search('hello!'), 'Tools::SerpAPIGoogle search OK');
};

done_testing();