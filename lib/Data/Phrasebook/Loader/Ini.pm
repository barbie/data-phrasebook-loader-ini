package Data::Phrasebook::Loader::Ini;
use strict;
use warnings FATAL => 'all';
use Carp qw( croak );
use base qw( Data::Phrasebook::Loader::Base Data::Phrasebook::Debug );
use Config::IniFiles;

our $VERSION = '0.05';

=head1 NAME

Data::Phrasebook::Loader::Ini - Absract your phrases with ini files.

=head1 SYNOPSIS

    use Data::Phrasebook;

    my $q = Data::Phrasebook->new(
        class  => 'Fnerk',
        loader => 'Ini',
        file   => 'phrases.ini',
    );

    $q->delimiters( qr{ \[% \s* (\w+) \s* %\] }x );
    my $phrase = $q->fetch($keyword);

=head1 ABSTRACT

This module provides a loader class for phrasebook implementations using INI
files.

=head1 DESCRIPTION

This module provides a base class for phrasebook implementations.

Phrases can be contained within one or more dictionaries, with each phrase 
accessible via a unique key. Phrases may contain placeholders, please see 
L<Data::Phrasebook> for an explanation of how to use these. Groups of phrases
are kept in a dictionary. In this implementation a dictionary is considered to
be equivilent to a section in an ini file.

An example ini file:

  [BASE]
  foo=\
    Welcome to [% my %] world. \
    It is a nice [%place %].

Within the phrase text placeholders can be used, which are then replaced with 
the appropriate values once the get() method is called. The default style of
placeholders can be altered using the delimiters() method.

=head1 INHERITANCE

L<Data::Phrasebook::Loader::Ini> inherits from the base class
L<Data::Phrasebook::Loader::Base>.
See that module for other available methods and documentation.

=head1 METHODS

=head2 load

Given a C<file>, load it. C<file> must contain a INI style layout.

   $loader->load( $file, $dict );

This method is used internally by L<Data::Phrasebook::Generic>'s
C<data> method, to initialise the data store.

It must take a C<file> (be it a scalar, or something more complex)
and return a handle.

=cut

sub load
{
    my ($class, $file, $dict) = @_;
    croak "No file given as argument!" unless defined $file;
	croak "Cannot read configuration file [$file]\n"
		unless(-r $file);

	my $cfg = Config::IniFiles->new(
					-file => $file,
					-allowcontinue => 1,	# allows continuation lines
				);
	croak "Cannot access configuration file [$file]".
			" - [@Config::IniFiles::errors]\n"	unless($cfg);
	$class->{cfg} = $cfg;

	# what sections are we using?
	($class->{default}) = $cfg->Sections;
	$class->{dict} = $class->{default}
  		unless($dict && $class->{cfg}->SectionExists( $dict ));
};

=head2 get

Returns the phrase stored in the phrasebook, for a given keyword.

   my $value = $loader->get( $key );

=cut

sub get {
	my ($class, $key) = @_;

  	my $data = $class->{cfg}->val( $class->{dict}, $key );
  	$data = $class->{cfg}->val( $class->{default}, $key )	unless($data);
	return	unless($data);

	$data =~ s!^\s+!!s;
	$data =~ s!\s+$!!s;
	$data =~ s!\s+! !sg;

	return $data;
}

1;

__END__

=head1 SEE ALSO

L<Data::Phrasebook>.

=head1 BUGS, PATCHES & FIXES

There are no known bugs at the time of this release. However, if you spot a
bug or are experiencing difficulties, that is not explained within the POD
documentation, please send an email to barbie@cpan.org or submit a bug to the
RT system (http://rt.cpan.org/). However, it would help greatly if you are 
able to pinpoint problems or even supply a patch. 

Fixes are dependant upon their severity and my availablity. Should a fix not
be forthcoming, please feel free to (politely) remind me.

=head1 DSLIP

  b - Beta testing
  d - Developer
  p - Perl-only
  O - Object oriented
  p - Standard-Perl: user may choose between GPL and Artistic

=head1 AUTHOR

  Barbie, <barbie@cpan.org>
  for Miss Barbell Productions <http://www.missbarbell.co.uk>.

=head1 LICENCE AND COPYRIGHT

  Copyright (C) 2004-2005 Barbie for Miss Barbell Productions.

  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.

The full text of the licences can be found in the F<Artistic> and
F<COPYING> files included with this module, or in L<perlartistic> and
L<perlgpl> in Perl 5.8.1 or later.

=cut
