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
use LLM::OpenAICompletion;

subtest 'LLM::OpenAICompletion Class Tests' => sub {
  plan tests => 3;
  my $llm = LLM::OpenAICompletion->new();
  isa_ok($llm, 'LLM::OpenAICompletion', 'Object is an instance of LLM::OpenAICompletion');
  ok($llm->api_key, 'API Key attribute is not null');
  ok($llm->completion_response('hello!'), 'LLM::OpenAICompletion completion OK');
};

done_testing();

