USING: github.advent-of-code-2021.common kernel math math.functions math.order math.parser math.ranges sequences splitting ;
IN: github.advent-of-code-2021.07

: load-crabs ( -- xs ) "07" puzzle-input "," split [ string>number ] map ;

: span ( xs -- xs ) dup 0 [ max ] reduce [ [ min ] reduce ] keep [a,b] ;

! Part 1

: system-score ( xs x -- n ) [ - abs ] curry map-sum ;

: solve-1 ( -- n ) load-crabs dup [ system-score ] with map 1000000000 [ min ] reduce ;

! Part 2

: system-score* ( xs x -- n ) [ - abs [1,b] sum ] curry map-sum ;

: solve-2 ( -- n ) load-crabs dup span [ system-score* ] with map 1000000000 [ min ] reduce ;

