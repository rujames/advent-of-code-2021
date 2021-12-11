USING: github.advent-of-code-2021.common arrays kernel locals math math.ranges sequences sets ;
IN: github.advent-of-code-2021.11

CONSTANT: WIDTH 10
CONSTANT: HEIGHT 10

: load-grid ( -- xs ) "11" puzzle-input-lines [ [ 48 - ] V{ } map-as ] map concat ;

: linearize ( {xy} -- n ) first2 WIDTH * + ;

: delinearize ( n -- {xy} ) [ WIDTH mod ] [ WIDTH /i ] bi 2array ; 

: neighbours ( n -- ns ) [ V{ { -1 -1 } { 0 -1 } { 1 -1 }
                              { -1  0 }          { 1  0 }
                              { -1  1 } { 0  1 } { 1  1 } } ] dip
    delinearize
    [ [ + ] 2map ] curry map
    [ first2 [ 0 >= ] both? ] filter
    [ first2 [ WIDTH < ] [ HEIGHT < ] bi* and ] filter
    [ linearize ] map ;

! Part 1

: flash! ( n xs -- ) [ dup neighbours ] dip
    [ [ [ 1 + ] change-nth ] curry each ] keep
    [ 9 + ] change-nth ;

: flash-all! ( xs -- n ) 0 swap
    [ dup [ 10 17 [a,b] in? ] find ]
    [ swap
      [ flash! ] keep
      [ 1 + ] dip ]
    while drop drop ;

: step ( n xs -- n xs )
    [ 1 + ] map
    [ flash-all! + ] keep
    [ dup 9 > [ drop 0 ] when ] map ;


: solve-1 ( -- n ) 0 load-grid 100 [ step ] times drop ;

! Part 2

: solve-2 ( -- n ) 0 0 load-grid
    [ dup [ 0 = ] all? ]
    [ step [ 1 + ] 2dip ]
    until drop drop ;
