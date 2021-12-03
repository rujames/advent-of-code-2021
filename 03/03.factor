! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: github.advent-of-code-2021.common combinators locals kernel math math.parser sequences strings ;
IN: github.advent-of-code-2021.03

: load-report ( -- xs ) "03" puzzle-input-lines [ [ 48 - ] { } map-as ] map ;

: count-digits ( xs -- xs ) { 0 0 0 0 0 0 0 0 0 0 0 0 } [ [ + ] 2map ] reduce ;

: binary>number ( ds -- n ) [ 48 + ] "" map-as bin> ;

: most-common-bits ( xs -- xs ) [ count-digits ] [ length 2 / ] bi [ >= 1 0 ? ] curry map ;

: least-common-bits ( xs -- xs ) [ count-digits ] [ length 2 / ] bi [ >= 0 1 ? ] curry map ;

: gamma ( xs -- n )  most-common-bits binary>number ;

: epsilon ( xs -- n ) least-common-bits binary>number ;

! Part 1

: solve-1 ( -- n ) load-report [ gamma ] [ epsilon ] bi * ;

! Part 2

: nth= ( xs ys n -- ? ) [ swap nth ] curry bi@ = ;

: (oxygen) ( n xs -- xs ) [ most-common-bits swap [ nth= ] 2curry ] keep swap filter ;

:: oxygen ( xs i -- n ) i xs (oxygen) {
        { [ dup length 1 > ] [ 1 i + oxygen ] }
        [ first binary>number ]
    } cond ;

: (co2) ( n xs -- xs ) [ least-common-bits swap [ nth= ] 2curry ] keep swap filter ;

:: co2 ( xs i -- n ) i xs (co2) {
        { [ dup length 1 > ] [ 1 i + co2 ] }
        [ first binary>number ]
    } cond ;

: solve-2 ( -- n ) load-report [ 0 oxygen ] [ 0 co2 ] bi * ;
