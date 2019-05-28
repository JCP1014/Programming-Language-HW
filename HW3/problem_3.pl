read_edge(E):-
	E > 0,!,
	read(N1),
	read(N2),
	Fact =.. [edge,N1,N2],
	assert(Fact),
	E2 is E - 1,
	read_edge(E2).
read_edge(_) :-
	read(M),
	read_query(M,[]).

reachable(N1,N2) :- 
	walk(N1,N2,[]).

walk(N1,N2,P) :-
	edge(N1,X),
	not(memberchk(X,P)),
	(N2 = X ; walk(X,N2,[N1|P])).

read_query(M,L) :-
	M > 0,!,
	read(N1),
	read(N2),
	(reachable(N1,N2) -> !,append(L,['Yes'],L2) ; !,append(L,['No'],L2)),
	M2 is M - 1,
	read_query(M2,L2).
read_query(_,L) :-
	length(L,Len),
	writeln('Output: '),
	print_result(L,Len).
read_query(_,_).

print_result([Head | Tail], M) :-
	M > 0,
	writeln(Head),
	M2 is M - 1,
	print_result(Tail,M2).	
print_result(_,_).


main :-
	write('Input: '),nl,
	read(_),
	read(E),
	read_edge(E),
	halt.

:- initialization(main).
