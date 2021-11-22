:- dynamic(inventory/3).

/* Deklarasi Fakta */
/* inventoryCapacity(Capacity)*/
inventoryCapacity(100).

/* item(Category, Name, Othername) */
item(1, 'Carrot', carrot).
item(1, 'Potato', potato).
item(1, 'Strawberry', strawberry).
item(2, 'Cow', cow).
item(2, 'Chicken', chicken).
item(2, 'Sheep', sheep).
item(3, 'Milk', milk).
item(3, 'Egg', egg).
item(3, 'Wool', wool).
item(4, 'Carrot Seeds', carrot).
item(4, 'Potato Seeds', potato).
item(4, 'Strawberry Seeds', strawberry).

/* Category */
% 1 -> plants
% 2 -> animals
% 3 -> products
% 4 -> seeds
% 5 -> tools
% 6 -> misc

/* inventory(Category, Name, Amount) */
inventoryTotal([], 0).
inventoryTotal([H|T], TotalAmount) :-
  inventory(_, H, Amount),
  inventoryTotal(T, NewAmount),
  TotalAmount is Amount + NewAmount.

isInventoryFull(Amount) :-
  findall(Name, inventory(_, Name, _), Names),
  inventoryCapacity(Capacity),
  inventoryTotal(Names, TotalAmount),
  Amount + TotalAmount >= Capacity.

add(Name, IN_Amount) :-
  ( 
    inventory(Category, Name, Amount) ->
    NewAmount is Amount + IN_Amount,
    retract(inventory(_, Name, _)),
    assertz(inventory(Category, Name, NewAmount));
    
    item(Category, Name, _),
    assertz(inventory(Category, Name, IN_Amount))
  ),
  format('You got %d %s', [IN_Amount, Name]).


displayThrow([], _).
displayThrow([H|T], Index) :-
  inventory(_, H, Amount),
  format('%d. %d %s\n', [Index, Amount, H]),
  NIndex is Index + 1,
  displayThrow(T, NIndex).

throwItem :-
  findall(Name, inventory(_, Name, _), Names),
  length(Names, Len),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity), nl,
  format('Your Inventory %d/%d\n', [TotalAmount, Capacity]),
  displayThrow(Names, 1),
  write('\nWhat do you want to throw?\n'),
  write('>>> '),
  catch(read(Input), error(_,_), errorMessage),
  (
    integer(Input), Input > 0 , Input =< Len -> 
      Index is Input - 1,
      nth0(Index, Names, X),
      inventory(_, X, Amount),
      format('\nYou have %d %s. How many do you want to throw?\n', [Amount, X]),
      write('>>> '),
      catch(read(NInput), error(_,_), errorMessage),
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
  inventory(Category, Name, Amount),
  NewAmount is Amount - IN_Amount,
  retract(inventory(_, Name, _)), (
    NewAmount > 0 -> assertz(inventory(Category, Name, NewAmount))
  ).

displayInventory([]).
displayInventory([H|T]) :-
  inventory(_, H, Amount),
  format('- %d %s\n', [Amount, H]),
  displayInventory(T).


inventory :-
  findall(Name, inventory(_, Name, _), Names),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity), nl,
  format('Your Inventory %d/%d\n', [TotalAmount, Capacity]),
  displayInventory(Names).
