(define one 1)
(define one2 1)
(define two 2)

(eq? one (guard (x ('#t 1)) (eq? one one2 two)))