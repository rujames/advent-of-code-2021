! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.

USING: github.advent-of-code-2021.common arrays combinators kernel locals math math.parser math.ranges sequences sequences.generalizations splitting ;
IN: github.advent-of-code-2021.06

: load-fish ( -- xs ) "06" puzzle-input "," split [ string>number ] map ;

! Part 1

: step ( xs -- xs )
    [ [ 0 = ] count 8 <array> ]
    [ [ dup 0 = [ drop 6 ] [ 1 - ] if ] map ]
    bi append ;

: solve-1 ( -- n ) load-fish 80 [ step ] times length ; 

! Part 2

: step* ( xs -- xs ) {
        [ 1 swap nth ]
        [ 2 swap nth ]
        [ 3 swap nth ]
        [ 4 swap nth ]
        [ 5 swap nth ]
        [ 6 swap nth ]
        [ [ 7 swap nth ] [ 0 swap nth ] bi + ]
        [ 8 swap nth ]
        [ 0 swap nth ]
    } cleave 9 narray ;

:: build-table ( xs -- xs ) 8 [0,b] [ [ = ] curry [ xs ] dip count ] map ;

: solve-2 ( -- n ) load-fish build-table 256 [ step* ] times sum ;
