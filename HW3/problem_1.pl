goldbach(4,[2,2]).
goldbach(N,T) :-
	N mod 2 =:= 0,
	N > 4,
	goldbach(N,T,3).
goldbach(N,[P1,P2],P1) :-
	P2 is N - P1,
	is_prime(P2),
	P2 @>= P1.
goldbach(N,T,P) :-
	P < N,
	next_prime(P,P1),
	goldbach(N,T,P1).

is_prime(2).
is_prime(3).
is_prime(P) :- 
	integer(P),
	P > 3,
	P mod 2 =\= 0,
	\+ has_factor(P,3).

has_factor(N,F) :-
	N mod F =:= 0.
has_factor(N,F) :-
	F * F < N,
	F2 is F + 2,
	has_factor(N,F2).

next_prime(P,Next) :-
	Next is P + 2,
	is_prime(Next),!.
next_prime(P,Next) :-
	P2 is P + 2, next_prime(P2,Next).

print_result(Input) :-
	writeln('Output: '),
	goldbach(Input,[P1 | [P2|_]]),
	write(P1), write(' '), write(P2), nl, fail.
print_result(_) :- halt.

main :- 
	write('Input: '),
	readln(Input),
	print_result(Input).

:- initialization(main).

