USING: github.advent-of-code-2021.common accessors arrays combinators kernel locals math math.functions math.order math.parser math.ranges sequences sequences.extras splitting vectors ;
IN: github.advent-of-code-2021.17

TUPLE: area x1 x2 y1 y2 ;
TUPLE: probe x y dx dy ;

: <probe> ( dx dy -- probe ) [ 0 0 ] 2dip probe boa ;

: load-target-area ( -- area )
    "17" puzzle-input 13 tail ", " split1 [ 2 tail ".." split1 [ string>number ] bi@ ] bi@ area boa ;

: step! ( probe -- )
    [ dup [ x>> ] [ dx>> ] bi + swap x<< ] keep
    [ dup [ y>> ] [ dy>> ] bi + swap y<< ] keep
    [ dup dx>> dup 0 <=> {
          { +lt+ [ 1 + ] }
          { +eq+ [ ] }
          { +gt+ [ 1 - ] }
      } case swap dx<< ] keep
    dup dy>> 1 - swap dy<< ;

SYMBOLS: :defer :miss-x :miss-y :hit ;
: check-area ( probe area -- res ) {
        { [ 2dup [ x>> ] dip x2>> > ] [ :miss-x ] }
        { [ 2dup [ y>> ] dip y1>> < ] [ :miss-y ] }
        { [ 2dup [ [ x>> ] dip x1>> >= ] [ [ y>> ] dip y2>> <= ] 2bi and ] [ :hit ] }
        [ :defer ]
    } cond [ 2drop ] dip ;

: scan ( probe area -- res ) [ 2dup check-area :defer = not ] [ [ dup step! ] dip ] until check-area ;

: triangle ( n -- n ) dup 1 + * 2 / ;

: min-dx ( area -- dx ) [ 1 ] dip  x1>> [ >= ] curry [ dup triangle ] prepose [ 1 + ] until ;

:: dys ( dx area -- dy ) area [ y1>> ] [ x1>> ] bi [a,b] [| dy | dx dy <probe> area scan :hit = ] filter ;

! Part 1

: solve-1 ( -- n ) load-target-area [ [ min-dx ] [ x2>> ] bi [a,b] ] keep [ dys ] curry map concat
    [ ] [ max ] map-reduce triangle ;

! Part 2

: solve-2 ( -- n ) load-target-area [ [ min-dx ] [ x2>> ] bi [a,b] ] keep [ dys ] curry map concat length ;

