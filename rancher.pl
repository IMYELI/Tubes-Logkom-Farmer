/* Deklarasi Rules */

updateR([]).
updateR([H|T]) :-
  animal(H, AnimalType, Time),
  NTime is Time + 1,
  retract(animal(H, _, _)),
  assertz(animal(H, AnimalType, NTime)),
  updateR(T).

updateRanch :-
  \+ animal(ID, _, _), !;
  findall(ID, animal(ID, _, _), IDs),
  updateR(IDs).

addAnimal(_, 0).
addAnimal(AnimalType, Count) :-
  animalID(ID),
  assertz(animal(ID, AnimalType, 0)),
  NID is ID + 1,
  retract(animalID(_)),
  assertz(animalID(NID)),
  ( \+ animalList(AnimalType) ->
    assertz(animalList(AnimalType));
    true
  ), 
  NCount is Count - 1,
  addAnimal(AnimalType, NCount).

displayAnimal([], _).
displayAnimal([H|T], Index) :-
  findall(ID, animal(ID, H, _), IDs),
  length(IDs, Len),
  format('%d. %s (Amount: %d)\n', [Index, H, Len]),
  NIndex is Index + 1,
  displayAnimal(T, NIndex).

infoDetail([], 0).
infoDetail([H|T], Amount) :-
  animal(H, AnimalType, Time),
  production(AnimalType, ProductionTime),
  infoDetail(T, NAmount),
  (
    Time >= ProductionTime ->
      Amount is NAmount + 1;
    Amount is NAmount + 0
  ).

resetProd([]).
resetProd([H|T]) :-
    animal(H, AnimalType, Time),
    production(AnimalType, ProductionTime),
    (
      Time >= ProductionTime ->
      retract(animal(H, _, _)),
      assertz(animal(H, AnimalType, 0))
    ),
    resetProd(T).

animalInfo(IDs, AnimalType):-
  infoDetail(IDs, Amount),
  produceType(AnimalType, ProdName, ProdString),
  item(_, AnimalType, NAnimalType),
  (
    Amount > 0 ->
      format('Your %s %s %d %s\n', [NAnimalType, ProdString, Amount, ProdName]),
      (
        isInventoryFull(Amount) ->
        write('Your inventory is full!');
        
        item(_, NProdName, ProdName),
        format('You got %d %s!\n', [Amount, NProdName]),
        add(NProdName, Amount),
        addExpRanch(1),
        (
          goalQuest(ranch, Quest), Quest > 0 ->
            NQuest is Quest - 1,
            retract(goalQuest(ranch, _)),
            assertz(goalQuest(ranch, NQuest));
          true
        ),
        findall(NID, animal(NID, AnimalType, _), NIDs),
        resetProd(NIDs)
      );
    format('Your %s haven''t %s any %s', [NAnimalType, ProdString, ProdName])
  ), nl, nl, rancherMenu.

rancherMenu :-
  \+ animalList(_),
  write('You don''t have any animal in the ranch.\n\n');

  write('======= Welcome To The Ranch =======\n'),
  write('Choose the animals you want to check:\n'),
  write('Your Animals:\n'),
  write('0. Exit\n'),
  findall(AnimalType, animalList(AnimalType), AnimalTypes),
  length(AnimalTypes, Len),
  displayAnimal(AnimalTypes, 1), nl,
  write('>>> '),
  catch(read(Input), error(_,_), errorMessage), nl,
  (
    integer(Input), Input > 0, Input =< Len ->
      Index is Input - 1,
      nth0(Index, AnimalTypes, X),
      findall(ID, animal(ID, X, _), IDs),
      animalInfo(IDs, X);
    Input \== 0 -> write('Unknown input, try again!\n\n'), rancherMenu;
    write('You exited the Ranch, come back later!\n\n')
  ).

