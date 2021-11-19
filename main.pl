
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
        write('Dont''t forget to end your commands with a dot! '), nl, 
        write('Example: ">>> start."'), nl, nl.

gameMenu :-
    repeat,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'help' -> call(help);
        Input = 'status' -> call(status);
        Input = _ -> write('Unknown input, try again!'), nl, nl
    ).

welcome :-
    nl,
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
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start), welcome, gameMenu, !;
        Input = _ -> write('Unknown input, try again!'), nl, nl, mainMenu, !
    ).


% playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)
status :-
    nl,
    playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    job(ID, Name),
    levelCap(LvlPlayer, Cap),
    write('========== PLAYER STATUS =========='), nl,
    write('Job: '), write(Name), nl,
    write('Gold: '), write(Gold), write(/), write(2000), nl, nl,
    write('======== LEVEL ======='), nl,
    write('Player Level: '), write(LvlPlayer), nl,
    write('[PLAYER EXP]: '), write(ExpTotal), write('/'), write(Cap), nl, nl,
    write('Fishing Level: '), write(LvlFish), nl,
    write('[EXP]: '), write(ExpFish), nl, nl,
    write('Farming Level: '), write(LvlFarm), nl,
    write('[EXP]: '), write(ExpFarm), nl, nl,
    write('Ranching Level: '), write(LvlRanch), nl,
    write('[EXP]: '), write(ExpRanch), nl, nl, !.

start :-
    nl, 
    write('======= Choose your Job ======='), nl,
    write('- fisherman'), nl,
    write('- farmer'), nl,
    write('- rancher'), nl,
    write('Example: ">>> fisherman."'), nl, nl,
    write('>>> '),
    catch(read(Job), error(_,_), errorMessage), (
            Job = 'fisherman' ->
                asserta(playerStats(1, 1, 1, 56, 1, 76, 1, 56, 0, 0)),
                write('Your job is now a Fisherman.'), nl;
            Job = 'farmer' ->
                asserta(playerStats(2, 1, 1, 76, 1, 56, 1, 56, 0, 0)),
                write('Your job is now a Farmer.'), nl;
            Job = 'rancher' ->
                asserta(playerStats(3, 1, 1, 56, 1, 56, 1, 76, 0, 0)),
                write('Your job is now a Rancher.'), nl;
            Job = _ -> write('Unknown input, try again!'), nl, !, start
    ).

isJobValid(X) :-
    X > 0,
    X < 4.

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.