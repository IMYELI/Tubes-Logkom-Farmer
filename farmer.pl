:- include('inventory.pl').

plant :-
    \+ inventoryList(4, _),
    write('You don''t have any seeds to plant!');

    write('You have:\n'),
    findall(Name, inventoryList(4, Name), Names),
    displayInventoryTwo(Names, 1),
    length(Names, Len),
    write('What do you want to plant?\n\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage),(
      integer(Input), Input > 0, Input =< Len ->
        NInput is Input - 1,
        nth0(NInput, Names, Element),
        item(_, Element, Plant),
        format('You planted a %s seed.', [Plant]),
        throw(Name, 1);
    write('Unknown input, try again!\n\n'), plant  
    ).

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
