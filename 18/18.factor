USING: github.advent-of-code-2021.common accessors arrays combinators kernel locals math math.functions math.order sequences splitting strings ;
IN: github.advent-of-code-2021.18

: tokenize ( s -- seq ) [ V{ } clone ] dip
    [
        {
            { [ dup [ 48 >= ] [ 58 < ] bi and ] [ 48 - swap [ push ] keep ] }
            [ 1string swap [ push ] keep ]
        } cond
    ] each ;

:: (?explosion-index) ( seq idx depth -- idx/f )
    {
        { [ seq length idx = ] [ f ] }
        { [ idx seq nth "," = depth 5 = and ] [ idx ] }
        [ idx seq nth
          {
              { "[" [ seq idx 1 + depth 1 + (?explosion-index) ] }
              { "]" [ seq idx 1 + depth 1 - (?explosion-index) ] }
              [ drop seq idx 1 + depth (?explosion-index) ]
          } case
        ]
    } cond ;

: ?explosion-index ( seq -- idx/f ) 0 0 (?explosion-index) ;

: ?left-regular ( seq idx -- {n,idx}/f ) 2 - head
    [ 2array ] map-index
    [ first number? ] filter
    ?last ;

:: explode-left ( seq idx -- seq )
    [let seq clone :> seq*
     seq* idx ?left-regular
     [
         second seq* [ idx 1 - seq* nth + ] change-nth
     ] when* seq*
    ] ;

: ?right-regular ( seq idx -- {n,idx}/f ) [ [ 2array ] map-index ] dip
    2 + tail
    [ first number? ] filter
    ?first ;

:: explode-right ( seq idx -- seq )
    [let seq clone :> seq*
     seq* idx ?right-regular
     [
         second seq* [ idx 1 + seq* nth + ] change-nth
     ] when* seq*
    ] ;

:: explode-mid ( seq idx -- seq ) { 0 } idx 2 - idx 3 + seq clone replace-slice ;

: explode-at ( seq idx -- seq )
    [ explode-left ] keep
    [ explode-right ] keep
    explode-mid ;

: ?split-index ( seq -- {n,idx}/f ) [ 2array ] map-index
    [ first number? ] filter
    [ first 10 >= ] filter
    ?first ;

:: split-at ( seq idx -- seq ) idx first [ 2 / floor ] [ 2 / ceiling ] bi
    [let :> b :> a { "[" a "," b "]" } ]
    idx second idx second 1 + seq clone replace-slice ;

: reduce-number ( seq -- seq )
    dup ?explosion-index [ explode-at reduce-number ] when*
    dup ?split-index [ split-at reduce-number ] when* ;

:: add-numbers ( seq1 seq2 -- seq ) { { "[" } seq1 { "," } seq2 { "]" } } concat reduce-number ;

: magnitude ( seq -- n ) V{ } clone swap
    [
        {
            { [ dup number? ] [ swap [ push ] keep ] }
            { [ "]" = ] [ [ [ pop 2 * ] [ pop 3 * ] bi + ] keep [ push ] keep ] }
            [ ]
        } cond
    ] each first ;

! Part 1

: solve-1 ( -- n ) "18" puzzle-input-lines [ tokenize ] [ add-numbers ] map-reduce magnitude ;

! Part 2

: solve-2 ( -- n ) "18" puzzle-input-lines [ tokenize ] map dup
    [ 2dup = [ 2drop 0 ] [ add-numbers magnitude ] if ]
    cartesian-map concat [ ] [ max ] map-reduce ;
