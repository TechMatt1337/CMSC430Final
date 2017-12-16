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

To run a test, place your .scm file in either the err, public, release, or secret folders inside of the tests directory. To actually run this test, run the `tests.rkt` file while passing in the name of the .scm file. For example, if I wanted to run the file `test.scm`, I could place it into`./tests/secret/` and execute the command `racket tests.rkt test` to run the test. The program will inform you if the evaluated scheme is equal to the evaluated LLVM (ensuring that the desugaring and compilation was successful) and will produce the binary `bin` which can be ran.

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
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of subtracting the numbers from each other. For example, if we had (- 1 2 3), that would be mathematically equivalent to (1 - 2 - 3).
* `(* nums ...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of multiplying the numbers from each other. For example, if we had (* 1 2 3), that would be mathematically equivalent to (1 * 2 * 3).
* `(+ nums ...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of adding the numbers from each other. For example, if we had (+ 1 2 3), that would be mathematically equivalent to (1 + 2 + 3).
* `(append lists...)`
  * This prim will take in zero or more lists and return a new list which consists of all of the lists appended to each other. For example, if I were to run (append '(1 2) '(3 4) '(5 6)), I would get the list '(1 2 3 4 5 6). If no lists are passed into this prim, the empty list is returned.
* `(car pair)`
  * This prim will take in a single pair and return the first element in the pair. 
* `(cdr pair)`
  * This prim will take in a single pair and return the pair, but with the first element removed. 
* `(cons val1 val2)`
  * This prim will return a pair consisting of `var1` and `var2`, in that order.
* `(eq? var1 var2)`
  * This prim will return #t if `var1` is physically equal to `var2`, and #f if not.
* `(not var)`
  * This prim will return #t if `var` is #f, and will return #f if `var` is not #f.
* `(null? var)`
  * This prim will return #t if `var` is an empty list, `'()`, and will return #f if `var` is not an empty list.
* `(number? var)`
  * This prim will return #t if `var` is a number, and will return #f is `var` is not a number.

## Additional Prims

These prims have been implemented to successfully include strings into this assignment. Also, the division prim is officially supported, as dividing by zero will be handled as a run-time error.

* `(string char...)`
  * This prim will take zero or more characters (such as #\a) and will return a string containing all of the characters in the specified order. If no characters are provided, an empty string will returned.
* `(string->list str)`
  * This prim will convert `str` into a list of characters. If `str` is an empty string, an empty list will be returned. The null byte will not be included in this list. 
* `(string-ref str num)`
  * This prim will take a string and a non-negative integer and will return the character found at that index of the string, as if it were a list. 
* `(substring str start)`
  * This prim will take a string and a non-negative integer and will return a string consisting of the characters after (and including) the specified index (as if it were a list).
* `(substring str start end)`
  * This prim will take a string, a non-negative integer, and another non-negative integer and will return a string consisting of the characters after (and including) the specified start index (as if it were a list), but before the specified end index.
* `(string-append str1 str2)`
  * This prim will return a new string consisting of `str2` appended to the end of `str1`. For example, if `str1` were "abc" and if `str2` were "def", the outputted string would be "abcdef".
* `(/ num...+)`
  * This prim will take in one or more numbers (or expressions that will return numbers) and return the result of performing integer division on the numbers from each other. For example, if we had (/ 1 2 3), that would be mathematically equivalent to (1 / 2 / 3), which is mathematically equivalent to ((1 / 2) / 3), which will return 0. See the run-time error section of this writeup to see how passing 0 into any argument other than the first one is handled.

# Run-Time Errors

## Notes on My Run-Time Error Handling

To catch run-time errors, I use the strategy of throwing error messages within the program and catching them with a global guard. When running "eval-top-level", I have modifed the `with-handlers` section of the `racket-compile-eval` function to listen for a variety of error messages such as `exn:fail:contract:arity?` and `exn:fail:contract:divide-by-zero?`. When these error messages occur, I parse the error information out of the struct to determine the information from the error. For example, while a `exn:fail:contract:arity?` might return something along the lines of [(exn:fail:contract:arity
 "eq?: arity mismatch;\n the expected number of arguments does not match the given number\n  expected: 2\n  given: 4\n  arguments...:\n   1\n   5\n   4\n   0"
 #<continuation-mark-set>)], I parse this error and return with an error message stating: "ERROR: eq?  expected 2  given 4". When converting the code to LLVM code, I will add in additional logic during the desugaring phase of compilation which will check for various errors. For example, if I see the expression `(eq? '1 '2 '3 '4)`, I know that that is a contract violation as `eq?` only takes two arguments. Thus, I will replace that expression with `(raise "ERROR: eq?  expected 2  given 4")`. While I am aware that this could easily be done by introduceing an if expression within the code itself, that would only add to the complexity of the program and would make debugging more difficult. During the compilation process, the code to be desugared will be wrapped with an added gaurd that will look for raised errors and just return the error raised.

This method was chosen due to the fact that guard statements can catch various run-time errors. For example, if we had the program `(guard (x ('#t '5')) (/ '1 '0))`, `eval-top-level` would return '5, which is expected. If we were to halt as soon as this error occurred, our program would just halt with the given error message instead of being captured by the guard. Thus, by doing this method of error throwing, both our `eval-top-level` and LLVM code will return '5.

This method does have some issues, however. If we were compiling the program `(raise '5)` without a guard to catch it, the `eval-top-level` execution will throw an error regarding an uncaught exception while the LLVM code will handle it and return the value. Since uncaught exceptions are a run-time error that I am not addressing, the program should still be perfectly valid according to the constraints of the assignment.

## Run-Time Errors Handled

* Dividing by zero
  * When dividing by zero, an error message should appear stating `"ERROR: divided by zero!"`. This has been accomplished by desugaring `(/ a b c)` into `(/ a (if (= b 0) (raise "ERROR: divided by zero!") b) (if (= c 0) (raise "ERROR: divided by zero!") c))`.
  * Tests:
    * divbyzero
    * divbyzeroguard
* Prim too few arguments
  * This run-time error is handled identically to the "Prim too many arguments" run-time error. When desugaring, the code will manually examine each (officially supported) prim and determine how many arguments were passed into it. If the number of arguments does not match the expected number of arguments, the desugaring phase will replace the call entirely with a raise call detailing the specifics. For example, if the desugarer were to see `(eq? 1 2 3 4)`, it would exclude that expression entirely and replace it with `(raise "ERROR: eq?  expected 2  given 4")`.
  * Tests:
    * toofewprims
    * toofewprimsguard
* Prim too many arguments
  * This run-time error is handled identically to the "Prim too few arguments" run-time error. When desugaring, the code will manually examine each (officially supported) prim and determine how many arguments were passed into it. If the number of arguments does not match the expected number of arguments, the desugaring phase will replace the call entirely with a raise call detailing the specifics. For example, if the desugarer were to see `(eq? 1 2 3 4)`, it would exclude that expression entirely and replace it with `(raise "ERROR: eq?  expected 2  given 4")`.
  * Tests:
    * toomanyprims
    * toomanyprimsguard


### Honor Pledge

I, Matthew Bock, pledge on my honor that I have not given or received any unauthorized assistance on this assignment.
