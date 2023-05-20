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

package Tools::BingSearchConstants;

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;

# imports
use Moose;
use MooseX::ClassAttribute;

class_has 'URI' => (
  is       => 'ro',
  isa      => 'Str',
  required => 0,
  default  => 'https://api.bing.microsoft.com'
);

class_has 'PATH' => (
  is       => 'ro',
  isa      => 'Str',
  required => 0,
  default  => '/v7.0/search'
);


__PACKAGE__->meta->make_immutable;
1;