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

package Tools::CurrentDateTime;
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
use DateTime;
use namespace::autoclean;
use Try::Tiny;
use Util::ConfigUtil;

sub current_time($class) {
  my $error_response = Util::ConfigUtil->get('CURRENT_TIME_TOOL', 'TIME_ERROR_MESSAGE');
  try {
    # Get the current date and time with the time zone
    my $dt = DateTime->now( time_zone => 'local');
    my $formatted_datetime = $dt->strftime('%Y-%m-%d %H:%M:%S %Z');
    return "Current time with time zone: $formatted_datetime\n";
  }
  catch {
    my $e = $_;
    say $e;
    return $error_response;
  };
}

__PACKAGE__->meta->make_immutable;

1;