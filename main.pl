:- include('fact.pl').
:- include('inventory.pl').
:- include('rancher.pl').
:- include('house.pl').
:- include('marketplace.pl').
:- include('farmer.pl').
:- include('exp.pl').
:- include('map.pl').
:- include('fishing.pl').

startFile:-
    title,
    mainMenu.

title:-
    write('$$\\   $$\\                                                     $$\\           $$$$$$$\\                                '), nl,
    write('$$ |  $$ |                                                    $$ |          $$  __$$\\                               '), nl,
    write('$$ |  $$ | $$$$$$\\   $$$$$$\\ $$\\    $$\\  $$$$$$\\   $$$$$$$\\ $$$$$$\\         $$ |  $$ |$$\\   $$\\ $$$$$$$\\   $$$$$$\\  '), nl,
    write('$$$$$$$$ | \\____$$\\ $$  __$$\\\\$$\\  $$  |$$  __$$\\ $$  _____|\\_$$  _|        $$$$$$$  |$$ |  $$ |$$  __$$\\ $$  __$$\\ '), nl,
    write('$$  __$$ | $$$$$$$ |$$ |  \\__|\\$$\\$$  / $$$$$$$$ |\\$$$$$$\\    $$ |          $$  __$$< $$ |  $$ |$$ |  $$ |$$$$$$$$ |'), nl,
    write('$$ |  $$ |$$  __$$ |$$ |       \\$$$  /  $$   ____| \\____$$\\   $$ |$$\\       $$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|'), nl,
    write('$$ |  $$ |\\$$$$$$$ |$$ |        \\$  /   \\$$$$$$$\\ $$$$$$$  |  \\$$$$  |      $$ |  $$ |\\$$$$$$  |$$ |  $$ |\\$$$$$$$\\ '), nl,
    write('\\__|  \\__| \\_______|\\__|         \\_/     \\_______|\\_______/    \\____/       \\__|  \\__| \\______/ \\__|  \\__| \\_______|'), nl, nl,
        write('"A Farmer''s Life is Not That Bad, I Think"'), nl, nl,
        write('==============================='), nl,
        write('       START GAME (start.)     '), nl,
        write('==============================='), nl,
        write('Dont''t forget to end your commands with a dot! '), nl, 
        write('Example: ">>> start."'), nl, nl.

gameMenu :-
    repeat,
    write('COMMAND >>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
        Input = 'help' -> call(help);
        Input = 'status' -> call(status);
        Input = 'market' ->
        (
            playerKoord(X,Y), isMarket(X, Y) -> call(marketplace);
            write('You are not in the market!\n\n')
        );
        Input = 'ranch' ->
        (
            playerKoord(X,Y), isRanch(X,Y) -> call(rancherMenu);
            write('You are not in the ranch!\n\n')
        );
        Input = 'house' ->
        (
            playerKoord(X,Y), isHouse(X,Y) -> call(houseMenu);
            write('You are not in the house!\n\n')
        );
        Input = 'fish' -> call(fish), nl, nl;
        Input = 'inventory' -> call(inventory);
        Input = 'throwItem' -> call(throwItem);
        Input = 'equip' -> call(equip);
        Input = 'unequip' -> call(unequip);
        Input = 'map' -> call(generateMap);
        Input = 'a' -> call(a);
        Input = 'w' -> call(w);
        Input = 's' -> call(s);
        Input = 'd' -> call(d);
        Input = 'plant' -> call(plant), nl, nl;
        Input = 'harvest' -> call(harvest), nl, nl;
        Input = 'dig' ->
        (
            isHoe1 -> call(dig);
            write('You need to equip a Hoe!\n\n')
        );
        Input = 'digR' ->
        (
            isHoe2 -> call(digR);
            write('You need to equip a Steel Hoe!\n\n')
        );
        Input = 'digL' ->
        (
            isHoe2 -> call(digL);
            write('You need to equip a Steel Hoe!\n\n')
        );
        Input = 'digB' ->
        (
            isHoe2 -> call(digB);
            write('You need to equip a Steel Hoe!\n\n')
        );
        Input = 'digT' ->
        (
            isHoe2 -> call(digT);
            write('You need to equip a Steel Hoe!\n\n')
        );
        Input = 'digUR' ->
        (
            isHoe3 -> call(digUR);
            write('You need to equip a Gold Hoe!\n\n')
        );
        Input = 'digUL' ->
        (
            isHoe3 -> call(digUL);
            write('You need to equip a Gold Hoe!\n\n')
        );
        Input = 'digUB' ->
        (
            isHoe3 -> call(digUB);
            write('You need to equip a Gold Hoe!\n\n')
        );
        Input = 'digUT' ->
        (
            isHoe3 -> call(digUT);
            write('You need to equip a Gold Hoe!\n\n')
        );
        write('Unknown input, try again!\n\n')
    ), gameMenu.

welcome :-
    nl,
    write('Welcome To Harvest Rune!\n'),
    write('Your goal is to pay your 2000 gold debts.\n'),
    write('The deadline for your debts is 3 years from now, good luck!\n\n'),
    write('=========== Commands ===========\n'),
    write('(help.) Menampilkan segala bantuan dan command\n'),
    write('(status.) Menampilkan kondisi pemain\n'),
    write('(inventory.) Menampilkan menu inventory\n'),
    write('(throwItem.) Membuang item dari inventory\n'),
    write('(market.) Menampilkan menu marketplace (harus berada pada marketplace)\n'),
    write('(ranch.) Menampilkan menu ranch (harus berada pada ranch)\n'),
    write('(house.) Menampilkan menu house (harus berada pada house)\n\n').

help :-
    write('=========== Help Menu ===========\n'),
    write('(help.) Menampilkan segala bantuan dan command\n'),
    write('(status.) Menampilkan kondisi pemain\n'),
    write('(inventory.) Menampilkan menu inventory\n'),
    write('(throwItem.) Membuang item dari inventory\n'),
    write('(market.) Menampilkan menu marketplace (harus berada pada marketplace)\n'),
    write('(ranch.) Menampilkan menu ranch (harus berada pada ranch)\n'),
    write('(house.) Menampilkan menu house (harus berada pada house)\n\n').

init :-
    welcome,
    gameMenu.

mainMenu :-
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start), init;
        Input = 'exit' -> write('Thank you for playing the game!');
        write('Unknown input, try again!\n\n'), mainMenu
    ).

status :-
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    playerLvlCap(LvlPlayer, Cap),
    job(ID, Name),
    write('=========== Player Status ===========\n'),
    format('Job: %s\n', [Name]),
    format('Gold: %d / 2000\n', [Gold]),
    format('Player Level: %d\n', [LvlPlayer]),
    (
        LvlPlayer =:= 4 ->
            format('[PLAYER EXP] %d\n', [ExpTotal]);
        format('[PLAYER EXP] %d/%d\n', [ExpTotal, Cap])
    ),
    write('============  Profession  ===========\n'),
    format('Fishing Level: %d\n', [LvlFish]),
    format('[EXP] %d\n', [ExpFish]),
    format('Farming Level: %d\n', [LvlFarm]),
    format('[EXP] %d\n', [ExpFarm]),
    format('Ranching Level: %d\n', [LvlRanch]),
    format('[EXP] %d\n\n', [ExpRanch]).

start :-
    nl, 
    write('======= Choose Your Job ======='), nl,
    write('- Fisherman'), nl,
    write('- Farmer'), nl,
    write('- Rancher'), nl,
    write('Example: ">>> fisherman."'), nl, nl,
    write('>>> '),
    catch(read(Input), error(_,_), errorJob), nl,
    (
        Input = 'fisherman' ->
            asserta(playerStats(1, 1, 1, 0, 1, 0, 1, 0, 0, 10000)),
            add('Fishing Rod', 1),
            write('You choose Fisherman!\n');

        Input = 'farmer' ->
            asserta(playerStats(2, 1, 1, 0, 1, 0, 1, 0, 0, 10000)),
            add('Hoe', 1),
            write('You choose Farmer!\n');
        Input = 'rancher' ->
            asserta(playerStats(3, 1, 1, 0, 1, 0, 1, 0, 0, 10000)),
            addAnimal('Cow', 1),
            addAnimal('Sheep', 1),
            addAnimal('Chicken', 1),
            write('You choose Rancher!\n');
        write('Unknown input, try again!\n'), start
    ).

errorMessage:-
    write('[ERROR] Your input broke the game, exiting the game...'), halt.

errorJob :-
    write('\nCmon don''t break the game please!\n'),
    start.
