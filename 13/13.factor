USING: github.advent-of-code-2021.common arrays combinators io kernel locals math math.parser math.ranges sequences sets splitting ;
IN: github.advent-of-code-2021.13

: load-paper ( -- dots instructions ) "13" puzzle-input-lines { "" } split1
    [ [ "," split [ string>number ] map ] map ]
    [ [ "=" split1 string>number 2array ] map ]
    bi* ;

:: fold-x ( x dots -- dots ) dots
    [ first x < ] partition
    [ first2 [ x 2 * swap - ] dip 2array ] map append members ;

:: fold-y ( y dots -- dots ) dots
    [ second y < ] partition
    [ first2 y 2 * swap - 2array ] map append members ;

: fold ( dots instruction -- dots ) dup first {
        { "fold along x" [ second swap fold-x ] }
        { "fold along y" [ second swap fold-y ] }
    } case ;

! Part 1 

: solve-1 ( -- n ) load-paper first fold length ;

! Part 2

:: display! ( dots -- ) 0 5 [a,b] [| y | 0 38 [a,b] [| x | { x y } dots in? "#" " " ? ] map concat print ] each ;

: solve-2 ( -- ) load-paper swap [ fold ] reduce display! ;
