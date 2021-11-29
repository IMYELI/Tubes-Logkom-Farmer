inventoryTotal([], 0).
inventoryTotal([H|T], TotalAmount) :-
  inventory(H, Amount),
  inventoryTotal(T, NewAmount),
  TotalAmount is Amount + NewAmount.

isInventoryFull(Amount) :-
  findall(Name, inventory(Name, _), Names),
  inventoryCapacity(Capacity),
  inventoryTotal(Names, TotalAmount),
  Amount + TotalAmount > Capacity.

add(Name, IN_Amount) :-
  ( 
    inventoryList(_, Name) ->
    inventory(Name, Amount),
    NewAmount is Amount + IN_Amount,
    retract(inventory(Name, _)),
    assertz(inventory(Name, NewAmount));
    
    item(Category, Name, _),
    assertz(inventoryList(Category, Name)),
    assertz(inventory(Name, IN_Amount))
  ).


displayInventoryTwo([], _).
displayInventoryTwo([H|T], Index) :-
  inventory(H, Amount),
  format('%d. %d %s\n', [Index, Amount, H]),
  NIndex is Index + 1,
  displayInventoryTwo(T, NIndex).

throwItem :-
  \+ inventoryList(_, _), write('There''s no item in your inventory.\n\n'), !;

  findall(Name, inventoryList(_, Name), Names),
  length(Names, Len),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity),
  format('========= Your Inventory %d/%d =========\n', [TotalAmount, Capacity]),
  displayInventoryTwo(Names, 1), nl,
  write('What do you want to throw?\n'),
  write('>>> '),
  catch(read(Input), error(_,_), _), nl,
  (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, Names, X),
      inventory(X, Amount),
      format('You have %d %s. How many do you want to throw?\n', [Amount, X]),
      write('>>> '),
      catch(read(NInput), error(_,_), _), nl,
      (
        integer(NInput), NInput > 0, NInput =< Amount ->
          format('You threw away %d %s!', [NInput, X]),
          throw(X, NInput), nl, nl, throwItem;
   
          format('You don''t have that many %s!\n\n', [X]),
          throwItem
      );
    Input \== 'exit' -> write('Unknown input, try again!\n\n'), throwItem
  ).

throw(Name, IN_Amount) :-
  inventory(Name, Amount),
  NewAmount is Amount - IN_Amount,
  retract(inventory(Name, _)), (
    NewAmount > 0 -> assertz(inventory(Name, NewAmount));
    retract(inventoryList(_, Name))
  ).

displayEquipment :-
  toolLevel(1, HoeLvl, _),
  toolList(1, HoeLvl, Hoe),
  toolLevel(2, RodLvl, _),
  toolList(2, RodLvl, Rod),
  format('- %s\n', [Hoe]),
  format('- %s\n', [Rod]).

displayInventory([]).
displayInventory([H|T]) :-
  inventory(H, Amount),
  format('- %d %s\n', [Amount, H]),
  displayInventory(T).

inventory :-
  findall(Name, inventoryList(_, Name), Names),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity),
  format('========= Your Inventory %d/%d =========\n', [TotalAmount, Capacity]),
  write('========= Equipment =========\n'),
  displayEquipment,
  write('============ Item ===========\n'),
  displayInventory(Names), nl.
