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
use Util::ConfigUtil;

# Test reading an INI file
subtest 'Test reading an INI file' => sub {
  plan tests => 4;
  my $ini_reader = Util::ConfigUtil->new();
  $ini_reader->read_ini_file();

  is($ini_reader->get_value('TEST_SECTION', 'TEST_STRING_VALUE'), 'Hello world!', 'Value1 is correct');
  is($ini_reader->get_value('TEST_SECTION', 'TEST_NUMERIC_VALUE'), 42, 'Value2 is correct');

  is(Util::ConfigUtil->get('TEST_SECTION', 'TEST_STRING_VALUE'), 'Hello world!', 'Value1 is correct');
  is(Util::ConfigUtil->get('TEST_SECTION', 'TEST_NUMERIC_VALUE'), 42, 'Value2 is correct');

};

# Test retrieving non-existing values
subtest 'Test retrieving non-existing values' => sub {
  plan tests => 4;
  my $ini_reader = Util::ConfigUtil->new();
  $ini_reader->read_ini_file();

  is($ini_reader->get_value('Section1', 'NonExistingKey'), undef, 'Non-existing key returns undef');
  is($ini_reader->get_value('NonExistingSection', 'Key1'), undef, 'Non-existing section returns undef');

  is(Util::ConfigUtil->get('Section1', 'NonExistingKey'), undef, 'Non-existing key returns undef');
  is(Util::ConfigUtil->get('NonExistingSection', 'Key1'), undef, 'Non-existing section returns undef');
};

done_testing();

