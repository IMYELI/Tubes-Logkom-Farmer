marketSpring :-
    assertz(marketList('Carrot Seeds')),
    assertz(marketList('Potato Seeds')),
    assertz(marketList('Strawberry Seeds')).

marketplace :-
    write('========== Welcome To The Market ==========\n'),
    write('What do you want to do?\n'),
    write('- upgrade\n'),
    write('- buy\n'),
    write('- sell\n'),
    write('- exit\n\n'),
    write('MARKETPLACE >>> '),
    read(Input), nl,
    (
        Input = 'upgrade' -> call(upgrade);
        Input = 'buy' -> call(buy);
        Input = 'sell' -> call(sell);
        Input \== 'exit' -> write('Unknown input, try again!\n\n'),
        marketplace;
        write('Hope to see you again in the market!\n\n')
    ).

displayMarket2([], _).
displayMarket2([H|T], Index) :-
    inventory(H, Amount),
    format('%d. %s (Amount: %d)\n', [Index, H, Amount]),
    NIndex is Index + 1,
    displayMarket2(T, NIndex).


displayMarket([], _).
displayMarket([H|T], Index) :-
    buyPrice(H, Gold),
    format('%d. %s (%d Gold)\n', [Index, H, Gold]),
    NIndex is Index + 1,
    displayMarket(T, NIndex).

displayUpgrade(Category, Tool, ToolLvl) :-
    (
        ToolLvl =\= 5 ->
        toolList(Category, ToolLvl, NTool),
        buyPrice(NTool, Price),
        format('%d. %s -> %s (%d Gold)', [Category, Tool, NTool, Price]);
        format('%d. %s (MAX)', [Category, Tool])
    ), nl.

upgradeTool(Category, ToolLvl, Type) :-
    ToolLvl = 5, format('Your %s is already at max upgrade!\n\n', [Type]), upgrade, !;

    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    toolList(Category, ToolLvl, ToolName),
    buyPrice(ToolName, Price),
    (
        Gold < Price ->
        format('You don''t have enough money to buy a %s upgrade!\n\n', [Type]), upgrade;

        NGold is Gold - Price,
        retract(playerStats(_, _, _, _, _, _, _, _, _, _)),
        assertz(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold)),
        retract(toolLevel(Category, _, Type)),
        assertz(toolLevel(Category, ToolLvl, Type)),
        format('You successfully upgrade your %s into %s\n\n', [Type, ToolName]), upgrade
    ).

upgrade :-
    toolLevel(1, HoeLvl, Type1),
    toolList(1, HoeLvl, Hoe),
    toolLevel(2, RodLvl, Type2),
    toolList(2, RodLvl, Rod),
    NHoeLvl is HoeLvl + 1,
    NRodLvl is RodLvl + 1,
    playerStats(_, _, _, _, _, _, _, _, _, Gold),
    write('========== Upgrade Menu ==========\n'),
    format('Your Gold: %d\n', [Gold]),
    write('What do you want to upgrade?\n'),
    displayUpgrade(1, Hoe, NHoeLvl),
    displayUpgrade(2, Rod, NRodLvl), nl,
    write('>>> '),
    read(Input), nl,
    (
        Input = 1 ->
            upgradeTool(1, NHoeLvl, Type1);
        Input = 2 ->
            upgradeTool(2, NRodLvl, Type2);
        Input \== exit ->
            write('Unknown Input, Try Again!\n\n'), upgrade;
        marketplace
    ).


sell :-
    \+ inventoryList(1, _),
    \+ inventoryList(3, _),
    write('There''s nothing that worth to sell in your inventory.\n\n'), marketplace;

    findall(Name, (inventoryList(1, Name); inventoryList(3, Name)), Names),
    length(Names, Len),
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    write('========= Sell Menu =========\n'),
    format('Your Gold: %d\n', [Gold]),
    write('Here are the items in your inventory:\n'),
    displayMarket2(Names, 1), nl,
    write('What do you want to sell?\n'),
    write('>>> '),
    read(Input), nl,
    (
        integer(Input), Input > 0, Input =< Len ->
        (
            NInput is Input - 1,
            nth0(NInput, Names, Element),
            inventoryList(Category, Element),
            write('How many do you want to sell?\n'),
            write('>>> '),
            read(Amount), nl,
            (
                integer(Amount), Amount > 0 ->
                    buyPrice(Element, Price),
                    farmLevelPrice(LvlFarm, BonusFarm),
                    ranchLevelPrice(LvlRanch, BonusRanch),
                    inventory(Element, InitialAmount),
                    (
                        InitialAmount < Amount ->
                        format('You only have %d %s!', [InitialAmount, Element]);

                        format('You have sold %d %s!\n', [Amount, Element]),
                        item(Category, Element, _),
                        (
                            Category = 1 ->
                            NewPrice is Price + BonusFarm;

                            Category = 3 ->
                            NewPrice is Price + BonusRanch
                        ),
                        TotalPrice is NewPrice * Amount,
                        NGold is Gold + TotalPrice,
                        format('You received %d Gold!', [TotalPrice]),
                        throw(Element, Amount),
                        retract(playerStats(_, _, _, _, _, _, _, _, _, Gold)),
                        asserta(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold))
                    ), nl, nl, sell;

                write('You don''t have that many item!\n\n'),
                sell
            )
        );

        Input \== 'exit' -> write('Unknown Input, Try Again!\n\n'), sell;
        marketplace
    ).


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
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    write('========= Buy Menu =========\n'),
    format('Your Gold: %d\n', [Gold]),
    write('What do you want to buy?\n'),
    displayMarket(Names, 1), nl,
    write('>>> '),
    read(Input), nl,
    (
        integer(Input), Input > 0, Input =< Len ->
        (
            NInput is Input - 1,
            nth0(NInput, Names, Element),
            item(Category, Element, _),
            write('How many do you want to buy?\n'),
            write('>>> '),
            read(Amount), nl,
            (
                integer(Amount), Amount > 0 ->
                buyPrice(Element, Price),
                TotalPrice is Amount * Price,
                (
                    Category =\= 2, isInventoryFull(Amount) ->
                    write('Broo... that''s too much for you to handle');

                    TotalPrice > Gold ->
                    write('You don''t have enough gold!');

                    format('You have bought %d %s!\n', [Amount, Element]),
                    item(Category, Element, _),
                    (
                        Category = 2 ->
                        addAnimal(Element, Amount);

                        add(Element, Amount)
                    ),
                    NGold is Gold - TotalPrice,
                    format('You used %d Gold.', [TotalPrice]),
                    retract(playerStats(_, _, _, _, _, _, _, _, _, Gold)),
                    asserta(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold))
                ), retractall(marketList(_)), nl, nl, buy;

                write('You don''t have that many item!\n\n'),
                retractall(marketList(_)),
                buy
            )
        );
        Input \== 'exit' -> write('Unknown Input, Try Again!\n\n'), retractall(marketList(_)), buy;
        retractall(marketList(_)), marketplace
    ).


