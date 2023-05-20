package LLM;

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


has 'api_key' => (
  is       => 'rw',
  isa      => 'Str',
  required => 0
);

sub BUILD {
  my $self = shift;
  if(!$self->api_key()){
    $self->api_key($ENV{'OPENAI_API_KEY'});
  }
}

sub completion_response($self, $prompt){
  my $url = "https://api.openai.com/v1/completions";
  my $api_key = $self->api_key;

  my $ua = LWP::UserAgent->new;
  my $headers = [
    "Content-Type" => "application/json",
    "Authorization" => "Bearer $api_key",
  ];

  my $data = {
    model => "text-davinci-003",
    prompt => $prompt,
    max_tokens => 256,
    temperature => 0.7,
    stream => JSON::false,
    stop => ["Observation:"],
  };
  my $request = HTTP::Request->new('POST', $url, $headers, encode_json($data));
  my $response = $ua->request($request);

  die "Error: " . $response->status_line unless $response->is_success;

  my $decoded_response = decode_json($response->decoded_content);

  my $text = $decoded_response->{'choices'}[0]{'text'};
  print "\x1b[91m$prompt\x1b[0m\n";
  print "\x1b[92m$text\x1b[0m\n";

  return $text;
}

__PACKAGE__->meta->make_immutable;

1;