USING: github.advent-of-code-2021.common assocs arrays combinators.smart kernel locals math sequences sets sorting splitting ;
IN: github.advent-of-code-2021.08

: load-patterns ( -- xs ) "08" puzzle-input-lines [ "|" split [ " " split "" swap remove [ natural-sort ] map ] map ] map ;

! Part 1

: solve-1 ( -- n ) load-patterns [ second ] map concat [ length { 2 3 4 7 } in? ] count ;

! Part 2

: unique-lengths ( xs -- m )
    {
        [ [ 1 ] dip [ length 2 = ] filter first 2array ]
        [ [ 7 ] dip [ length 3 = ] filter first 2array ]
        [ [ 4 ] dip [ length 4 = ] filter first 2array ]
        [ [ 8 ] dip [ length 7 = ] filter first 2array ]
    } cleave>array ;
    
:: set-three ( m xs -- m ) 3 xs [
        [ length 5 = ]
        [ 7 m at swap subset? ]
        bi and
    ] filter first 2array 1array m append ;

:: set-nine ( m xs -- m ) 9 xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? ] [ 4 m at swap subset? ] bi and ]
        bi and
    ] filter first 2array 1array m append ;

:: set-six ( m xs -- m ) 6 xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? not ] [ 1 m at swap subset? not ] bi and ]
        bi and
    ] filter first 2array 1array m append ;

:: set-zero ( m xs -- m ) 0 xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? ] [ 4 m at swap subset? not ] bi and ]
        bi and
    ] filter first 2array 1array m append ;

:: set-two ( m xs -- m ) 2 xs [
        [ length 5 = ]
        [ 8 m at 4 m at diff swap subset? ]
        bi and
    ] filter first 2array 1array m append ;

:: set-five ( m xs -- m ) 5 xs m values diff first 2array 1array m append ;

: signal-mapping ( xs -- m ) first
    [ unique-lengths ] keep
    [ set-three ] keep
    [ set-nine ] keep
    [ set-six ] keep
    [ set-zero ] keep
    [ set-two ] keep
    set-five ;

:: decode-digit ( m s -- n ) m [ [ drop ] dip s = ] assoc-find drop drop ;

:: decode ( m xs -- n ) m xs second
    [ decode-digit ] with map
    { 1000 100 10 1 } [ * ] 2map sum ;

: solve-2 ( -- n ) load-patterns [ [ signal-mapping ] keep decode ] map-sum ;

