:- include('inventory.pl').

plant :-
    \+ inventory(4, _, _),
    write('You don''t have any seeds to plant!');

    write('You have:\n'),
    findall(Name, inventoryList(4, Name), Names),
    displayInventory(Names),
    write('What do you want to plant?\n\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage),(
      item(4, Name, Input), inventory(_, Name, _) ->
        format('You planted a %s seed.', [Input]),
        throw(Name, 1);
    write('Unknown input, try again!\n\n'), plant  
    ).

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
