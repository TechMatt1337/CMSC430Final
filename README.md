# CMSC430Final
Matthew Bock's CMSC430 final project!

# Introduction
This project will convert scheme code into LLVM code through a series of reductions of the language, ultimately producing an executable binary. Effectively, the series of reductions is as follows:

1. Top-Level Reductions
2. Additional Desugaring
3. ANF Conversion
4. CPS Conversion
5. Closure Conversion
6. Conversion to LLVM

The bulk of this submission consists of a combination of the reference solutions with minor modifications to support new features. These modifications will be made clear when discussing the features that required the modifications, although most of them can be found within the `header.cpp`, `utils.rkt`, and `tests.rkt` files. 

# How to Use 

Please ensure that the Boehm Garbage Collector is installed on your system (https://github.com/ivmai/bdwgc). By default, this submission will assume that the `libgc.a` file is found in `/usr/local/lib/`. If this is not the case, please update the `eval-llvm` method in utils.rkt accordingly to reflect your location of this file. 

To run a test, place your .scm file in either the public, release, or secret folder inside of the tests directory. To actually run this test, run the `tests.rkt` file while passing in the name of the .scm file. For example, if I wanted to run the file `test.scm`, I could place it into`./tests/secret/` and execute the command `racket tests.rkt test` to run the test. The program will inform you if the evaluated scheme is equal to the evaluated LLVM (ensuring that the desugaring and compilation was successful) and will produce the binary `bin` which can be ran.

If you would just like to see the raw LLVM code or manually create the binary, this code can be found in `tests.rkt`, as the function `top->llvm` will produce LLVM code, and `test-top->llvm` can be used to actually generate the binary and test to see if it was compiled successfully.

# Prims

## Required Prims

These prims are utilized by the five provided tests. These were determined by determining which prims are in the five tests (as determined via the `prim?` method). While my project technically supports all of the prims that project five supports, these are the ones that I "officially support" (as discussed in class).

* `(<= real1 real2)`
  * This prim takes in two real numbers (or expressions that will return real numbers) and will return #t if `real1` is less than or equal to `real2` in value.
* `(= num1 num2)`
  * This prim will take in two numbers (or expressions that will return numbers) and return #t if `num1` is equal to `num2` and false if not.
* `(> real1 real2)`
	* This prim takes in two real numbers (or expressions that will return real numbers) and will return #t if `real1` is greater than `real2` in value.
* `(- nums ...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of subtracting the numbers from each other. For example, if we had (- 1 2 3), that would be equivalent to (1 - 2 - 3).
* `(* nums ...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of multiplying the numbers from each other. For example, if we had (* 1 2 3), that would be equivalent to (1 * 2 * 3).
* `(+ nums ...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of adding the numbers from each other. For example, if we had (+ 1 2 3), that would be equivalent to (1 + 2 + 3).
* `(append lists...)`
  * This prim will take in zero or more lists and return a new list which consists of all of the lists appended to each other. For example, if I were to run (append '(1 2) '(3 4) '(5 6)), I would get the list '(1 2 3 4 5 6). If no lists are passed into this prim, the empty list is returned.
* `(car pair)`
  * This prim will take in a single pair and return the first element in the pair. 
* `(cdr pair)`
  * This prim will take in a single pair and return the pair, but with the first element removed. 
* `(cons? val)`
  * This prim will take in any value and return #t if the value is a pair, or #f if not.
* `(cons val1 val2)`
  * This prim will return a pair consisting of `var1` and `var2`, in that order.
* `(drop list num)`
  * This prim will take in a list and a non-negative integer. It will return a list consisting of all of the elements in `list` at and after the specified index (which is zero indexed).
* `(eq? var1 var2)`
  * This prim will return #t if `var1` is physically equal to `var2`, and #f if not.
* `(length list)`
  * This prim will return the number of elements in the list `list`.
* `(not var)`
  * This prim will return #t if `var` is #f, and will return #f if `var` is not #f.
* `(null? var)`
  * This prim will return #t if `var` is an empty list, `'()`, and will return #f if `var` is not an empty list.
* `(number? var)`
  * This prim will return #t if `var` is a number, and will return #f is `var` is not a number.


## Additional Prims

These prims have been implemented to successfully include strings into this assignment. 

* `(string char...)`
  * This prim will take zero or more 
* `(string->list )`
  * 
* `(string-ref )`
  * 
* `(substring )`
  * 
* `(string-append )`
  * 




I, Matthew Bock, pledge on my honor that I have not given or received any unauthorized assistance on this assignment.
