! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: github.advent-of-code-2021.common assocs arrays combinators hashtables kernel math math.parser math.ranges sequences splitting ;
IN: github.advent-of-code-2021.05

: load-lines ( -- xs ) "05" puzzle-input-lines [ " -> " split1 [ "," split [ string>number ] map ] bi@ 2array ] map ;

: horizontal? ( x -- ? ) first2 [ second ] bi@ = ;

: vertical? ( x -- ? ) first2 [ first ] bi@ = ;

: diagonal? ( x -- ? ) [ first2 [ - ] 2map first2 = ] [ [ first2 + ] map first2 = ] bi or ;

: points ( x -- xs ) {
        { [ dup vertical? ] [
              [ first first ]
              [ [ second ] map first2 [a,b] ]
              bi [ 2array ] with map ] }
        { [ dup horizontal? ] [
              [ [ first ] map first2 [a,b] ]
              [ first second ]
              bi [ 2array ] curry map ] }
        { [ dup diagonal? ] [
              first2 [ [a,b] ] 2map first2 [ 2array ] 2map
          ] }
    } cond ;

: count-intersections ( lines -- n ) [ points ] map concat
    0 <hashtable> [ swap [ inc-at ] keep ] reduce
    values [ 1 > ] filter length ;

! Part 1

: solve-1 ( -- n ) load-lines [ [ horizontal? ] [ vertical? ] bi or ] filter count-intersections ;

! Part 2

: solve-2 ( -- n ) load-lines [ [ horizontal? ] [ vertical? ] [ diagonal? ] tri or or ] filter count-intersections ;
