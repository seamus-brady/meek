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

package Util::ConfigUtil;

# pragmas
use strict;
use Modern::Perl '2023';
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);
no feature qw(indirect);

# imports
use Moose;
use FindBin qw($RealBin);
use Config::Tiny;
use MooseX::ClassAttribute;
use Scalar::Util qw(looks_like_number);

class_has 'CONFIG_FILE_NAME' => (
  is       => 'ro',
  isa      => 'Str',
  required => 0,
  default  => 'meek.ini'
);

has 'config' => (
  is       => 'rw',
  isa      => 'Config::Tiny',
  required => 0,
);


sub get($class, $section, $key) {
  my $config_util = Util::ConfigUtil->new();
  $config_util->read_ini_file();
  my $config_value = $config_util->get_value($section, $key);
  if (looks_like_number($config_value)) {
    # coerce into a number
    $config_value += 0;
    return $config_value;
  }
  else {
    return $config_value;
  };
}

sub read_ini_file($self) {
  my $config_dir = $self->_search_for_config_directory();
  my $config_file = Util::ConfigUtil->CONFIG_FILE_NAME;
  my $config_path = "$config_dir/$config_file";
  $self->config(Config::Tiny->read($config_path));
}

sub get_value($self, $section, $key) {
  return $self->config->{$section}->{$key};
}

sub _search_for_config_directory($self) {
  my $current_dir = $RealBin;
  my $folder_name = 'config';
  while ($current_dir ne '/') {
    my $folder_path = "$current_dir/$folder_name";
    if (-d $folder_path) {
      return $folder_path;
    }
    $current_dir = substr($current_dir, 0, rindex($current_dir, '/'));
  }
  die "Could not find Meek Config file!";
}

__PACKAGE__->meta->make_immutable;

1;


