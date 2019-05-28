/* Read the input relationships */
read_relation(N):-
	N > 0,!,	% while N > 0
	read_string(user_input,"\n","",_,Line),	% Read the input line
	split_string(Line," ","",List),	% Split the two numbers by blank and put them into List
	List = [P_str,C_str],	% P is parent node, C is children node
	number_string(P,P_str),	% Convert the string to a number
	number_string(C,C_str),
	Fact =.. [parent,P,C],	% Fact : parent(P,C).
	assert(Fact),		% Assert the fact
	N1 is N - 1,		% N--
	read_relation(N1).	% Next iteration
read_relation(_) :-	% After finishing reading relationship, read M queries
	readln(M),	% Read the number of queries
	read_query(M,[]).	% M is the number of lines to read, 
				% [] is the list prepared to store result of all queries

/* A is ancestor, D is decendence */				
ancestor(A,D) :- parent(A,D).	% A is D's parent */
ancestor(A,D) :- 
	parent(X,D),	% X is D's parent AND
	ancestor(A,X).	% A is X's ancestor

/* A is the lowest common ancestor of D1 and D2 */
lca(A,D1,D2) :-
	D1==D2 -> A is D1;		% If the two nodes are same, lca is just itself
	ancestor(D1,D2) -> A is D1;	% Else if D1 is D2's ancestor, lca is D1 
	parent(X,D1),lca(A,X,D2).	% Else, X is D1's parent AND A is lca of X and D2 

/* Read the M lines of input query, L is a list for storing results of all queries*/
read_query(M,L):-
	M > 0,!,	% while M > 0
	read_string(user_input,"\n","\r",_,Line),	% Read the input line	
	split_string(Line," ","",List),	% Split the two numbers by blank and put them into List
	List = [D1_str,D2_str],	% D1 and D2 are nodes
	number_string(D1,D1_str),	% Convert the string to anumber
	number_string(D2,D2_str),
	lca(A,D1,D2),	% A is the lowest common ancestor of D1 and D2
	append(L,[A],L1),	% Append the result to a list for print out later
	M1 is M - 1,	% M--
	read_query(M1,L1).	% Next iteration
read_query(_,L) :-	% After finishing all queries, print the results of them
	length(L,Len),	% Len is the number of results
	writeln('Output: '),
	print_result(L,Len).
read_query(_,_).

/* Print the first element and take it out from the list each time */
print_result([Head | Tail], M) :-
	M > 0,!,
	writeln(Head),
	M1 is M - 1,
	print_result(Tail,M1).
print_result(_,_).

main :-
	writeln('Input: '),
	readln(N),	% Read the number of nodes
	read_relation(N-1),	% read the following n-1 lines of relationship
	halt.

:- initialization(main).

