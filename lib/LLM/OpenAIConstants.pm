package LLM::OpenAIConstants;

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;

# imports
use Moose;
use MooseX::ClassAttribute;


class_has 'OPENAI_COMPLETION_URL' => (
  is       => 'ro',
  isa      => 'Str',
  required => 0,
  default  => 'https://api.openai.com/v1/completions'
);

class_has 'OPENAI_COMPLETION_MODEL' => (
  is       => 'ro',
  isa      => 'Str',
  required => 0,
  default  => 'text-davinci-003'
);

class_has 'OPENAI_COMPLETION_MAX_TOKENS' => (
  is       => 'ro',
  isa      => 'Num',
  required => 0,
  default  => 256
);

class_has 'OPENAI_COMPLETION_TEMP' => (
  is       => 'ro',
  isa      => 'Num',
  required => 0,
  default  => 0.7
);


__PACKAGE__->meta->make_immutable;
1;