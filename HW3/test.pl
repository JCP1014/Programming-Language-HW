read_input(N) :-
	N > 0,
	read_string(user_input,"\n","\r",_,Line),
	split_string(Line," ","",L),
	writeln(L),
	N2 is N - 1,
	read_input(N2).

/*process_input(Line) :-
	string(Line),
	atom_number(Line, N),
	integer(N),
	writeln(Line),
	fail.*/
/*process_input("quit") :-
	writeln('Finished'),
	!,true.*/

main :- readln(N),
	read_input(N),
	halt.

:- initialization(main).
