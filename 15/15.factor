USING: github.advent-of-code-2021.common
arrays combinators.smart grouping locals kernel math math.order math.ranges path-finding sequences ;
IN: github.advent-of-code-2021.15

CONSTANT: WIDTH 100

: load-cave ( -- ns ) "15" puzzle-input-lines [ [ 48 - ] V{ } map-as ] map concat ;

: linearize ( {xy} w -- n ) [ first2 ] dip * + ;

: delinearize ( n w -- {xy} ) [ mod ] [ /i ] 2bi 2array ; 

:: neighbours ( n w -- ns ) V{ { 0 -1 } { -1  0 } { 1  0 } { 0  1 } } n
    w delinearize
    [ [ + ] 2map ] curry map
    [ first2 [ 0 >= ] both? ] filter
    [ first2 [ w < ] bi@ and ] filter
    [ w linearize ] map ;

! Part 1

: solve-1 ( -- n ) 0 9999
    [let load-cave :> ns
     [ 100 neighbours ]
     [ [ drop ] dip ns nth ]
     [ 2drop 0 ]
     <astar>
     find-path
     rest [ ns nth ] map-sum
    ] ;

! Part 2

: rotate ( ns -- ns ) [ 9 mod 1 + ] map ;

: expand ( ns w -- ns ) group
    [ [ dup rotate dup rotate dup rotate dup rotate ] append-outputs ] map concat
    [ dup rotate dup rotate dup rotate dup rotate ] append-outputs ;

: solve-2 ( -- n ) 0 249999
    [let load-cave 100 expand :> ns
     [ 500 neighbours ]
     [ [ drop ] dip ns nth ]
     [ 2drop 0 ]
     <astar>
     find-path
     rest [ ns nth ] map-sum
    ] ;
