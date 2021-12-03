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

:: iterative-filter ( xs i quot -- xs ) i xs quot call( n xs -- xs ) {
        { [ dup length 1 > ] [  1 i + quot iterative-filter ] }
        [ ]
    } cond ;

: (oxygen) ( n xs -- xs ) [ most-common-bits swap [ nth= ] 2curry ] keep swap filter ;

: oxygen ( xs -- n )  0 [ (oxygen) ] iterative-filter first binary>number ;

: (co2) ( n xs -- xs ) [ least-common-bits swap [ nth= ] 2curry ] keep swap filter ;

: co2 ( xs -- n ) 0 [ (co2) ] iterative-filter first binary>number ;

: solve-2 ( -- n ) load-report [ oxygen ] [ co2 ] bi * ;
