:- include('parser.pl').
interpret([NumArgs|AST], Input) :- length(NumArgs, Input).





% Push and Pop functions
%%

push(Stack, Val, [Val|Stack]).
pop([H|T],H, T). 