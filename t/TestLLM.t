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
use LLM::OpenAICompletion;

subtest 'LLM::OpenAICompletion Class Tests' => sub {
  plan tests => 3;
  my $llm = LLM::OpenAICompletion->new();
  isa_ok($llm, 'LLM::OpenAICompletion', 'Object is an instance of LLM::OpenAICompletion');
  ok($llm->api_key, 'API Key attribute is not null');
  ok($llm->completion_response('hello!'), 'LLM::OpenAICompletion completion OK');
};

done_testing();

