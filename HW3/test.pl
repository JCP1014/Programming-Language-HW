move(1,X,Y,_) :-
	write('Move top disk from '), write(X), write(' to '), write(Y), nl.
move(N,X,Y,Z) :-
	N > 1, M is N - 1, move(M,X,Z,Y), move(1,X,Y,_), move(M,Z,Y,X).

is_prime(2).
is_prime(3).
is_prime(P) :- 
	integer(P),
	P > 3,
	P mod 2 =\= 0,
	\+ has_factor(P,3).
has_factor(N,F) :-
	N mod F =:= 0.

main :- move(3,left,right,center),
	is_prime(7),
	halt.

:- initialization(main).
