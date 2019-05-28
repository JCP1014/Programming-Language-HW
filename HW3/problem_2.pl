read_relation(N):-
	N > 0,!,
	read_string(user_input,"\n","",_,Line),
	split_string(Line," ","",List),
	List = [P_str | Tail],
	Tail =  [C_str | _],
	number_string(P,P_str),
	number_string(C,C_str),
	Fact =.. [parent,P,C],
	assert(Fact),
	N2 is N - 1,
	read_relation(N2).
read_relation(_) :-
	readln(M),
	read_query(M,[]).

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
	read_string(user_input,"\n","\r",_,Line),
	split_string(Line," ","",List),
	List = [D1_str | Tail],
	Tail =  [D2_str | _],
	number_string(D1,D1_str),
	number_string(D2,D2_str),
	lca(A,D1,D2),
	append(L,[A],L2),
	M2 is M - 1,
	read_query(M2,L2).
read_query(_,L) :-
	length(L,Len),
	writeln('Output: '),
	print_result(L,Len).
read_query(_,_).

print_result([Head | Tail], M) :-
	M > 0,!,
	writeln(Head),
	M2 is M - 1,
	print_result(Tail,M2).
prnit_result(_,_).

main :-
	writeln('Input: '),
	readln(N),
	read_relation(N-1),halt.

:- initialization(main).

