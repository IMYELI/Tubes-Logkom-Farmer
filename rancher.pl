:- dynamic(animal/3).
:- dynamic(animalAmount/2).
:- dynamic(animalID/1).
:- dynamic(animalList/1).

:- include('inventory.pl').

/* Deklarasi Fakta */
%produceType(Type, SmallName, ProdName, ProdString)
produceType('Cow', milk, produce).
produceType('Chicken', egg, lay).
produceType('Sheep', wool, produce).

%production(Type, Production)
production('Cow', 4).
production('Chicken', 3).
production('Sheep', 4).

%animal(ID, Type, Time)
animal(1, 'Cow', 4).
animal(2, 'Cow', 4).
animal(3, 'Chicken', 3).
animal(4, 'Sheep', 4).

%animalList(Type)
%animalID(ID)
animalID(1).


/* Deklarasi Rules */
addAnimal(Type):-
  animalID(ID),
  assertz(ID, Type, 0),
  NID is ID + 1,
  retract(animalID(_)),
  assertz(animalID(NID)), 
  (
    \+ animalList(Type) ->
    assertz(animalList(Type)) 
  ).


displayAnimal([], _).
displayAnimal([H|T], Index) :-
  findall(ID, animal(ID, H, _), IDs),
  length(IDs, Len),
  format('%d. %s, Amount: %d\n', [Index, H, Len]),
  NIndex is Index + 1,
  displayAnimal(T, NIndex).

infoDetail([], 0).
infoDetail([H|T], Amount) :-
  animal(H, Type, Time),
  production(Type, Production),
  infoDetail(T, NAmount),
  (
    Time = Production ->
      Amount is NAmount + 1;
    Amount is NAmount + 0
  ).

resetProd([]).
resetProd([H|T]) :-
    animal(H, Type, Time),
    production(Type, Production),
    (
    Time = Production ->
    retract(animal(H, _, _)),
    assertz(animal(H, Type, 0))
    ),
    resetProd(T).

animalInfo(IDs, Type):-
  infoDetail(IDs, Amount),
  produceType(Type, ProdName, ProdString),
  item(_, Type, NType), 
  nl,
  (
    Amount > 0 ->
      format('Your %s %s %d %s\n', [NType, ProdString, Amount, ProdName]),
      (
        isInventoryFull(Amount) ->
        write('Your inventory is full!');
        
        item(_, NProdName, ProdName),
        add(NProdName, Amount),
        findall(NID, animal(NID, Type, _), NIDs),
        resetProd(NIDs)
      );
    format('Your %s haven''t %s any %s\n', [NType, ProdString, ProdName])
  ), nl, rancherMenu.

rancherMenu :-
  nl,
  write('======= Welcome To The Ranch ======='), nl,
  write('Your Animals: '), nl,
  findall(Type, animal(_, Type, _), Types),
  set(Types, NTypes),
  length(NTypes, Len),
  displayAnimal(NTypes, 1),
  write('Choose the animals you want to check, exit. to go back.\n\n'),
  write('>>> '),
  catch(read(Input), error(_,_), errorMessage), (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, NTypes, X),
      findall(ID, animal(ID, X, _), IDs),
      animalInfo(IDs, X);
    Input \== 'exit' -> write('Unknown input, try again!'), nl, rancherMenu
  ).

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
