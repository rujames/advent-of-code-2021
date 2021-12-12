USING: github.advent-of-code-2021.common arrays combinators kernel locals math sequences sets sorting splitting ;  
IN: github.advent-of-code-2021.12

: load-caves ( -- es ) "12" puzzle-input-lines [ "-" split ] map ;

: large? ( v -- ? ) first 97 < ;

: star ( es v -- es ) [ swap in? ] curry filter ;

: link ( es v -- vs )
    [ star ] keep
    [ [ = not ] curry filter ] curry map
    concat ;

: excise ( es v -- es ) [ dup ] dip star diff ;

! Part 1

:: #paths ( es v -- n )
    {
        { [ v "end" = ] [ 1 ] }
        { [ es v star null? ] [ 0 ] }
        [ v large?
          [ es v link [ es swap #paths ] map-sum ]
          [ es v link [ es v excise swap #paths ] map-sum ]
          if
        ]
    } cond ;

: solve-1 ( -- n ) load-caves "start" #paths ;

! Part 2

:: paths ( es from to -- ps )
    {
        { [ from to = ] [ { { } } ] }
        { [ es from star null? ] [ { } ] }
        [ from large?
          [ es from link [| v | es v to paths [ { { from v } } swap append ] map ] map concat ]
          [ es from link [| v | es from excise v to paths [ { { from v } } swap append ] map ] map concat ]
          if
        ]
    } cond ;

:: scenic-paths ( es from to -- ps )
    {
        { [ from to = ] [ { { } } ] }
        { [ es from star null? ] [ { } ] }
        [ from large?
          [ es from link [| v | es v to scenic-paths [ { { from v } } swap append ] map ] map concat ]
          [
              es from link [| v | es from excise v to scenic-paths [ { { from v } } swap append ] map ] map concat
              es from link [| v | es v from paths [ { { from v } } swap append ] map ] map concat
              [| path |
               path concat members [ [ large? ] [ from = ] bi or not ] filter es [ excise ] reduce from to paths
               [ path swap append ] map
              ] map concat
              append
          ]
          if
        ]
    } cond ;

: solve-2 ( -- n ) load-caves "start" [ excise ] [ link ] 2bi [ "end" scenic-paths length ] with map-sum ;
