(define lst '(1 2 3))

(cons (guard (x ('#t 0)) (cons lst)) lst)