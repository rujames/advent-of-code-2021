! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: github.advent-of-code-2021.common arrays combinators fry kernel locals math math.parser sequences splitting ;
IN: github.advent-of-code-2021.02

: parse-command ( s -- cmd ) " " split1 string>number [ * ] curry [ {
            { "forward"  [ { 1 0 } ] }
            { "down" [ { 0 1 } ] }
            { "up" [ { 0 -1 } ] }
        } case ] dip map ;

: load-commands ( -- xs ) "02" puzzle-input-lines [ parse-command ] map ;

: apply-command ( pos cmd -- pos ) [ + ] 2map ;

! Part 1

: solve-1 ( -- n ) load-commands { 0 0 } [ apply-command ] reduce product ;

! Part 2

:: (move-aimed) ( x y aim a b -- x y aim )
    x a +
    y aim a * +
    aim b + ;
  
: move-aimed ( pos cmd -- pos ) [ first3 ] dip first2 (move-aimed) 3array ;

: solve-2 ( -- x ) load-commands { 0 0 0 } [ move-aimed ] reduce first2 * ; 
