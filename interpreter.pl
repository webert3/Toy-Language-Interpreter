:- include('parser.pl').
%%
% NOTES:
% Use nth, number, length, and isList builtins
% PROLOG doesnt use integer divide for your normal divide command. Use 'div' builtin
% NOTE IN README:
%	- You can include command sequences as arguments, but they must be in a nested list '[' ']'
%	- Mention that the interpret rule implicitly print the result.
%%

% Reads from AST, and interpets the code. Prints result.
%	Input: [NumArgs|AST] - AST, split to differentiate the Number of Arguments and the
%						   list of commands (AST).
%		   Args - Arguments input by the user.
% 	Output: Result will be printed to stdout.
%%

interpret([NumArgs|AST], Args) :- length(Args, NumArgs),
									process_commands(AST, Args, Result),
									write(Result).

% Processes postfix comands until AST is empty.
%	Input: Commands - List of commands to be executed.
%		   Stack - It is the stack...
% 	Output: Result will contain the top element on the stack if it is numeric.
%%

process_commands(Commands, Stack, Result) :- execute_command(Commands,Stack,Result). 

% Return stack head as the result IF it is a number.
process_commands([], [Stack_Head|Stack_Rest], Stack_Head) :- number(Stack_Head). 

% Logic for the execution of each command in Postfix.
%	Input:  [Command|Rest] - Splitting command list.
%			Stack1 - The initial stack.
%			Rest - Following commands in sequence.
%%

% exec
execute_command([Command|Rest], Stack1, Rest) :- (Command == exec),
	pop(Stack1, Val1, Stack2),
	is_list(Val1),
	append(Val1, Rest, NewRest),
	process_commands(NewRest, Stack2, Result).

% number
execute_command([Command|Rest], Stack1, Result) :- number(Command),
	push(Stack1, Command, Stack2),
	process_commands(Rest, Stack2, Result).

% add
execute_command([Command|Rest], Stack1, Result) :- (Command == add),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	is(Sum, Val2 + Val1),
	push(Stack3, Sum, Stack4),
	process_commands(Rest, Stack4, Result).

% sub
execute_command([Command|Rest], Stack1, Result) :- (Command == sub),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	is(Difference, Val2 - Val1),
	push(Stack3, Difference, Stack4),
	process_commands(Rest, Stack4, Result).

% mul
execute_command([Command|Rest], Stack1, Result) :- (Command == mul),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	is(Product, Val2 * Val1),
	push(Stack3, Product, Stack4),
	process_commands(Rest, Stack4, Result).

% div
execute_command([Command|Rest], Stack1, Result) :- (Command == div),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	is(Dividend, Val2 // Val1),
	push(Stack3, Dividend, Stack4),
	process_commands(Rest, Stack4, Result).

% rem (NOTE: rem is a builtin for gprolog... so I had to 
%			 use member/2 to avoid a prolog syntax error ).
execute_command([Command|Rest], Stack1, Result) :- member(Command,[rem]),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	is(Remainder, Val2 rem Val1),
	push(Stack3, Remainder, Stack4),
	process_commands(Rest, Stack4, Result).

% lt
execute_command([Command|Rest], Stack1, Result) :- (Command == lt),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	lt(Bool, Val2, Val1),
	push(Stack3, Bool, Stack4),
	process_commands(Rest, Stack4, Result).

% gt
execute_command([Command|Rest], Stack1, Result) :- (Command == gt),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	gt(Bool, Val2, Val1),
	push(Stack3, Bool, Stack4),
	process_commands(Rest, Stack4, Result).

% eq
execute_command([Command|Rest], Stack1, Result) :- (Command == eq),
	pop(Stack1,Val1,Stack2),
	number(Val1),
	pop(Stack2,Val2,Stack3),
	number(Val2),
	eq(Bool, Val2, Val1),
	push(Stack3, Bool, Stack4),
	process_commands(Rest, Stack4, Result).



% Push and Pop functions
%%

push(Stack, Val, [Val|Stack]).
pop([H|T], H, T). 

%%
% Helpers
%%

% Check if element is a list.
%%

is_list([_|_]).
is_list([]).

% Less than, returns 1 if true, 0 otherwise.
%%
lt(1, Val2, Val1) :- (Val2 < Val1).
lt(0, Val2, Val1) :- (Val2 >= Val1).

% Equal to, returns 1 if true, 0 otherwise.
%%
gt(1, Val2, Val1) :- (Val2 > Val1).
gt(0, Val2, Val1) :- (Val2 =< Val1).

% Equal to, returns 1 if true, 0 otherwise.
%%
eq(1, Val2, Val1) :- (Val2 =:= Val1).
eq(0, Val2, Val1) :- (Val2 =\= Val1).

