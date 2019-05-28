/* Read E lines of input edges */
read_edge(E):-	
	E > 0,!,	% while E > 0
	read_string(user_input,"\n","",_,Line),
	split_string(Line," ","",List),
	List = [N1_str,N2_str],	% N1 and N2 are the two nodes connected by the edge
	number_string(N1,N1_str),
	number_string(N2,N2_str),
	Fact =.. [edge,N1,N2],	% Fact : edge(N1,N2)
	assert(Fact),	% Assert the fact
	E1 is E - 1,	% E--
	read_edge(E1).	% Next iteration
read_edge(_) :-		% After finishing reading edges, read M queries
	readln(M),	% M is number of queries
	read_query(M,[]).	% [] is a list for storing results of all queries later

/* N1 and N2 are connected */
reachable(N1,N2) :- 
	walk(N1,N2,[]). % Can walk from N1 to N2,
			% [] is a list for recording the nodes on the path later

/* Can walk from N1 to N2, P is a list of nodes on the path */
walk(N1,N2,P) :-
	edge(N1,X),	% There is an edge between N1 and X AND
	not(memberchk(X,P)),	% X has not been visited AND
	(X = N2 ; walk(X,N2,[N1|P])).	% Either X is just the destination, 
					% Or can walk to it from X

/* Read the M lines of input query, and store result of all queries in L */
read_query(M,L) :-
	M > 0,!,	% while M > 0
	read_string(user_input,"\n","",_,Line),
	split_string(Line," ","",List),
	List = [N1_str,N2_str],	% N1 and N2 are the two nodes to ask whether they are connected
	number_string(N1,N1_str),
	number_string(N2,N2_str),
	(reachable(N1,N2) -> !,append(L,['Yes'],L1) ; !,append(L,['No'],L1)),	% If N1 and N2 are connected, append 'Yes'
										% Else, append 'No' to the list
	M1 is M - 1,		% M--
	read_query(M1,L1).	% Next iteration
read_query(_,L) :-	% After finishing all queries, print the results of them
	length(L,Len),	% Len is the number of results
	writeln('Output: '),
	print_result(L,Len).
read_query(_,_).

/* Print the first element and remove it from the list each iteration */
print_result([Head | Tail], M) :-
	M > 0,
	writeln(Head),
	M1 is M - 1,
	print_result(Tail,M1).	
print_result(_,_).	% After finishing printing, go back to main


main :-
	writeln('Input: '),
	read_string(user_input,"\n","",_,Line),	% Read first line of input
	split_string(Line," ","",List),	% Split the two numbers by blank and store them in List
	List = [_,E_str],	% _ is number of nodes, E is number of edges
	number_string(E,E_str),	% Convert the string to number
	read_edge(E),	% Read the follwing E lines of edges
	halt.

:- initialization(main).
