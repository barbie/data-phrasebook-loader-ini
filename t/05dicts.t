#!/usr/bin/perl -w
use strict;
use lib 't';
use vars qw( $class );

use Test::More 'no_plan';
use Data::Phrasebook;

my $file = 't/02dict.ini';

# load up the default dict
my $book = Data::Phrasebook->new(class  => 'Plain',
                                 loader => 'Ini',
                                 file   => 't/05dict.ini');
is($book->fetch('foo'), "I'm original foo.");

# now switch to the second one
$book->dict('ONE');
is($book->fetch('foo'), "I'm new foo.");
