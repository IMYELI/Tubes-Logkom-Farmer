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

displayInventory2([], _).
displayInventory2([H|T], Index) :-
  inventory(H, Amount),
  format('%d. %s (Amount: %d)\n', [Index, H, Amount]),
  NIndex is Index + 1,
  displayInventory2(T, NIndex).

throwItem :-
  \+ inventoryList(_, _), write('There''s no item in your inventory.\n\n'), !;

  findall(Name, inventoryList(_, Name), Names),
  length(Names, Len),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity),
  format('========= Your Inventory %d/%d =========\n', [TotalAmount, Capacity]),
  displayInventory2(Names, 1), nl,
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
          throw(X, NInput), nl, nl;
   
          format('You don''t have that many %s!\n\n', [X])
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

displayInventory3([], _).
displayInventory3([H|T], Index) :-
  format('%d. %s\n', [Index, H]),
  NIndex is Index + 1,
  displayInventory3(T, NIndex).

unequip :-
  \+ equipment(_, _) -> write('You have nothing in your hand!\n\n'), !;

  retract(equipment(_, Tool)),
  add(Tool, 1),
  format('You unequip %s.\n\n', [Tool]).

equip :-
  \+ inventoryList(5, _), write('You don''t have any item worth to equip!\n\n'), !;

  findall(Name, inventoryList(5, Name), Names),
  length(Names, Len),
  write('What do you want to equip?\n'),
  displayInventory3(Names, 1), nl,
  write('>>> '),
  read(Input), nl,
  (
    integer(Input), Input > 0 , Input =< Len ->
      Index is Input - 1,
      nth0(Index, Names, X),
      item(_, X, Category),
      (
        equipment(_, Tool) ->
          retract(equipment(_, Tool)),
          add(Tool, 1);
        true
      ),
      throw(X, 1),
      assertz(equipment(Category, X)),
      format('You equip %s.\n\n', [X]);

    Input \== 'exit' -> write('Unknown input, try again!\n\n'), equip
  ).


displayItem(Names) :-
  (
    \+ inventoryList(_, _) -> write('You don''t have anything.\n');
    displayInventory1(Names)
  ).

isHoe1 :-
  equipment(hoe, _),
  toolList(hoe, ToolLvl, _),
  ToolLvl >= 1.

isHoe2 :-
  equipment(hoe, _),
  toolList(hoe, ToolLvl, _),
  ToolLvl >= 2.

isHoe3 :-
  equipment(hoe, _),
  toolList(hoe, ToolLvl, _),
  ToolLvl =:= 3.

isFishingRod1 :-
  equipment(rod, _),
  toolList(rod, ToolLvl, _),
  ToolLvl >= 1.

isFishingRod2 :-
  equipment(rod, _),
  toolList(rod, ToolLvl, _),
  ToolLvl >= 2.

isFishingRod3 :-
  equipment(rod, _),
  toolList(rod, ToolLvl, _),
  ToolLvl =:= 3.

displayInventory1([]).
displayInventory1([H|T]) :-
  inventory(H, Amount),
  format('- %d %s\n', [Amount, H]),
  displayInventory1(T).

displayEquipment :-
  (
    equipment(_, Tool) -> format('- %s', [Tool]);
    write('You don''t equip anything.')
  ), nl, nl.

inventory :-
  findall(Name, inventoryList(_, Name), Names),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity),
  format('========= Your Inventory %d/%d =========\n', [TotalAmount, Capacity]),
  write('========= Equipment =========\n'),
  displayEquipment,
  write('============ Item ===========\n'),
  displayItem(Names), nl.
