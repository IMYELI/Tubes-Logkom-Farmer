:- include('fact.pl').
:- include('inventory.pl').
:- include('rancher.pl').
:- include('house.pl').
:- include('marketplace.pl').


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
        Input = 'market' -> call(marketplace);
        Input = 'inventory' -> call(inventory);
        Input = 'ranch' -> call(rancherMenu);
        Input = 'house' -> call(houseMenu);
        Input = _ -> write('Unknown input, try again!\n\n')
    ), !, gameMenu.

welcome :-
    nl,
    write('Welcome To Harvest Rune!\n'),
    write('Your goal is to pay your 2000 gold debts.\n'),
    write('The deadline for your debts is 3 years from now, good luck!\n\n'),
    write('=========== Commands ===========\n'),
    write('(help.) Menampilkan segala bantuan dan command\n'),
    write('(status.) Menampilkan kondisi pemain\n\n').

help :-
    write('=========== Help Menu ===========\n'),
    write('(help.) Menampilkan segala bantuan dan command\n'),
    write('(status.) Menampilkan kondisi pemain\n\n').

mainMenu :-
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start), welcome, gameMenu;
        Input = 'exit' -> write('Thank you for playing the game!');
        write('Unknown input, try again!\n\n'), !, mainMenu
    ).

status :-
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    levelCap(LvlPlayer, Cap),
    job(ID, Name),
    write('=========== Player Status ===========\n'),
    format('Job: %s\n', [Name]),
    format('Gold: %d / 2000\n', [Gold]),
    format('Player Level: %d\n', [LvlPlayer]),
    format('[PLAYER EXP] %d/%d\n', [ExpTotal, Cap]),
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
    catch(read(Input), error(_,_), errorMessage), (
            Input = 'fisherman' ->
                asserta(playerStats(1, 1, 1, 56, 1, 76, 1, 56, 0, 0)),
                write('Your job is now a Fisherman.'), nl;
            Input = 'farmer' ->
                asserta(playerStats(2, 1, 1, 76, 1, 56, 1, 56, 0, 0)),
                write('Your job is now a Farmer.'), nl;
            Input = 'rancher' ->
                asserta(playerStats(3, 1, 1, 56, 1, 56, 1, 76, 0, 0)),
                write('Your job is now a Rancher.'), nl;
            write('Unknown input, try again!\n'), !, start
    ).

errorMessage:-
    write('[ERROR] Your input broke the game, exiting the game...'), halt.
