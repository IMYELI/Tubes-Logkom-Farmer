% Not Yet a
:- dynamic(goalQuest/2).
:- dynamic(isQuestActive/2).

isQuestActive(false,none).
goalQuest(harvest, 0).
goalQuest(fish, 0).
goalQuest(ranch, 0).



questMenu :-
    write('**********************************************************\n'),
    write('|                         QUEST                          |\n'),
    write('| What brings you here today lad?                        |\n'),
    write('| 1. Quest                                               |\n'),
    write('| 2. Where''s my reward?                                  |\n'),
    write('| 3. Cancel                                              |\n'),
    write('**********************************************************\n'),
    write('\nQUEST >>> '),
    read(Option), nl,
    (
        Option = 1 -> startQuest;
        Option = 2 -> collectReward;
        Option \== 3 -> write('Wrong Input!, try again\n\n'), questMenu;
        write('Don''t forget to check your quest!\n\n')
    ).

startQuest :- 
    isQuestActive(Check,_),
    (Check = true -> 
        write('*****************************************************\n'),
        write('| Bruh, u have another job. Please, more diciplined.|\n'),
        write('| Finish your current job first                     |\n'), 
        write('| /**************************************************\n'),
        write('|/ '), nl, nl,
        exitQuest,
        questMenu;
     Check = false->

        write('**********************************************************\n'),
        write('|                         QUEST                          |\n'),
        write('| You will receive a quest to collect some               |\n'),
        write('| harvest items, fish, and ranching items                |\n'),
        write('| 1. Accept challenge                                    |\n'),
        write('| 2. Cancel                                              |\n'),
        write('| /*******************************************************\n'),
        write('|/\n'),
        write('(accept./cancel.) >>> '),
        read(Response),
        nl,
        (Response = accept -> generateQuest,  quest_status;
         \+ (Response = cancel) -> write('Command does not exist...\n\n'),startQuest)
       
    ).

generateQuest :-
    write('There are 4 difficulty of quests that you can accept.\n'),
    write('The more difficult the quest, the more rewards you will receive.\n'),
    write('1. easy\n'),
    write('2. medium\n'),
    write('3. hard\n'),
    write('4. asian\n'),
    write('Which difficulty u want? '),
    read(DifficultyQuest),
    nl,
    (
        DifficultyQuest = 1 -> generateEzQuest;
        DifficultyQuest = 2 -> generateMedQuest;
        DifficultyQuest = 3 -> generateHardQuest;
        DifficultyQuest = 4 -> generateAsianQuest;
        write('Wrong Input! try again!\n\n'), generateQuest
    ).


generateEzQuest :-
    retract(goalQuest(harvest,_)),
    retract(goalQuest(fish,_)),
    retract(goalQuest(ranch,_)),

    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,easy)),
    random(1,3,RndmEzHarvest),
    random(1,3,RndmEzFish),
    random(1,3,RndmEzRanch),
    asserta(goalQuest(harvest,RndmEzHarvest)),
    asserta(goalQuest(fish,RndmEzFish)),
    asserta(goalQuest(ranch,RndmEzRanch)).

generateMedQuest :-
    retract(goalQuest(harvest,_)),
    retract(goalQuest(fish,_)),
    retract(goalQuest(ranch,_)),

    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,medium)),
    random(3,6,RndmMedHarvest),
    random(3,6,RndmMedFish),
    random(3,6,RndmMedRanch),
    asserta(goalQuest(harvest,RndmMedHarvest)),
    asserta(goalQuest(fish,RndmMedFish)),
    asserta(goalQuest(ranch,RndmMedRanch)).

generateHardQuest :-
    retract(goalQuest(harvest,_)),
    retract(goalQuest(fish,_)),
    retract(goalQuest(ranch,_)),

    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,hard)),
    random(6,11,RndmHardHarvest),
    random(6,11,RndmHardFish),
    random(6,11,RndmHardRanch),
    asserta(goalQuest(harvest,RndmHardHarvest)),
    asserta(goalQuest(fish,RndmHardFish)),
    asserta(goalQuest(ranch,RndmHardRanch)).

generateAsianQuest :-
    retract(goalQuest(harvest,_)),
    retract(goalQuest(fish,_)),
    retract(goalQuest(ranch,_)),

    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,asian)),
    random(11,50,RndmAsianHarvest),
    random(11,50,RndmAsianFish),
    random(11,50,RndmAsianRanch),
    asserta(goalQuest(harvest,RndmAsianHarvest)),
    asserta(goalQuest(fish,RndmAsianFish)),
    asserta(goalQuest(ranch,RndmAsianRanch)).

quest_status :-
    goalQuest(harvest, X),
    goalQuest(fish, Y),
    goalQuest(ranch, Z),
    write('------------------------------\n'),
    write('            QUEST             \n'),
    write('                              \n'),
    write(' You have to collect this item\n'),
    (
        X > 0 -> write(' - '), write(X), write(' harvest item\n');
        write(' - (DONE) harvest item\n')
    ),
    (
        Y > 0 -> write(' - '), write(Y), write(' fish\n');
        write(' - (DONE) fish item\n')
    ),
    (
        Z > 0 -> write(' - '), write(Z), write(' ranch item\n');
        write(' - (DONE) ranch item\n')
    ),
    write('\n'),
    write('Back to this place, \n'),
    write('if u finish all the quest\n'),
    write('------------------------------\n\n').

exitQuest :-
    write('That old man seems mad because you are trying to be greedy...\n'),
    write('Ganbatte kudasai\n\n').

collectReward :-
    isQuestActive(Check,Diff),
    goalQuest(harvest, X),
    goalQuest(fish, Y),
    goalQuest(ranch, Z),
    (
        Check = true ->
            (
                (X = 0),(Y = 0),(Z = 0) ->
                    write('Well done! here''s yer money and EXP.\n'),
                    (
                        Diff = easy ->
                            addExpPlayer(10),
                            addGold(10);
                        Diff = medium -> 
                            addExpPlayer(25),
                            addGold(50);
                        Diff = hard -> 
                            addExpPlayer(50),
                            addGold(100);
                        Diff = asian -> 
                            addExpPlayer(500),
                            addGold(1000)
                    ), 
                    retract(isQuestActive(_,_)),
                    asserta(isQuestActive(false,none));
    
                ((X =\= 0);(Y =\= 0);(Z =\= 0)) ->
                    write('You still haven\'t finished your quest\n'),
                    write('Finish the current quest to collect your reward')
            );
        Check = false ->
            write('You don\'t deserve the reward because you don\'t even have a task')
    ), nl, nl.

autoCompleteQuest:-
    retractall(goalQuest),
    asserta(goalQuest(harvest, 0)),
    asserta(goalQuest(fish, 0)),
    asserta(goalQuest(ranch, 0)).
