! Copyright (C) 2021 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: io.files io.encodings.utf8 kernel sequences ;
IN: github.advent-of-code-2021.common

: puzzle-input-path ( s -- s ) { "resource:work/github/advent-of-code-2021/" "/" ".input" } swap join ;

: puzzle-input-lines ( s -- xs ) puzzle-input-path utf8 file-lines ;

: puzzle-input ( s -- s ) puzzle-input-path utf8 file-contents ;
