
% Dynamic Variable:
% playerStats(ID, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)

:- dynamic(isGameStart/1).
:- dynamic(playerLocation/2).
:- dynamic(playerStats/10).

:- include('exp.pl').
:- include('inventory.pl').

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
        write('[Dont''t forget to end your commands with a dot! Example: "start."]'), nl, nl.

gameMenu :-
    repeat,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'help' -> call(help);
        Input = 'status' -> call(status);
        Input = _ -> write('Unknown input, please try again!'), nl, nl
    ),
    fail.
welcome :-
    write('Welcome To Harvest Rune!'), nl,
    write('You have 2000 gold debts from being tricked,'), nl,
    write('now you go back to your hometown as a farmer to pay your debts.'), nl,
    write('The deadline for your debts is 3 years from now, good luck!'), nl, nl,
    write('=========== COMMANDS ==========='), nl,
    write('(help.) Menampilkan segala bantuan dan command'), nl,
    write('(status.) Menampilkan kondisi pemain'), nl, nl.

help :-
    nl,
    write('=========== HELP ==========='), nl,
    write('(help.) Menampilkan segala bantuan dan command'), nl,
    write('(status.) Menampilkan kondisi pemain'), nl, nl.
mainMenu :-
    repeat,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start), welcome, gameMenu, !
    ),
    fail. 


% playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)
status :-
    isGameStart(true),
    nl,
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    job(ID, Name),
    levelCap(LvlPlayer, Cap),
    write('========== PLAYER STATUS =========='), nl,
    write('Job: '), write(Name), nl,
    write('Gold: '), write(Gold), write(/), write(2000), nl, nl,
    write('======== LEVEL ======='), nl,
    write('Player Level: '), write(LvlPlayer), nl,
    write('[TOTAL EXP]: '), write(ExpTotal), write('/'), write(Cap), nl, nl,
    write('Fishing Level: '), write(LvlFish), nl,
    write('[EXP]: '), write(ExpFish), nl, nl,
    write('Farming Level: '), write(LvlFarm), nl,
    write('[EXP]: '), write(ExpFarm), nl, nl,
    write('Ranching Level: '), write(LvlRanch), nl,
    write('[EXP]: '), write(ExpRanch), nl, nl, !.

start :-
    isGameStart(true),
    write('The game has already been started, use "help." to see available commands.'), nl, nl, !;

    nl, 
    write('======= Choose your Job (Example: ">>> 1.") ======='), nl,
    write('1. Fisherman'), nl,
    write('2. Farmer'), nl,
    write('3. Rancher'), nl, nl,
    write('>>> '),
    catch(read(Job), error(_,_), errorMessage), (
            Job = 1 ->
                asserta(playerStats(1, 1, 1, 56, 1, 76, 1, 56, 0, 0)),
                write('You choose Fisherman!'), nl;
            Job = 2 ->
                asserta(playerStats(2, 1, 1, 76, 1, 56, 1, 56, 0, 0)),
                write('You choose Farmer!'), nl;
            Job = 3 ->
                asserta(playerStats(3, 1, 1, 56, 1, 56, 1, 76, 0, 0)),
                write('You choose Rancher!'), nl;
            Job = _ -> write('Whoops, no Job have been chosen. You should choose one!'), nl
        ), integer(Job), isJobValid(Job), nl, asserta(isGameStart(true)), !;
    start.

isJobValid(X) :-
    X > 0,
    X < 4.

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.