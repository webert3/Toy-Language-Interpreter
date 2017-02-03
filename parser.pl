% includes
:- include('scanner.pl').

% Parser
%	Input: List of tokenized values returned from scanner.
%	Returns: AST of the form [Num, [Commands]].
%%
parse(Tokens, AST) :- program(Tokens, [[punctuation,')'],[punctuation,eof]], AST).

program(Tokens, Rest, [NumArgs|AST]) :- open_brack(Tokens, T1), 
						postfix(T1, T2), 
						num_args(T2, NumArgs, T3),
						command_sequence(T3, AST, Rest).


% Handles command sequences
%%
command_sequence(List, [AST_Head|AST_Tail], Rest) :- command(List, AST_Head, List1),write(AST_Head),nl,
													command_sequence(List1,AST_Tail,Rest).
command_sequence(List, AST, List). 

% Handles all valid command tokens.
%%
command([H|T],AST_Head, T) :- member(number, H),get_tail(H,AST_Head);
					member(add, H),get_tail(H,AST_Head);
					member(sub, H),get_tail(H,AST_Head);
					member(mul, H),get_tail(H,AST_Head);
					member(div, H),get_tail(H,AST_Head);
					member(rem, H),get_tail(H,AST_Head);
					member(lt, H),get_tail(H,AST_Head);
					member(eq, H),get_tail(H,AST_Head);
					member(gt, H),get_tail(H,AST_Head);
					member(pop, H),get_tail(H,AST_Head);
					member(swap, H),get_tail(H,AST_Head);
					member(sel, H),get_tail(H,AST_Head);
					member(nget, H),get_tail(H,AST_Head);
					member(exec, H),get_tail(H,AST_Head).
command([[punctuation,'(']|T], Rest) :- command_sequence(T, [[punctuation,')']|Rest]).

% Checks for opening bracket
%%
open_brack([H|T], T) :- member('(',H).

% Checks for 'postfix' 
%%
postfix([H|T], T) :- member(postfix, H).

% Checks that an argument number is specified.
%	Input: Token list
% 	Output: Rest of tokens
%			Number of arguments.
%%
num_args([H|T], NumArgs, T) :- member(number,H),
								get_tail(H, NumArgs).

% Helpers

get_tail([H|T], T).

% Use nth1, and is list builtin
