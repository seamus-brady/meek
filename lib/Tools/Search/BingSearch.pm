# Copyright (c) 2023. seamus@meek.ai, Corvideon Limited.
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  Copyright (c) 2023. seamus@meek.ai, Corvideon Limited.
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

package Tools::Search::BingSearch;

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
use namespace::autoclean;
use LWP::Simple;
use JSON;
use Try::Tiny;
use Tools::Search::BingSearchResults;
use Util::ConfigUtil;

=head1 NAME

Tools::BingSearch - represents a tool that can search Bing.

=cut

has 'api_key' => (
  is       => 'rw',
  isa      => 'Str',
  required => 0
);

sub BUILD {
  my $self = shift;
  if (!$self->api_key()) {
    $self->api_key($ENV{'BING_SEARCH_KEY'});
  }
}

sub search($self, $question) {
  my $error_response = Util::ConfigUtil->get('BING_SEARCH_TOOL', 'NO_RESULTS_MESSAGE');
  try {
    my $ua = LWP::UserAgent->new;
    my $request_data = $self->_get_request($question);
    my $response = $ua->request($request_data);
    my $search_results = Tools::Search::BingSearchResults->get_json($response->content);
    return $self->_load_snippets($search_results);
  }
  catch {
    # warn "$_";
    return $error_response;
  };
}

sub _load_snippets($self, $search_results){
  my $snippet_count = Util::ConfigUtil->get('BING_SEARCH_TOOL', 'NUMBER_SNIPPETS_TO_LOAD');
  my $snippet_buffer = "";
  for my $i (0..$snippet_count) {
    try {
      my $snippet = $search_results->{webPages}->{value}[$i]->{snippet};
      if(defined $snippet){
        $snippet_buffer .= " ".$snippet." ";
      }
    } catch { warn "$_" }
  }
  return $snippet_buffer;
}

sub _get_url($self, $term) {
  my $uri = Util::ConfigUtil->get('BING_SEARCH_TOOL', 'URI');
  my $path = Util::ConfigUtil->get('BING_SEARCH_TOOL', 'PATH');
  $uri = $uri . $path . "?q=" . URI::Escape::uri_escape($term);
  return $uri;
}

sub _get_request($self, $question) {
  my $uri = $self->_get_url($question);
  my $request = HTTP::Request->new(GET => $uri);
  my $accessKey = $self->api_key;
  $request->header('Ocp-Apim-Subscription-Key' => $accessKey);
  return $request;
}

__PACKAGE__->meta->make_immutable;

1;