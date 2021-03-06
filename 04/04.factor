! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: github.advent-of-code-2021.common arrays locals kernel math math.parser sequences sets splitting ;
IN: github.advent-of-code-2021.04

: load-game ( -- moves boards ) "04" puzzle-input-lines
    [ 2 tail { "" } split [ [ " " split [ empty? not ] filter [ string>number f 2array ] map ] map ]  map ]
    [ first "," split [ string>number ] map ]
    bi ;

: row-bingo? ( board i -- ? ) swap nth [ second ] all? ;

: column-bingo? ( board j -- ? ) [ swap nth second ] curry all? ;

:: ?board-index ( board n -- {ij}/f ) board
    [ [ first n = ] find drop ] find
    [ first n = ] find
    [ 2array ]
    [ drop drop f ]
    if ;

: bingo? ( board n -- ? ) dupd ?board-index
    [ first2 pick swap [ row-bingo? ] [ column-bingo? ] 2bi* or ]
    [ drop f ]
    if* ;

:: dab ( board n -- board ) board [ [ { n f } { n t } replace ] map ] map ;

:: split-winners ( boards n -- remaining winners ) boards
    [ n dab ] map dup
    [ n bingo? ] filter
    [ diff ] keep ;

:: first-winner ( boards ns -- board n ) boards ns first split-winners
    dup empty?
    [ drop ns rest first-winner ]
    [ [ drop ] dip first ns first ]
    if ;

: score ( board n -- n ) [ concat [ second not ] filter [ first ] map sum ] dip * ;

! Part 1

: solve-1 ( -- n ) load-game first-winner score ;

! Part 2

:: last-winner ( boards ns -- board n ) boards ns first split-winners
    drop dup length 1 =
    [ first 1array ns rest first-winner ]
    [ ns rest last-winner ]
    if ;

: solve-2 ( -- n ) load-game last-winner score ;
