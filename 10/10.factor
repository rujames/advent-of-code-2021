USING: github.advent-of-code-2021.common assocs combinators kernel math math.functions sequences sets sorting ;
IN: github.advent-of-code-2021.10

: load-lines ( -- xs ) "10" puzzle-input-lines ;

CONSTANT: brackets { { 40 41 } { 91 93 } { 123 125 } { 60 62 } }

: open? ( n -- ? ) brackets [ first ] map in? ;

: closed? ( n -- ? ) brackets [ second ] map in? ;

! Part 1

: match-failed ( v n -- v ) [ drop ] dip V{ f } clone [ push ] keep ;

: ?illegal-character ( s -- n/f ) V{ t } clone
    [
        over first
        [ { { [ dup open? ] [ swap [ push ] keep ] }
            { [ dup closed? ] [ dup [ over pop brackets at = ] dip swap [ drop ] [ match-failed ] if ] } } cond ]
        [ drop ]
        if
    ]
    reduce dup first [ drop f ] [ second ] if ;

: syntax-score ( n -- n ) {
        { 41 [ 3 ] }
        { 93 [ 57 ] }
        { 125 [ 1197 ] }
        { 62 [ 25137 ] }
    } case ;      

: solve-1 ( -- n ) load-lines [ ?illegal-character ] map sift [ syntax-score ] map-sum ;

! Part 2

: unmatched ( s -- v ) V{ } clone
    [ { { [ dup open? ] [ swap [ push ] keep ] }
        { [ dup closed? ] [ drop [ pop* ] keep ] } } cond ]
    reduce ;

: completion-score ( v -- n ) reverse 0
    [ { { 40 [ 1 ] }
        { 91 [ 2 ] }
        { 123 [ 3 ] }
        { 60 [ 4 ] } }
      case [ 5 * ] dip + ] reduce ;

: solve-2 ( -- n ) load-lines
    [ ?illegal-character not ] filter
    [ unmatched completion-score ] map
    natural-sort
    [ length 2 / floor ] [ ] bi nth ;

