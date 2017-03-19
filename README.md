Written by Ted Weber on Feb. 5, 2017.
CSCI 512 - Assignment 1
Parser and Interpreter for toy language 'PostFix'. This language is defined in the textbook Design Concepts in Programming Languages, by Franklyn Turbak and David Gifford.

USAGE:
`
? - [interpreter].
? - scan('<filname>', Tokens),parse(Tokens, AST),interpret(AST,[<arguments>]).
`
NOTES:
	- You only need to consult interpreter.pl to load all predicates.
	- The result will be written to stdout as 'Result: <your result>', if given a
	  valid postfix program.
    - <arguments> is assumed to be a valid list in Prolog. E.g. [1,2].
	- I wanted the interpreter to handle negative integers, but it should be noted
	  that the scanner will tokenize the strings '(postfix 0 -1)' and '(postfix 0 -
	  1)' as the same set of tokens. Thus, my parser will treat any unary '-' followed
	  by an integer token (even with intermediate spaces) as a negative integer.
	  Something like (postfix 0 - - 1) is invalid.
    - No modifications were made to scanner.pl. Should be the same as the file
      uploaded on canvas.
