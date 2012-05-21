package App::ttyrecpp;

=head1 NAME

App::ttyrecpp - ttyrec++

=head1 SYNOPSIS

  $ ttyrec++

  .. do things in your shell ..

  $ exit
  Creating log ttyrec.12345.json

or record the output of a particular program:

  $ ttyrec++ -- top

=head1 DESCRIPTION

Kinda like C<ttyrec> or C<typescript>, C<ttyrec++> is a terminal recording program.  It captures both the input and output of the slave TTY and writes out a JSON log file that's suitable for replaying in a web browser.

=cut

use strict;
use warnings;

our $VERSION = 0.01;

=head1 DEVELOPMENT

This module is being developed via a git repository publicly avaiable at http://github.com/ewaters/ttyrec-plusplus.  I encourage anyone who is interested to fork my code and contribute bug fixes or new features, or just have fun and be creative.

=head1 COPYRIGHT

Copyright (c) 2012 Eric Waters and Shutterstock Images (http://shutterstock.com).  All rights reserved.  This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

=head1 AUTHOR

Eric Waters <ewaters@gmail.com>

=cut

1;
