USING: github.advent-of-code-2021.common accessors combinators kernel math math.order math.parser sequences sequences.extras ;
IN: github.advent-of-code-2021.16

: load-transmission ( -- s ) "16" puzzle-input hex> >bin ;

TUPLE: literal version type value ;
TUPLE: operator version type length-type subpackets ;

DEFER: >packets
DEFER: >packet>

: >literal> ( version type unparsed -- literal unparsed ) [ "" ] dip
    [ dup first 48 = ]
    [ [ 5 head ] [ 5 tail ] bi [ rest append ] dip ]
    until
    [ 5 head ] [ 5 tail ] bi [ rest append bin> literal boa ] dip ;

: >type-0-operator> ( version type unparsed -- operator unparsed ) [ "0" ] dip
    [ 15 tail ] [ 15 head bin> ] bi
    [ head ] [ tail ] 2bi
    [ >packets operator boa ] dip ;

: >type-1-operator> ( version type unparsed -- operator unparsed ) [ "1" V{ } clone ] dip
    [ 11 tail ] [ 11 head bin> ] bi
    [ >packet> [ swap [ push ] keep ] dip ] times
    [ operator boa ] dip ;

: >packet> ( unparsed -- packet unparsed ) [ 3 head ] [ [ 3 6 ] dip subseq ] [ 6 tail ] tri
    over {
        { "100" [ >literal> ] }
        [ drop [ rest ] [ first ] bi { { 48 [ >type-0-operator> ] } { 49 [ >type-1-operator> ] } } case ]
    } case ;

: >packets ( unparsed -- ps ) [ V{ } clone ] dip
    [ dup [ 48 = ] all? ]
    [ >packet> [ swap [ push ] keep ] dip ]
    until drop ;

! Part 1

: sum-versions ( packet -- n ) {
        { [ dup literal? ] [ version>> bin> ] }
        { [ dup operator? ] [ [ subpackets>> [ sum-versions ] map-sum ] [ version>> bin> ] bi + ] }
    } cond ;

: solve-1 ( -- n ) load-transmission >packets [ sum-versions ] map-sum ;

! Part 2

: apply ( packet -- n ) {
        { [ dup literal? ] [ value>> ] }
        { [ dup operator? ]
          [ dup type>>
            { { "000" [ subpackets>> [ apply ] map-sum ] }
              { "001" [ subpackets>> [ apply ] map-product ] }
              { "010" [ subpackets>> [ apply ] [ min ] map-reduce ] }
              { "011" [ subpackets>> [ apply ] [ max ] map-reduce ] }
              { "101" [ subpackets>> [ apply ] map first2 > 1 0 ? ] }
              { "110" [ subpackets>> [ apply ] map first2 < 1 0 ? ] }
              { "111" [ subpackets>> [ apply ] map first2 = 1 0 ? ] }
            } case
          ]
        }
    } cond ;
              
: solve-2 ( -- n ) load-transmission >packets first apply ;
