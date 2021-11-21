:- dynamic(inventory/3).

/* Deklarasi Fakta */
/* inventoryCapacity(Capacity)*/
inventoryCapacity(100).

/* item(Category, Name) */
item(1, 'Carrot').
item(1, 'Potato').
item(1, 'Strawberry').
item(2, 'Cow').
item(2, 'Chicken').
item(2, 'Sheep').
item(3, 'Milk').
item(3, 'Egg').
item(3, 'Wool').

/* Category */
% 1 -> plants
% 2 -> animals
% 3 -> products
% 4 -> tools
% 5 -> misc

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
    
    item(Category, Name),
    assertz(inventory(Category, Name, IN_Amount))
  ),
  format('You got %d %s', [IN_Amount, Name]).
  

throw(Name, IN_Amount) :-
  inventory(Category, Name, Amount),
  NewAmount is Amount - IN_Amount,
  retract(inventory(_, Name, _)), (
    NewAmount > 0 -> assertz(inventory(Category, Name, NewAmount))
  ).

displayInventory([]).
displayInventory([H|T]) :-
  inventory(_, H, Amount),
  write(Amount), write(' '), write(H), nl,
  displayInventory(T).

inventory :-
  findall(Name, inventory(_, Name, _), Names),
  inventoryTotal(Names, TotalAmount),
  inventoryCapacity(Capacity), nl,
  format('Your Inventory %d/%d\n', [TotalAmount, Capacity]),
  displayInventory(Names).
