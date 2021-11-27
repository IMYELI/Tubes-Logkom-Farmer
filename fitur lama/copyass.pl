:- include('fact.pl').
:- include('inventory.pl').
:- include('rancher.pl').

marketSpring :-
    assertz(marketList('Carrot Seeds')),
    assertz(marketList('Potato Seeds')),
    assertz(marketList('Strawberry Seeds')).

marketplace :-
    write('========== Welcome To The Market ==========\n'),
    write('What do you want to do?'),
    write('- Buy'),
    write('- Sell'),
    read(Input),
    (
        Input = 'buy' -> call(buy); 
        Input = 'sell' -> call(sell);
        Input \== 'exit' -> write('Unknown input, try again!'), nl,
        marketplace
    ).

displayMarket([], _).
displayMarket([H|T], Index) :-
    buyPrice(H, Gold),
    format('%d. %s (%d Gold)\n', [Index, H, Gold]),
    NIndex is Index + 1,
    displayMarket(T, NIndex).

buy :-
    date(_, _, Month, _),
    (
        Month = 1 -> call(marketSpring);
        Month = 2 -> call(marketSummer);
        Month = 3 -> call(marketFall);
        Month = 4 -> call(marketWinter)
    ),
    assertz(marketList('Chicken')),
    assertz(marketList('Cow')),
    assertz(marketList('Sheep')),
    findall(Name, marketList(Name), Names),
    length(Names, Len),
    write('\nWhat do you want to buy?\n'),
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    displayMarket(Names, 1), nl,
    write('>>> '),
    read(Input),
    (
        integer(Input), Input > 0, Input =< Len ->
        (
            NInput is Input - 1,
            nth0(NInput, Names, Element),
            write('\nHow many do you want to buy?\n'),
            write('>>> '),
            read(Amount),
            (
                integer(Amount), Amount > 0 ->
                buyPrice(Element, Price),
                TotalPrice is Amount * Price,
                (
                    isInventoryFull(Amount) ->
                    write('Your inventory is Full!');
                    
                    TotalPrice > Gold ->
                    write('You don''t have enough money!');

                    format('You have bought %d %s!', [Amount, Element]),
                    item(Category, Element, _),
                    (
                        Category = 2 ->
                        addMultipleAnimal(Element, Amount);
                        
                        add(Element, Amount)
                    ),
                    NGold is Gold - TotalPrice,
                    format('\nYou used %d Gold', [NGold]),
                    retract(playerStats(_, _, _, _, _, _, _, _, _, Gold)),
                    asserta(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold))
                )
            )
        );
        Input \== 'exit' ->
        write('Unknown Input, Try Again!'),
        retractall(marketList(_)),
        buy
    ), retractall(marketList(_)).


