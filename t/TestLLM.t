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

use LLM;

# Test the LLM class
subtest 'LLM Class Tests' => sub {
  plan tests => 3;
  my $llm = LLM->new();
  isa_ok($llm, 'LLM', 'Object is an instance of LLM');
  ok($llm->api_key, 'API Key attribute is not null');
  ok($llm->completion_response('hello!'), 'LLM completion OK');
};

done_testing();

