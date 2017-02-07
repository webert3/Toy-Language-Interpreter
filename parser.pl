% includes
:- include('scanner.pl').

% Parser
%	Input:  Tokens - List of tokenized values returned from scanner.
%	Output: AST - AST of the form [Num, [Commands]].
%%

parse(Tokens, AST) :- program(Tokens, [[punctuation,')'],[punctuation,eof]], AST).

% Checks for valid beginning tokens, then calls command_sequence to build AST.
%%

program(Tokens, Rest, [NumArgs|AST]) :- open_brack(Tokens, T1), 
						postfix(T1, T2), 
						num_args(T2, NumArgs, T3),
						command_sequence(T3, AST, Rest).


% Handles command sequences
%	Input: List - Token list
%		   [AST_Head | AST_Tail] - AST, split to allow for values to be appended recursively.
% 	Output: Rest - Rest of tokens
%%

command_sequence(List, [AST_Head|AST_Tail], Rest) :- command(List, AST_Head, List1),
													command_sequence(List1,AST_Tail,Rest).
command_sequence(List, [], List). 


% Handles all valid command tokens.
%	Input: [H|T] - Token list
%		   AST_Head - Value to be appended to AST
% 	Output: T - Rest of tokens
%%

command([H|T], AST_Head, T) :- member(number, H),get_tail(H,AST_Head);
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

% Case for command sequence.
command([[punctuation,'(']|T], AST_Head, Rest) :- command_sequence(T, AST_Head, [[punctuation,')']|Rest]).

% Case for negative integer
command([H|T], AST_Head, New_T) :- member(-, H),
								get_next(T, New_H, New_T),
								member(number, New_H),
								get_tail(New_H,New_AST_Head),
								is(AST_Head, -1 * New_AST_Head).

% Checks for opening bracket.
%%

open_brack([H|T], T) :- member('(',H).

% Checks for 'postfix' string.
%%

postfix([H|T], T) :- member(postfix, H).

% Checks that an argument number is specified and returns as NumArgs.
%%

num_args([H|T], NumArgs, T) :- member(number,H),
								get_tail(H, NumArgs).


% Helpers:

% Gets the second element of an ordered pair.
%%

get_tail(Pair, Tail_Val) :- nth(2, Pair, Tail_Val).

% Gets next token and the tokens following.
%%

get_next([H|T], H, T).