package Lingua::FI::Hyphenate;

=head1 NAME

Lingua::FI::Hyphenate - Finnish hyphenation (suomen tavutus)

=head1 SYNOPSIS

    use Lingua::FI::Hyphenate qw(tavuta);

    my @tavut = tavuta("kodeissansa");

    print "@tavut\n"; # will print "ko deis san sa\n";

=head1 DESCRIPTION

tavuta() returns the syllables of its Finnish input words.

The used character set is ISO 8859-1, of which the Finnish word
characters the vowels are

    aeiouy‰Âˆ AEIOUY≈ƒ÷

and the consonants are

    bcdfghjklmnpqrstvwxz BCDFGHJKLMNPQRSTVWXZ

The rules for syllable divisions are:

=over 4

=item *

Before any consonant-vowel pair I<except> when the said consonant is
the latter consonant of a syllable-initial KK pairs.

=item *

Between any vowel-vowel pair I<except> when the vowel pair is a
Finnish diphthong, that is any of the I<ai au ei eu ey ie iu iy oi ou
ui uo yi yˆ ‰i ‰y ˆi ˆy>.

=back

=head1 CAVEAT

tavuta() works only for single words.  Compound words may get wrongly
hyphenated, especially when the first component ends in a consonant
and the second component begings with a vowel.  In other words,
"kaivosaukko" ('the opening of a mine', compund of "kaivos", 'mine',
and "aukko", 'opening') will be wrongly hyphenated as "kai-vo-sauk-ko"
('well otter').  Caveat hyphenator.

You may hint the correct word/syllable division by inserting a "-" at
the right place.  In fact, any non-Finnish word characters are removed
and replaced with a syllable division.

=head1 AUTHOR

Jarkko Hietaniemi <jhi@iki.fi>

=head1 COPYRIGHT

Copyright 2001 Jarkko Hietaniemi

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

use strict;

use vars qw($VERSION @ISA @EXPORT_OK);

$VERSION = '0.01';

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(tavuta);

my $v = "aeiouy‰ÂˆAEIOUY≈ƒ÷";
my $k = "bcdfghjklmnpqrstvwxzBCDFGHJKLMNPQRSTVWXZ";
my $V = "[$v]";
my $K = "[$k]";

my $VU = 0;

sub tavuta {
    my (@sanat) = @_;

    my @tavut = @sanat;

    # Anything not a letter is a syllable division.

    @tavut = map { split /[^$v$k]+/ } @tavut;

    # Syllable division before any KV.
    # Exception: the rare loanword-based ^KK syllables.

    @tavut = map { split /(?=(?<!^$K)$K$V)/ } @tavut;

    # Syllable division between any VV pair
    # that is not a diphtong.

    @tavut = map { split /(.*?[aA])(?=[eoEO])/ }       @tavut;
    @tavut = map { split /(.*?[eiEI])(?=[ao‰ˆAOƒ÷])/ } @tavut;
    @tavut = map { split /(.*?[ouOU])(?=[aeAE])/ }     @tavut;
    @tavut = map { split /(.*?[y‰Yƒ])(?=[e‰Eƒ])/ }     @tavut;
    @tavut = map { split /(.*?[ˆ÷])(?=[eE])/ }         @tavut;

    if ($VU) {
    }

    @tavut;
}

1;
