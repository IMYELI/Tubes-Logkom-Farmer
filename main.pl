
:- dynamic(isGameStart/1).


startGame:-
    \+ isGameStart(_),
    asserta(isGameStart(true)),
    title,
    menu.

startGame:-
    isGameStart(_),
    write('The game has already been started, use "help." to see available commands.').

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
        write('2. map'), nl,
        write('------------ MENU ------------'), nl, nl, !.

menu :-
    repeat,
    write('> '),
    catch(read(Input), error(_,_), errorMessage), (
        Input = 'start' -> call(start);
        Input = 'map' -> call(map);
        Input = _ -> write('Unknown input, please try again!'), nl, nl
    ),
    fail.

map :-
    write('oho').

start :-
    nl, 
    write('Choose your job'), nl,
    write('1. Fisherman'), nl,
    write('2. Farmer'), nl,
    write('3. Rancher'), nl, nl,
    write('Choose your profession: '),
    catch(read(Profession), error(_,_), errorMessage), (
            Profession = 1 ->
            write('You choose Fisherman, let''s start paying your debts!'), nl;
            Profession = 2 ->
            write('You choose Farmer, let''s start paying your debts!'), nl;
            Profession = 3 ->
            write('You choose Rancer, let''s start paying your debts!'), nl;
            Profession = _ -> 
            write('Whoops, no profession have been chosen. You should choose one!'), nl
        ), nl.

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.