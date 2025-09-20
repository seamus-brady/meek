# Copyright (c) 2023. seamus@corvideon.ie
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER in an action of contract, tort or otherwise, arising from,
# out of or in connection with the Software or the use or other dealings in
# the Software.

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Test::More;
use Tools::WebPageContents;

subtest 'Tools::WebPageContents' => sub {
  plan tests => 3;
  my $web_contents_tool =  Tools::WebPageContents->new();
  isa_ok($web_contents_tool, 'Tools::WebPageContents', 'Object is an instance of Tools::WebPageContents');
  ok($web_contents_tool->get_web_contents('https://duckduckgo.com'), 'Tools::WebPageContents worked OK');
  ok($web_contents_tool->get_web_contents('https://%$£^%$£%$%$'), 'Tools::WebPageContents worked OK with a dodgy URL');
};

done_testing();
