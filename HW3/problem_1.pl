goldbach(4,[2,2]).	% Define the fact that 4 is composed of 2 + 2
goldbach(N,T) :-	% N is the number tested, T is the tuple compose N
	N mod 2 =:= 0,	% Even number AND
	N > 4,		% Greater than 4
	goldbach(N,T,3).	% Test from 3
goldbach(N,[P1,P2],P1) :-
	P2 is N - P1,	% P2 and P1 compose N AND
	is_prime(P2),	% P2 is a prime AND
	P2 @>= P1.	% P2 is the larger one
goldbach(N,T,P) :-
	P < N,		% P is a component of N, so it must be smaller than N
	next_prime(P,P1),	% Find next prime P1
	goldbach(N,T,P1).	% Find next possible tuple

is_prime(2).
is_prime(3).	
is_prime(P) :-
	integer(P),	% Is a integer AND
	P > 3,		% Greater than 3 AND
	P mod 2 =\= 0,	% Not an even number AND
	\+ has_factor(P,3).	% Does not have factor >= 3

/* N has a factor F */
has_factor(N,F) :-	
	N mod F =:= 0.	% N is devisible by F
has_factor(N,F) :-
	F * F < N,	% Test until sqrt(N)
	F2 is F + 2,	% Skip even numbers
	has_factor(N,F2).	% Next test

/* Find next prime */
next_prime(P,Next) :-  
	Next is P + 2,		% Test next odd number
	is_prime(Next),!.	% Cut to avoid tracing back when fail
next_prime(P,Next) :-
	P1 is P + 2, 
	next_prime(P1,Next).	% Next test

print_result(Input) :-
	writeln('Output: '),
	goldbach(Input,[P1,P2]),
	write(P1), write(' '), write(P2), nl,fail.
print_result(_).


main :- 
	write('Input: '),
	read_string(user_input,"\n","",_,Line),
	number_string(Input,Line),
	print_result(Input),halt.

:- initialization(main).
