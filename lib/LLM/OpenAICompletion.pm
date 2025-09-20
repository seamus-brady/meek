# Copyright (c) 2023. seamus@corvideon.ie
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

package LLM::OpenAICompletion;

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Moose;
use namespace::autoclean;
use LWP::Simple;
use JSON;
use Try::Tiny;
use MooseX::ClassAttribute;
use Util::ConfigUtil;

=head1 NAME

LLM - Represents a Large Language Model.

=cut

has 'api_key' => (
  is       => 'rw',
  isa      => 'Str',
  required => 0
);

sub BUILD {
  my $self = shift;
  if (!$self->api_key()) {
    $self->api_key($ENV{'OPENAI_API_KEY'});
  }
}

=head2 completion_response

Takes a prompt and returns a completion response.

=cut

sub completion_response($self, $prompt) {
  # get api key
  my $api_key = $self->api_key;

  # set up htto request
  my $url = Util::ConfigUtil->get('OPENAI', 'OPENAI_COMPLETION_URL');
  my $ua = LWP::UserAgent->new;
  my $headers = $self->_get_headers($api_key);
  my $data = $self->_get_request_content($prompt);
  my $request = HTTP::Request->new('POST', $url, $headers, encode_json($data));

  # call api
  my $response = $ua->request($request);

  if ($response->is_success) {
    my $decoded_response = decode_json($response->decoded_content);
    my $text = $decoded_response->{'choices'}[0]{'text'};
    print "\x1b[91m$prompt\x1b[0m\n";
    print "\x1b[92m$text\x1b[0m\n";
    return $text;
  }
  else {
    return "Sorry there was a problem with your request. Please try again.";
  }
}

sub _get_headers($self, $api_key) {
  return [
    "Content-Type"  => "application/json",
    "Authorization" => "Bearer $api_key",
  ];
}

sub _get_request_content($self, $prompt) {
  return {
    model       => Util::ConfigUtil->get('OPENAI', 'OPENAI_COMPLETION_MODEL'),
    prompt      => $prompt,
    max_tokens  => Util::ConfigUtil->get('OPENAI', 'OPENAI_COMPLETION_MAX_TOKENS'),
    temperature => Util::ConfigUtil->get('OPENAI', 'OPENAI_COMPLETION_TEMP'),
    stream      => JSON::false,
    stop        => "Observation:",
  };
}

__PACKAGE__->meta->make_immutable;

1;