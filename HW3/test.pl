goldbach(4,[2,2]).
main :- 
	write('Input: '),
	readln(Input),
	goldbach(Input,Output),
	write(Output),
	halt.

:- initialization(main).

