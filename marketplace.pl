marketSpring :-
    assertz(marketList('Carrot Seeds')),
    assertz(marketList('Potato Seeds')),
    assertz(marketList('Strawberry Seeds')).

marketSummer :-
    assertz(marketList('Melon Seeds')),
    assertz(marketList('Corn Seeds')),
    assertz(marketList('Sunflower Seeds')).

marketFall :-
    assertz(marketList('Pumpkin Seeds')),
    assertz(marketList('Eggplant Seeds')),
    assertz(marketList('Grape Starter')).

marketplace :-
    write('========== Welcome To The Market ==========\n'),
    write('What do you want to do?\n'),
    write('- upgrade\n'),
    write('- buy\n'),
    write('- sell\n'),
    write('- exit\n\n'),
    write('MARKETPLACE >>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
        Input = 'upgrade' -> call(upgrade);
        Input = 'buy' -> call(buy);
        Input = 'sell' -> call(sell);
        Input = 'status' -> call(status), marketplace;
        Input = 'inventory' -> call(inventory), marketplace;
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
    price(H, Gold),
    format('%d. %s (%d Gold)\n', [Index, H, Gold]),
    NIndex is Index + 1,
    displayMarket(T, NIndex).

displayUpgrade([], _).
displayUpgrade([H|T], ID) :-
    toolList(ToolType, ToolLvl, H),
    (
        ToolLvl =\= 3 ->
            NToolLvl is ToolLvl + 1,
            toolList(ToolType, NToolLvl, NTool),
            price(NTool, Price),
            format('%d. %s -> %s (%d Gold)', [ID, H, NTool, Price]);
        format('%d. %s (MAX)', [ID, H])
    ),
    nl,
    NID is ID + 1,
    displayUpgrade(T, NID).

upgradeTool(ToolType, ToolLvl, ToolName) :-
    ToolLvl = 3, format('Your %s is already at max upgrade!\n\n', [ToolName]), !;

    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    NToolLvl is ToolLvl + 1,
    toolList(ToolType, NToolLvl, NToolName),
    price(NToolName, Price),
    (
        Gold < Price ->
        format('You don''t have enough money to buy a %s upgrade!\n\n', [NToolName]);

        NGold is Gold - Price,
        retract(playerStats(_, _, _, _, _, _, _, _, _, _)),
        assertz(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold)),
        throw(ToolName, 1),
        add(NToolName, 1),
        format('You successfully upgrade your %s into %s\n\n', [ToolName, NToolName])
    ).

checkTool(ToolType) :-
    (
        inventoryList(5, Tool), toolList(ToolType, _, Tool) ->
            assertz(upgradeList(Tool));
        true
    ).

upgrade :-
    checkTool(hoe),
    checkTool(rod),
    playerStats(_, _, _, _, _, _, _, _, _, Gold),
    (
        \+ upgradeList(_) ->
        write('You don''t have any tools to upgrade, you need to unequip your tool to upgrade\n\n'), marketplace;

        write('========== Upgrade Menu ==========\n'),
        format('Your Gold: %d\n', [Gold]),
        write('What do you want to upgrade?\n'),
        write('0. Exit\n'),
        findall(Tool, upgradeList(Tool), Tools),
        length(Tools, Len),
        displayUpgrade(Tools, 1), nl,
        write('>>> '),
        catch(read(Input), error(_,_), errorMessage), nl,
        (
            integer(Input), Input > 0, Input =< Len ->
                Index is Input - 1,
                nth0(Index, Tools, X),
                toolList(ToolType, ToolLvl, X),
                upgradeTool(ToolType, ToolLvl, X),
                retractall(upgradeList(_)),
                upgrade;
            Input \== 0 -> write('Unknown Input, Try Again!\n\n'),
                retractall(upgradeList(_)), upgrade;
            retractall(upgradeList(_)), marketplace
        )
    ).

addGold(Price) :-
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    NGold is Gold + Price,
    date(TotalDay, Day, Month),
    season(Month, Season),
    (
        NGold >= 20000, nl, nl,
            write('==================== CONGRATULATION  =====================\n'),
            write('Congratulations! You have finally collected 20000 golds!\n'),
            format('Day: %d\n', [Day]),
            format('Season: %s\n', [Season]),
            format('Total Day: %d\n', [TotalDay]),
            write('==========================================================\n\n'),
            write('Input anything to exit to the Main Menu: '),
            catch(read(_), error(_,_), errorMessage), nl,
            startGame;
        retract(playerStats(_, _, _, _, _, _, _, _, _, Gold)),
        asserta(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, NGold))
    ).

sell :-
    \+ inventoryList(1, _),
    \+ inventoryList(3, _),
    \+ inventoryList(6, _),
    write('There''s nothing that worth to sell in your inventory.\n\n'), marketplace;

    findall(Name, (inventoryList(1, Name); inventoryList(3, Name); inventoryList(6, Name)), Names),
    length(Names, Len),
    playerStats(_, _, LvlFarm, _, LvlFish, _, LvlRanch, _, _, Gold),
    write('========= Sell Menu =========\n'),
    format('Your Gold: %d\n', [Gold]),
    write('Here are the items in your inventory:\n'),
    write('0. Exit\n'),
    displayMarket2(Names, 1), nl,
    write('What do you want to sell?\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
        integer(Input), Input > 0, Input =< Len ->
        (
            NInput is Input - 1,
            nth0(NInput, Names, Element),
            inventoryList(Category, Element),
            write('How many do you want to sell?\n'),
            write('>>> '),
            catch(read(Amount), error(_,_), errorMessage), nl,
            (
                integer(Amount), Amount > 0 ->
                    price(Element, Price),
                    farmLevelPrice(LvlFarm, BonusFarm),
                    ranchLevelPrice(LvlRanch, BonusRanch),
                    fishLevelPrice(LvlFish, BonusFish),
                    inventory(Element, InitialAmount),
                    (
                        InitialAmount < Amount ->
                        format('You only have %d %s!', [InitialAmount, Element]);

                        format('You have sold %d %s!\n', [Amount, Element]),
                        item(Category, Element, _),
                        (
                            Category = 1 ->
                            NewPrice is Price + BonusFarm;

                            Category = 6 ->
                            NewPrice is Price + BonusFish;

                            Category = 3 ->
                            NewPrice is Price + BonusRanch
                        ),
                        TotalPrice is NewPrice * Amount,
                        format('You received %d Gold!', [TotalPrice]),
                        throw(Element, Amount),
                        addGold(TotalPrice)
                    ), nl, nl, sell;

                write('You don''t have that many item!\n\n'),
                sell
            )
        );

        Input \== 0 -> write('Unknown Input, Try Again!\n\n'), sell;
        marketplace
    ).


buy :-
    date(_, _, Month),
    (
        Month = 1 -> call(marketSpring);
        Month = 2 -> call(marketSummer);
        Month = 3 -> call(marketFall);
        true
    ),
    assertz(marketList('Chicken')),
    assertz(marketList('Cow')),
    assertz(marketList('Sheep')),
    (
        \+ equipment(hoe, _), \+ (inventoryList(5, Tool), toolList(hoe, _, Tool)) ->
            assertz(marketList('Hoe'));
        true

    ),
    (
        \+ equipment(rod, _), \+ (inventoryList(5, NTool), toolList(rod, _, NTool)) ->
            assertz(marketList('Fishing Rod'));
        true
    ),
    findall(Name, marketList(Name), Names),
    length(Names, Len),
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    write('========= Buy Menu =========\n'),
    format('Your Gold: %d\n', [Gold]),
    write('What do you want to buy?\n'),
    write('0. Exit\n'),
    displayMarket(Names, 1), nl,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
        integer(Input), Input > 0, Input =< Len ->
        (
            NInput is Input - 1,
            nth0(NInput, Names, Element),
            item(Category, Element, _),
            write('How many do you want to buy?\n'),
            write('>>> '),
            catch(read(Amount), error(_,_), errorMessage), nl,
            (
                integer(Amount), Amount > 0 ->
                price(Element, Price),
                TotalPrice is Amount * Price,
                (
                    Category =\= 2, isInventoryFull(Amount) ->
                    write('Broo... that''s too much for you to handle');

                    Category = 5, Amount > 1 ->
                    write('You can only buy 1 tool at once!');

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

                write('What are you doing, buying a negative item?\n\n'),
                retractall(marketList(_)),
                buy
            )
        );
        Input \== 0 -> write('Unknown Input, Try Again!\n\n'), retractall(marketList(_)), buy;
        retractall(marketList(_)), marketplace
    ).


