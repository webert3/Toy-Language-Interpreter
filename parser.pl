% includes
:- include('scanner.pl').

% Parser
%	Input: List of tokenized values returned from scanner.
%	Output: True if valid syntax, false otherwise.

parse(Tokens) :- program(Tokens, []).

program(Tokens, Rest) :- open_brack(Tokens, T1), 
						postfix(T1, T2), 
						num_args(T2, NumArgs, T3),
						command_sequence(T3, Rest).


% check_args(NumArgs, Args, Rest).

% Checks for opening bracket
open_brack([H|T], T) :- member('(',H).

% Checks for 'postfix' 
postfix([H|T], T) :- member(postfix, H).

% Checks for a number of arguments specified.
	% Probably do not need NumArgs anymore
num_args([H|T], NumArgs, T) :- member(number,H),
								get_tail(H, NumArgs).

% Handles command sequences
command_sequence(List, Rest) :- command(List, List1),
								command_sequence(List1,Rest). 
command_sequence(List, List).


% Handles all valid command tokens.
command([H|T], T) :- member(number, H);
					member(add, H);
					member(sub, H);
					member(mul, H);
					member(div, H);
					member(rem, H);
					member(lt, H);
					member(eq, H);
					member(gt, H);
					member(pop, H);
					member(swap, H);
					member(sel, H);
					member(nget, H);
					member(exec, H).
command([H|T], Rest) :- member('(', H),
						command_sequence(T, Rest).
command([H|T], T) :- member(')', H).
command([H|T], T) :- member(eof, H).

% Helpers
get_tail([H|T], T).