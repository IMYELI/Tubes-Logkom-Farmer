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
  findall(Name, inventoryList(_, Name), Names),
  length(Names, Len),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity), nl,
  format('Your Inventory %d/%d\n', [TotalAmount, Capacity]),
  displayInventoryTwo(Names, 1),
  write('\nWhat do you want to throw?\n'),
  write('>>> '),
  catch(read(Input), error(_,_), _),
  (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, Names, X),
      inventory(X, Amount),
      format('\nYou have %d %s. How many do you want to throw?\n', [Amount, X]),
      write('>>> '),
      catch(read(NInput), error(_,_), _),
      (
        integer(NInput), NInput > 0, NInput =< Amount ->
        format('You threw away %d %s', [NInput, X]),
        throw(X, NInput);
   
        format('You don''t have that many %s! try again!\n', [X]), 
        throwItem
      );
    Input \== 'exit' -> write('Unknown input, try again!'), nl, throwItem
  ).

throw(Name, IN_Amount) :-
  inventory(Name, Amount),
  NewAmount is Amount - IN_Amount,
  retract(inventory(Name, _)), (
    NewAmount > 0 -> assertz(inventory(Name, NewAmount));
    retract(inventoryList(_, Name))
  ).

displayEquipment :-
  hoe(HoeLvl),
  toolList(1, HoeLvl, Hoe),
  rod(RodLvl),
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
  write('========= Equipment =========\n'),
  displayEquipment,
  format('========= Your Inventory %d/%d =========\n', [TotalAmount, Capacity]),
  displayInventory(Names), nl.
