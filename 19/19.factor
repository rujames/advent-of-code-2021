USING: github.advent-of-code-2021.common accessors arrays io kernel locals math math.matrices math.parser math.vectors sequences sets splitting ;
IN: github.advent-of-code-2021.19

TUPLE: scan id m ;

: load-scans ( -- scans ) "19" puzzle-input-lines { "" } split
    [ [ first ] [ rest ] bi [ "," split [ string>number ] map ] map scan boa ] map ;
    
: rotations ( -- ms ) {
        { { 1 0 0 }
          { 0 1 0 }
          { 0 0 1 } }
        { { 1 0 0 }
          { 0 0 -1 }
          { 0 1 0 } }
        { { 0 0 1 }
          { 0 1 0 }
          { -1 0 0 } }
        { { 0 -1 0 }
          { 1 0 0 }
          { 0 0 1 } }
    } 2 [ dup cartesian-product concat ] times [ concat 3 identity-matrix [ m. ] reduce ] map members ;

: offset-candidates ( m1 m2 -- vs ) [ v- ] cartesian-map concat ;

: apply-offset ( m v -- m ) [ v+ ] curry map ;

:: overlap? ( v m1 m2 -- ? ) m2 v apply-offset m1 intersect length 12 >= ;

: ?offset ( m1 m2 -- v ) [ offset-candidates ] [ [ overlap? ] 2curry ] 2bi filter ?first ;

TUPLE: edge a b q r ;

:: ?edge ( scan1 scan2 -- edge/f ) rotations
    [| q |
     scan1 m>>
     scan2 m>> q m.
     [let    
      ?offset :> r
      r [ scan1 scan2 q r edge boa ] [ f ] if
     ]
    ] map sift ?first ;

: edges ( scans -- edges ) dup [
        2dup = [ 2drop f ] [ ?edge ] if
    ] cartesian-map concat sift ;

! Part 1

:: (stitch) ( q r from edges -- beacons )
    from m>>
    [let
     edges [ a>> from [ id>> ] bi@ = ] filter
     edges [ [ a>> id>> ] [ b>> id>> ] bi [ from id>> = ] bi@ or ] reject :> remaining
     [ [ q>> ] [ r>> ] [ b>> ] tri remaining (stitch) ] map concat union
    ] q m. r apply-offset ; 

: stitch ( edges -- beacons ) [ 3 identity-matrix { 0 0 0 } ] dip [ first a>> ] [ ] bi (stitch) ;

: solve-1 ( -- n ) load-scans edges stitch length ;

! Part 2

:: (scanners) ( q r from edges -- scanners )
    { { 0 0 0 } }
    [let
     edges [ a>> from [ id>> ] bi@ = ] filter
     edges [ [ a>> id>> ] [ b>> id>> ] bi [ from id>> = ] bi@ or ] reject :> remaining
     [ [ q>> ] [ r>> ] [ b>> ] tri remaining (scanners) ] map concat union
    ] q m. r apply-offset ; 

: scanners ( edges -- scanners ) [ 3 identity-matrix { 0 0 0 } ] dip [ first a>> ] [ ] bi (scanners) ;
 
: manhattan ( v1 v2 -- n ) [ - abs ] 2map sum ;

: solve-2 ( -- n ) load-scans edges scanners dup [ manhattan ] cartesian-map concat [ ] [ max ] map-reduce ;
