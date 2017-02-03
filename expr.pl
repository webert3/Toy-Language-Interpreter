
%%%%
% The CFG
%%%%
% Expr → Term ExprCont
% ExprCont → + Term ExprCont
% ExprCont → - Term ExprCont
% ExprCont → λ
% Term → Factor TermCont
% TermCont → * Factor TermCont
% TermCont → / Factor TermCont
% TermCont → λ
% Factor → ( Expr )
% Factor → identifier

%%%%
% Translated into prolog
%%%%

parse(Tokens) :- expr(Tokens, []).
expr(T, T2) :- term(T, T1), exprCont(T1, T2).
exprCont(['+' | T], T2) :- term(T, T1), exprCont(T1, T2).
exprCont(['-' | T], T2) :- term(T, T1), exprCont(T1, T2).
exprCont(T, T).
term(T, T2) :- factor(T, T1), termCont(T1, T2).
termCont(['*' | T], T2) :- term(T, T1), termCont(T1, T2).
termCont(['/' | T], T2) :- term(T, T1), termCont(T1, T2).
termCont(T, T).
factor(['('|T], T1) :- expr(T, [')'|T1]).
factor(['-'|T], T1) :- factor(T, T1).
factor(['id'|T], T).
factor(['num'|T], T).

%%%%
% Working with lists
%%%%
member1(X, [X|T]).
member1(X,[X|_]),!.
member1(X, [H|T]) :- member1(X, T).

append1([], A, A).
append1([H | T], A, [H | L]) :- append1(T, A, L).

not(P).
not(P) :- P, !, Fail.
