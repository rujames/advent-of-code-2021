! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: github.advent-of-code-2021.common io.files io.encodings.utf8 math math.parser kernel sequences sequences.extras ;
IN: github.advent-of-code-2021.01

: load-sweep ( -- xs ) "01" puzzle-input-lines [ string>number ] map ;

: solve ( xs -- n )  dup rest [ < ] 2count ;

! Part 1

: solve-1 ( -- n ) load-sweep solve ;

! Part 2

: solve-2 ( -- n ) load-sweep dup rest dup rest [ + + ] 3map solve ;
