Written by Ted Weber on Feb. 5, 2017.

Parser and Interpreter for toy language 'PostFix'. This is a stack-based language defined in the textbook _Design Concepts in Programming Languages_, by Franklyn Turbak and David Gifford.  

USAGE:  

```
? - [interpreter].  

? - scan('filename', Tokens),parse(Tokens, AST),interpret(AST,[arguments]).  
```

NOTES: 

	• You only need to consult interpreter.pl to load all predicates.  
	
	• The result will be written to stdout as 'Result: _your result_', if given a valid postfix program. _arguments_ is assumed to be a valid list in Prolog. E.g. [1,2].  
	
	• I wanted the interpreter to handle negative integers, but it should be noted that the scanner tokenizes the strings '(postfix 0 -1)' and '(postfix 0 - 1)' as the same set of tokens. Thus, my parser will treat any unary '-' followed by an integer token (even with intermediate spaces) as a negative integer. Something like (postfix 0 - - 1) is invalid syntax.  
    
    • No modifications were made to scanner.pl, and the author is credited in the source.  

