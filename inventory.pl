:- dynamic(inventory/4).

/* Deklarasi Fakta */
/* inventoryCapacity(Capacity)*/
inventoryCapacity(100).

/* item(ID, Category, Name) */
item(1, 1, 'Carrot').
item(2, 1, 'Potato').
item(3, 1, 'Strawberry').

/* Category */
% 1 -> plants
% 2 -> tools
% 3 -> misc



/* inventory(ID, Category, Name, Amount) */
inventoryTotal([], 0).
inventoryTotal([HeadID|TailID], TotalAmount) :-
  inventory(HeadID, _, _, Amount),
  inventoryTotal(TailID, NewAmount),
  TotalAmount is Amount + NewAmount.

isInventoryFull :-
  findall(ID, inventory(ID, _, _, _), IDs),
  inventoryCapacity(Capacity),
  inventoryTotal(IDs, TotalAmount),
  TotalAmount =:= Capacity.

isInventoryPartiallyFull(Amount) :-
  findall(ID, inventory(ID, _, _, _), IDs),
  inventoryCapacity(Capacity),
  inventoryTotal(IDs, TotalAmount),
  Amount + TotalAmount >= Capacity.

add(ID, ID_Amount) :-
  isInventoryFull,
  write('Inventory is Full!'), nl, !;

  inventory(ID, Category, Name, Amount),
  NewAmount is Amount + ID_Amount,
  retract(inventory(ID, _, _, _)),
  asserta(inventory(ID, Category, Name, NewAmount)), !;

  item(ID, Category, Name),
  asserta(inventory(ID, Category, Name, ID_Amount)).

throw(ID, ID_Amount) :-
  inventory(ID, Category, Name, Amount),
  NewAmount is Amount - ID_Amount,
  retract(inventory(ID, _, _, _)), (
    NewAmount > 0 -> asserta(inventory(ID, Category, Name, NewAmount))
  ).

displayInventory([]).
displayInventory([HeadID|TailID]) :-
  inventory(HeadID, _, Name, Amount),
  write(Amount), write(' '), write(Name), nl,
  displayInventory(TailID).

inventory :-
  findall(ID, inventory(ID, _, _, _), IDs),
  inventoryTotal(IDs, TotalAmount),
  inventoryCapacity(Capacity),
  nl,
  write('Your inventory ('), write(TotalAmount), write(' / '), 
  write(Capacity), write(')'), nl,
  displayInventory(IDs).

  
  

