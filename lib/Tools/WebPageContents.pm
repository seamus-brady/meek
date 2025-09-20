#  Copyright (c) 2023. seamus@corvideon.ie
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  Copyright (c) 2023. seamus@corvideon.ie
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
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

package Tools::WebPageContents;

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
use Try::Tiny;
use LWP::Simple;
use HTML::HeadParser;
use HTML::TreeBuilder;
use Util::ConfigUtil;

sub get_web_contents($class, $input) {
  my $error_response = Util::ConfigUtil->get('WEB_PAGE_CONTENTS_TOOL', 'GET_PAGE_ERROR_MESSAGE');
  try {
    my $page_title = _get_page_title($input);
    my $page_contents = _get_body_text($input);
    my $web_contents = $page_title.' '.$page_contents;
    say ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>".$web_contents;
    if(!defined $web_contents){
      die "No web contents returned in call to $input in Tools::WebPageContents.";
    } else {
      return $web_contents;
    }
  }
  catch {
    my $e = $_;
    # say $e;
    return $error_response;
  };
}

sub _get_page_title($url) {
  my $content = get($url);
  if (defined $content) {
    my $parser = HTML::HeadParser->new();
    $parser->parse($content);
    my $title = $parser->header('title');
    return $title;
  } else {
    return "";
  }
}

sub _get_body_text($url) {
  my $content = get($url);
  if (defined $content) {
    my $tree = HTML::TreeBuilder->new();
    $tree->parse($content);
    my $body = $tree->find('body');
    my $text = '';
    if (defined $body) {
      $text = _extract_text($body);
    }
    $tree = $tree->delete();
    return $text;
  } else {
    return "";
  }
}

sub _extract_text {
  my ($element) = @_;
  my $text = '';
  foreach my $content ($element->content_list) {
    if (ref($content)) {
      my $tag_name = $content->tag();
      if ($tag_name eq 'script' || $tag_name eq 'style') {
        next;
      }
      my $subtext = _extract_text($content);
      $text .= ' ' if $text && $subtext;
      $text .= $subtext;
    } else {
      $text .= ' ' if $text && $content;
      $text .= $content;
    }
  }
  return $text;
}

__PACKAGE__->meta->make_immutable;

1;