(apply (lambda x (guard (err ('#t (apply + x))) (apply '1 x))) '(1 2 3))