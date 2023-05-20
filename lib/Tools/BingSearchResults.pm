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

package Tools::BingSearchResults;
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
use JSON;

has '_type' => (
  is => 'ro',
  isa => 'Str',
);

has 'queryContext' => (
  is => 'ro',
  isa => 'HashRef',
);

has 'webPages' => (
  is => 'ro',
  isa => 'HashRef',
);

has 'relatedSearches' => (
  is => 'ro',
  isa => 'HashRef',
);

has 'rankingResponse' => (
  is => 'ro',
  isa => 'HashRef',
);

sub get_json {
  my $class = shift;
  my $json_str = shift;

  my $data = decode_json($json_str);

  return $class->new(
    _type => $data->{_type},
    queryContext => $data->{queryContext},
    webPages => $data->{webPages},
    relatedSearches => $data->{relatedSearches},
    rankingResponse => $data->{rankingResponse},
  );
}

__PACKAGE__->meta->make_immutable;

1;


1;