USING: github.advent-of-code-2021.common assocs arrays combinators.smart kernel locals math sequences sets sorting splitting ;
IN: github.advent-of-code-2021.08

: load-patterns ( -- xs ) "08" puzzle-input-lines [ "|" split [ " " split "" swap remove [ natural-sort ] map ] map ] map ;

! Part 1

: solve-1 ( -- n ) load-patterns [ second ] map concat [ length { 2 3 4 7 } in? ] count ;

! Part 2

:: (set-n) ( xs n m -- m ) n xs first 2array 1array m append ;

: unique-lengths ( xs -- m )
    {
        [ [ 1 ] dip [ length 2 = ] filter first 2array ]
        [ [ 7 ] dip [ length 3 = ] filter first 2array ]
        [ [ 4 ] dip [ length 4 = ] filter first 2array ]
        [ [ 8 ] dip [ length 7 = ] filter first 2array ]
    } cleave>array ;

! Three is the only 5-segment which contains 7
:: set-three ( m xs -- m ) xs [
        [ length 5 = ]
        [ 7 m at swap subset? ]
        bi and
    ] filter 3 m (set-n) ;

! Nine is the only 6-segment to contain both 7 and 4
:: set-nine ( m xs -- m ) xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? ] [ 4 m at swap subset? ] bi and ]
        bi and
    ] filter 9 m (set-n) ;

! Six is the only 6-segment to contain neither 7 nor 1
:: set-six ( m xs -- m ) xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? not ] [ 1 m at swap subset? not ] bi and ]
        bi and
    ] filter 6 m (set-n) ;

! Zero is the only 6-segment to contain 7 but not 4
:: set-zero ( m xs -- m ) xs [
        [ length 6 = ]
        [ [ 7 m at swap subset? ] [ 4 m at swap subset? not ] bi and ]
        bi and
    ] filter 0 m (set-n) ;

! Two is the only 5-segment to contain the complement of 4
:: set-two ( m xs -- m ) xs [
        [ length 5 = ]
        [ 8 m at 4 m at diff swap subset? ]
        bi and
    ] filter 2 m (set-n) ;

! Five is what's left after we've found the rest of them :)
:: set-five ( m xs -- m ) xs m values diff 5 m (set-n) ;

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

