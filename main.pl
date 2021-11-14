
% Dynamic Variable:
% playerStats(ID, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)

:- dynamic(isGameStart/1).
:- dynamic(playerLocation/2).
:- dynamic(playerStats/10).

:- include('exp.pl').

startGame:-
    title,
    menu.

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
        write('------------ MENU ------------'), nl,
        write('1. start'), nl,
        write('2. status'), nl,
        write('------------ MENU ------------'), nl,
        write('[Dont''t forget to end your commands with a dot! Example: "start."]'), nl, nl.

menu :-
    repeat,
    write('Input >> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start);
        Input = 'map' -> call(map);
        Input = 'status' -> call(status);
        Input = _ -> write('Unknown input, please try again!'), nl, nl
    ),
    fail.


% playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)
status :-
    isGameStart(true),
    nl,
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    write('[PLAYER STATUS]'), nl,
    write('Job: '), (
        ID = 1 -> write('Fisherman');
        ID = 2 -> write('Farmer');
        ID = 3 -> write('Rancher')), 
    nl,
    write('Gold: '), write(Gold), write(/), write(2000), nl, nl,
    write('[LEVEL]'), nl,
    write('Player Level: '), write(LvlPlayer), nl,
    write('[TOTAL EXP]: '), write(ExpTotal), write('/'), write('300'), nl, nl,
    write('Fishing Level: '), write(LvlFish), nl,
    write('[EXP]: '), write(ExpFish), nl, nl,
    write('Farming Level: '), write(LvlFarm), nl,
    write('[EXP]: '), write(ExpFarm), nl, nl,
    write('Ranching Level: '), write(LvlRanch), nl,
    write('[EXP]: '), write(ExpRanch), nl, nl, !;

    \+ isGameStart(true),
    write('The game hasn''t started yet, use "start." to start the game.').

start :-
    isGameStart(true),
    write('The game has already been started, use "help." to see available commands.'), nl, nl, !;

    \+ isGameStart(true),
    initJob,
    nl, 
    write('Choose your Job: '), nl,
    write('1. Fisherman'), nl,
    write('2. Farmer'), nl,
    write('3. Rancher'), nl, nl,
    write('Job >> '),
    catch(read(Job), error(_,_), errorMessage), (
            Job = 1 ->
                asserta(playerStats(1, 1, 1, 56, 1, 76, 1, 56, 0, 0)),
                write('You choose Fisherman!'), nl;
            Job = 2 ->
                asserta(playerStats(2, 1, 1, 76, 1, 56, 1, 56, 0, 0)),
                write('You choose Farmer!'), nl;
            Job = 3 ->
                asserta(playerStats(3, 1, 1, 56, 1, 56, 1, 76, 0, 0)),
                write('You choose Rancer!'), nl;
            Job = _ -> write('Whoops, no Job have been chosen. You should choose one!')
        ), isJobValid(Job), nl, asserta(isGameStart(true)), !;
    start.

isJobValid(X) :-
    X < 4.

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.