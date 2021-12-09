USING: github.advent-of-code-2021.common arrays kernel locals math math.parser math.ranges sequences sets sorting ;
IN: github.advent-of-code-2021.09

CONSTANT: WIDTH 100
CONSTANT: HEIGHT 100

: load-heightmap ( -- xs ) "09" puzzle-input-lines [ [ 48 - ] { } map-as ] map ;

: indices ( -- {xy}s ) HEIGHT [0,b) [ [ 2array ] curry [ WIDTH [0,b) ] dip map ] map concat ;

: height ( {xy} xs -- n ) [ first2 ] dip nth nth ;

: neighbours ( {xy} -- {xy}s ) [ { { 0 -1 } { -1 0 } { 1 0 } { 0 1 } } ] dip
    [ [ + ] 2map ] curry map
    [ first2 [ 0 >= ] both? ] filter
    [ first2 [ WIDTH < ] [ HEIGHT < ] bi* and ] filter ;
    
! Part 1

:: low-point? ( {xy} xs -- ? )
    {xy} neighbours [ xs height ] map 
    {xy} xs height [ > ] curry
    all? ;

: ?risk-score ( {xy} xs -- n/f ) [ low-point? ] 2keep [ height 1 + ] 2curry [ f ] if ;

: solve-1 ( -- n ) indices load-heightmap [ ?risk-score ] curry map sift sum ;

! Part 2

:: descend ( {xy} xs -- {xy} ? ) {xy} neighbours {xy}
    [ [ [ xs height ] bi@ < ] 2keep ? ] reduce
    dup {xy} = ;
    
: basin ( {xy} xs -- {xy} ) [ descend ] curry [ ] until ;

: solve-2 ( -- n ) indices load-heightmap
    [| xs | [ xs height 9 < ] filter ] keep 
    [ basin ] curry map
    [ members ] keep
    [ swap [ = ] curry count ] curry map
    natural-sort 3 tail* product ;
