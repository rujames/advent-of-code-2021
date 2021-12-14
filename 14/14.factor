USING: github.advent-of-code-2021.common arrays assocs grouping hashtables kernel locals math math.functions math.order math.statistics sequences splitting ;
IN: github.advent-of-code-2021.14

: load-puzzle ( -- template rules ) "14" puzzle-input-lines { "" } split1
    [ first ]
    [ [ " -> " split1 2array ] map ]
    bi* ;

: pair-insertion ( ab rules -- acb|ab ) [ at "" or ] curry
    [ 1 head ]
    [ 1 tail ]
    tri surround ;

: declump ( xs -- s ) [ but-last [ but-last ] map "" concat-as ] [ last ] bi append ;

: step ( template rules -- template rules ) [ 2 clump ] dip
    [ [ pair-insertion ] curry ] keep
    [ map declump ] dip ;

: width ( m -- n ) values
    [ dup first [ max ] reduce ]
    [ dup first [ min ] reduce ]
    bi - ;

! Part 1

: solve-1 ( -- n ) load-puzzle 10 [ step ] times drop histogram width ;
 
! Part 2

: induced-bigrams ( ab rules -- bs ) pair-insertion 2 clump ;

:: step-hist! ( h rules -- h rules ) h [| k v | k rules induced-bigrams [| k* | v k* h at+ ] each k h [ v - ] change-at ] assoc-each h rules ;

:: overcount-monograms ( h -- h ) 26 <hashtable> [| m | h [| k v | k [| c | v c m at+ ] each ] assoc-each ] keep ;

: fix-monogram-counts ( c h -- h ) [ 2 / floor ] assoc-map [ inc-at ] keep ;

: solve-2 ( -- n ) load-puzzle
    [ 40 [ [ 2 tail* ] dip step ] times drop last ]
    [ [ 2 clump histogram ] dip 40 [ step-hist! ] times drop overcount-monograms ]
    2bi fix-monogram-counts width ;

