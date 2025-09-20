#  Copyright (c) 2023. seamus@corvideon.ie
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

package Tools::Summariser::Summariser;

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Moose;
use MooseX::ClassAttribute;
use Math::Expression::Evaluator;
use namespace::autoclean;
use Try::Tiny;
use Path::Class;
use Util::ConfigUtil;
use LLM::OpenAICompletion;

sub summarise($self, $input) {
  my $error_response = Util::ConfigUtil->get('SUMMARISER_TOOL', 'SUMMARISE_ERROR_MESSAGE');
  try {
    # load the prompt
    my $script_path = File::Spec->rel2abs(__FILE__);
    my ($volume, $script_directory, $file) = File::Spec->splitpath($script_path);
    my $prompt_file_path = File::Spec->catfile($script_directory, "prompt.txt");
    my $prompt_template = file($prompt_file_path)->slurp;

    # replace the input
    my $prompt = $prompt_template;
    $prompt =~ s/\$\{input\}/$input/g;

    # call LLM
    my $response = $self->_complete_prompt($prompt);
    return $response;
  }
  catch {
    my $e = $_;
    # say $e;
    return $error_response;
  };
}

sub _complete_prompt($self, $prompt) {
  my $llm = LLM::OpenAICompletion->new();
  return $llm->completion_response($prompt);
}

__PACKAGE__->meta->make_immutable;

1;

1;