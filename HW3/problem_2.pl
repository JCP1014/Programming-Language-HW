read_relation(N):-
	N > 0,!,
	read(P),
	read(C),
	Fact =.. [parent,P,C],
	assert(Fact),
	N2 is N - 1,
	read_relation(N2).
read_relation(_) :-
	read(M),
	read_query(M,[]).
read_relation(_).

ancestor(A,D) :- parent(A,D).
ancestor(A,D) :- 
	parent(X,D),
	ancestor(A,X).

lca(A,D1,D2) :-
	D1==D2 -> A is D1;
	ancestor(D1,D2) -> A is D1;
	parent(X,D1),lca(A,X,D2).

read_query(M,L):-
	M > 0,!,
	read(D1),
	read(D2),
	lca(A,D1,D2),
	append(L,[A],L2),
	M2 is M - 1,
	read_query(M2,L2).
read_query(_,L) :-
	length(L,Len),
	write('Output: '),nl,
	print_result(L,Len).
read_query(_,_).

print_result([Head | Tail], M) :-
	M > 0,!,
	write(Head),nl,
	M2 is M - 1,
	print_result(Tail,M2).
prnit_result(_,_).

main :-
	write('Input: '),nl,
	read(N),
	read_relation(N-1),
	halt.

:- initialization(main).

