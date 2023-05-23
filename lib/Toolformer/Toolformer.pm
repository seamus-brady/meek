#  Copyright (c) 2023. seamus@meek.ai, Corvideon Limited.
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
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

package Toolformer::Toolformer;
# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Moose;
use Path::Class;
use Try::Tiny;
use LLM::OpenAICompletion;
use Tools::Search::BingSearch;
use Tools::Calculator;
use Util::StringUtil;
use Util::ConfigUtil;

=head1 NAME

Toolformer::Toolformer - represents an LLM that that can use predefined tools.

=cut


#################################################################
##    tool functions and config
#################################################################

sub searchTool($input) {
  return Tools::Search::BingSearch->new()->search($input);
}

sub calcTool($input) {
  return Tools::Calculator->calculate($input);
}

sub tool_config {
  my $input = shift;
  my %tools = (
    'search'     => {
      'description' => qq(
      A search engine. useful for when you need to answer questions about current events.
      Input should be a search query.'),
      'execute'     => \&searchTool,
    },
    'calculator' => {
      'description' => qq(
      Useful for getting the result of a math expression.
      The input to this tool should be a valid mathematical expression that could be executed by a simple calculator.),
      'execute'     => \&calcTool,
    },
  );
  return %tools;
}

#################################################################
##    end tool functions and config
#################################################################

sub query($self, $question){
  # get the tools
  my %tools = tool_config();

  # load the prompt
  my $script_path = File::Spec->rel2abs(__FILE__);
  my ($volume, $script_directory, $file) = File::Spec->splitpath($script_path);
  my $prompt_file_path = File::Spec->catfile($script_directory, "prompt.txt");
  my $prompt_template = file($prompt_file_path)->slurp;

  # answer the question
  my $answer = $self->_answer_question($question, $prompt_template, %tools);
  return $answer;
}

sub _answer_question($self, $question, $prompt_template, %tools) {
  # Construct the prompt, replacing placeholders with question and tools information
  my $prompt = $prompt_template;
  $prompt =~ s/\$\{question\}/$question/g;
  $prompt =~ s/\$\{tools\}/join("\n", map {"$_: $tools{$_}->{'description'}"} keys %tools)/e;

  # Allow the model to iterate until a final answer is found or we go over MAX_ITERATIONS
  my $i = 0;
  my $max_iterations = Util::ConfigUtil->get('TOOLFORMER', 'MAX_ITERATIONS');
  while ($i < $max_iterations) {
    my $response = $self->_complete_prompt($prompt);

    # Add the response to the prompt
    $prompt .= $response;

    my ($action) = $response =~ /Action: (.*)/;
    if (defined $action) {
      # Execute the action specified by the model
      my ($actionInput) = $response =~ /Action Input: "?(.*)"?/;
      my $result = $tools{Util::StringUtil->trim($action)}->{'execute'}->($actionInput);
      $prompt .= "Observation: $result\n";
    }
    else {
      my ($finalAnswer) = $response =~ /Final Answer: (.*)/;
      return $finalAnswer;
    }
    $i++; # increment
  }
  # no final answer found!
  return Util::ConfigUtil->get('TOOLFORMER', 'NO_FINAL_ANSWER_ERROR');
}

sub _complete_prompt($self, $prompt) {
  my $llm = LLM::OpenAICompletion->new();
  return $llm->completion_response($prompt);
}

__PACKAGE__->meta->make_immutable;

1;