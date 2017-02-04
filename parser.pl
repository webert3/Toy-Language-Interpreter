% includes
:- include('scanner.pl').

% Parser
%	Input: List of tokenized values returned from scanner.
%	Output: AST of the form [Num, [Commands]].
%%
parse(Tokens, AST) :- program(Tokens, [[punctuation,')'],[punctuation,eof]], AST).

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
%	Input: [H|T] - Token list
% 	Output: T - Rest of tokens
%%

open_brack([H|T], T) :- member('(',H).

% Checks for 'postfix' string.
%	Input: [H|T] - Token list
% 	Output: T - Rest of tokens
%%

postfix([H|T], T) :- member(postfix, H).

% Checks that an argument number is specified.
%	Input: [H|T] - Token list
% 	Output: T - Rest of tokens
%			NumArgs - Number of arguments.
%%

num_args([H|T], NumArgs, T) :- member(number,H),
								get_tail(H, NumArgs).
%%
% Helpers
%%

% Gets the tail of an ordered pair.
%	Input:  Pair - Pair [<token value>,<token>] 
% 	Output: Tail_Val - Value of second member.
%%

get_tail(Pair, Tail_Val) :- nth(2, Pair, Tail_Val).

% Get next token and the tokens following.
%%

get_next([H|T], H, T).