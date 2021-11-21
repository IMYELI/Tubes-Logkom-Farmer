:- dynamic(animal/4).
:- dynamic(animalAmount/2).
:- include('inventory.pl').

%produceType(Type, SmallName, ProdName, ProdString)
produceType('Cow', milk, produce).
produceType('Chicken', egg, lay).
produceType('Sheep', wool, produce).

%lowerCase(Type, Lower)
lowerCase('Cow', cow).
lowerCase('Chicken', chicken).
lowerCase('Sheep', sheep).

%upperCase(Type, Upper)
upperCase(egg, 'Egg').
upperCase(wool, 'Wool').
upperCase(milk, 'Milk').

%animal(ID, Type, Name, Time, Production)
animal('Cow', 'Jonathan', 3, 3).
animal('Cow', 'Sooka', 3, 3).
animal('Chicken', 'Choco', 3, 3).
animal('Sheep', 'Monka', 3, 3).

displayAnimal([], _).
displayAnimal([H|T], Index) :-
  findall(Name, animal(H, Name, _, _), Names),
  length(Names, Len),
  format('%d. %s, Amount: %d\n', [Index, H, Len]),
  NIndex is Index + 1,
  displayAnimal(T, NIndex).

infoDetail([], 0).
infoDetail([H|T], Amount) :-
  animal(_, H, Time, Production),
  infoDetail(T, NAmount),
  (
    Time = Production ->
      Amount is NAmount + 1;
    Amount is NAmount + 0
  ).


resetProd([]).
resetProd([H|T]) :-
    animal(Type, H, T, P),
    retract(animal(_, H, _, _)),
    assertz(animal(Type, H, 0, P)),
    resetProd(T).

animalInfo(Names, Type):-
  infoDetail(Names, Amount),
  produceType(Type, ProdName, ProdString),
  lowerCase(Type, NType),
  upperCase(ProdName, NProdName), nl,
  (
    Amount > 0 ->
      format('Your %s %s %d %s\n', [NType, ProdString, Amount, ProdName]),
      (
        isInventoryFull(Amount) ->
        write('Your inventory is full!');
        
        add(NProdName, Amount),
        findall(A, animal(Type, A, X, X), AA),
        resetProd(AA)
      );
    format('Your %s haven''t %s any %s\n', [NType, ProdString, ProdName])
  ), nl, rancherMenu.

rancherMenu :-
  nl,
  write('======= Welcome To The Ranch ======='), nl,
  write('Your Animals: '), nl,
  findall(Type, animal(Type, _, _, _), Types),
  set(Types, NTypes),
  length(NTypes, Len),
  displayAnimal(NTypes, 1),
  write('Choose the animals you want to check, exit. to go back.\n\n'),
  write('>>> '),
  catch(read(Input), error(_,_), errorMessage), (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, NTypes, Type),
      findall(Name, animal(Type, Name, _, _), Names),
      animalInfo(Names, Type);
    Input \== 'exit' -> write('Unknown input, try again!'), nl, rancherMenu
  ).

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.


set([], []).
set([H|T], [H|T1]) :- 
    remv(H, T, T2),
    set(T2, T1).
remv(_, [], []).
remv(X, [X|T], T1) :- remv(X, T, T1).
remv(X, [H|T], [H|T1]) :-
    X \= H,
    remv(X, T, T1).