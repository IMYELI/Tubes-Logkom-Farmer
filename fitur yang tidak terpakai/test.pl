
%owa(Type, Production, Time)
owa(1, 'owa', 2, 2).
owa(2, 'owa', 2, 1).
owa(3, 'pee', 2, 2).
owa(4, 'pee', 2, 1).

displaySome([]).
displaySome([H|T]) :-
  write(H),
  displaySome(T).

oke :-
  findall(L, owa(_, L, _, _), List),
  displaySome(List).
