/* Deklarasi Rules */
addAnimal(_, 0).
addAnimal(Type, Count) :-
  animalID(ID),
  assertz(animal(ID, Type, 0)),
  NID is ID + 1,
  retract(animalID(_)),
  assertz(animalID(NID)),
  ( \+ animalList(Type) ->
    assertz(animalList(Type));
    true
  ),
  NCount is Count - 1,
  addAnimal(Type, NCount).

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
    ( Time = Production ->
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
        format('You got %d %s!', [Amount, NProdName]),
        add(NProdName, Amount),
        findall(NID, animal(NID, Type, _), NIDs),
        resetProd(NIDs)
      );
    format('Your %s haven''t %s any %s', [NType, ProdString, ProdName])
  ), nl, rancherMenu.

rancherMenu :-
  nl,
  write('======= Welcome To The Ranch ======='), nl,
  write('Your Animals: '), nl,
  findall(Type, animalList(Type), Types),
  length(Types, Len),
  displayAnimal(Types, 1),
  write('Choose the animals you want to check, exit. to go back.\n\n'),
  write('>>> '),
  catch(read(Input), error(_,_), errorMessage), (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, Types, X),
      findall(ID, animal(ID, X, _), IDs),
      animalInfo(IDs, X);
    Input \== 'exit' -> write('Unknown input, try again!'), nl, rancherMenu
  ).

