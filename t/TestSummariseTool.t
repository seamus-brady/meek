# Copyright (c) 2023. seamus@meek.ai, Corvideon Limited.
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

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Test::More;
use Tools::Summariser::Summariser

subtest 'Tools::Summariser::Summariser' => sub {
  plan tests => 2;
  my $summariser = Tools::Summariser::Summariser->new();
  isa_ok($summariser, 'Tools::Summariser::Summariser', 'Object is an instance of Tools::Summariser::Summariser');
  ok($summariser->summarise(qq(The 40-meter ham band, allocated for amateur radio use,
  typically refers to the frequency range between 7.000 and 7.200 MHz.
  This frequency range is measured in megahertz (MHz), not kilohertz (kHz).)), 'Tools::Summariser::Summariser summarised OK');
};

done_testing();