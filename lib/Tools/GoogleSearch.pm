package Tools::GoogleSearch;

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

=head1 NAME

Tools::GoogleSearch - represents a tool that can search Google.

=cut


has 'api_key' => (
  is       => 'rw',
  isa      => 'Str',
  required => 0
);

sub BUILD {
  my $self = shift;
  if(!$self->api_key()){
    $self->api_key($ENV{'SERPAPI_API_KEY'});
  }
}

sub search($self, $question) {
  my $error_response = "Sorry there was a problem with your search. Please try again.";
  try {
    my $url = $self->_get_url($question);
    my $response = LWP::Simple->get($url);
    if(defined $response){
      my $json = decode_json($response);
      my $answer = $json->{'answer_box'}->{'answer'}
        || $json->{'answer_box'}->{'snippet'}
        || $json->{'organic_results'}->[0]->{'snippet'};
      return $answer;
    } else {
      return $error_response;
    }
  } catch {
    return $error_response;
  };
}

sub _get_url($self, $question){
  return "https://serpapi.com/search?api_key=$self->api_key&q=$question";
}

__PACKAGE__->meta->make_immutable;
1;