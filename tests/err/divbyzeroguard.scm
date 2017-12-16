(define one 1)
(define two 2)
(define three 3)

(/ one two three)

(+ 1 (guard (x ('#t 2)) (/ one two three (/ one two three))))