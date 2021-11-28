% Not Yet a
:- use_module(library(random)).
:- dynamic(getQuest/0).
:- dynamic(goalQuest/2).
:- dynamic(isQuestActive/2).

isQuestActive(false,none).
goalQuest(harvest, 0).
goalQuest(fish, 0).
goalQuest(ranch, 0).

startQuest :- 
    isQuestActive(Check,_),
    (Check = true -> 
        write('*****************************************************\n'),
        write('| Bruh, u have another job. Please, more diciplined.|\n'),
        write('| Finish your current job first                     |\n'), 
        write('| /**************************************************\n'),
        write('|/ '),
        exitQuest;
     Check = false->
        retract(goalQuest(harvest,_)),
        retract(goalQuest(fish,_)),
        retract(goalQuest(ranch,_)),

        write('**********************************************************\n'),
        write('|                         QUEST                          |\n'),
        write('| You will receive a quest to collect some               |\n'),
        write('| harvest items, fish, and ranching items                |\n'),
        write('| 1. Accept challange                                    |\n'),
        write('| 2. Cancel                                              |\n'),
        write('| /*******************************************************\n'),
        write('|/\n'),
        write('(accept./cancel.) >>> '),
        read(Response),
        nl,
        (Response = accept -> generateQuest;
         Response = cancel -> exitQuest),
        quest_status
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
        DifficultyQuest = easy -> generateEzQuest;
        DifficultyQuest = medium -> generateMedQuest;
        DifficultyQuest = hard -> generateHardQuest;
        DifficultyQuest = asian -> generateAsianQuest
    ).


generateEzQuest :-
    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,easy)),
    random_between(1,3,RndmEzHarvest),
    random_between(1,3,RndmEzFish),
    random_between(1,3,RndmEzRanch),
    asserta(goalQuest(harvest,RndmEzHarvest)),
    asserta(goalQuest(fish,RndmEzFish)),
    asserta(goalQuest(ranch,RndmEzRanch)).

generateMedQuest :-
    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,medium)),
    random_between(3,6,RndmMedHarvest),
    random_between(3,6,RndmMedFish),
    random_between(3,6,RndmMedRanch),
    asserta(goalQuest(harvest,RndmMedHarvest)),
    asserta(goalQuest(fish,RndmMedFish)),
    asserta(goalQuest(ranch,RndmMedRanch)).

generateHardQuest :-
    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,hard)),
    random_between(6,11,RndmHardHarvest),
    random_between(6,11,RndmHardFish),
    random_between(6,11,RndmHardRanch),
    asserta(goalQuest(harvest,RndmHardHarvest)),
    asserta(goalQuest(fish,RndmHardFish)),
    asserta(goalQuest(ranch,RndmHardRanch)).

generateAsianQuest :-
    retract(isQuestActive(_,_)),
    asserta(isQuestActive(true,asian)),
    random_between(11,50,RndmAsianHarvest),
    random_between(11,50,RndmAsianFish),
    random_between(11,50,RndmAsianRanch),
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
    write(' - '), write(X), write(' harvest item\n'),
    write(' - '), write(Y), write(' fish\n'),
    write(' - '), write(Z), write(' ranch item\n'),
    write('\n'),
    write('Back to this place, \n'),
    write('if u finish all the quest\n'),
    write('------------------------------\n').

exitQuest :-
    write('Okey, you got warning from that nigga...\n'),
    write('Ganbatte kudasai').

collectReward :-
    isQuestActive(Check,Diff),
    goalQuest(harvest, X),
    goalQuest(fish, Y),
    goalQuest(ranch, Z),
    ((Check = true ->
        ((X = 0),(Y = 0),(Z = 0)) ->
            playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, GoldTotal),
            (Diff = easy -> 
                NewEXP is ExpTotal + 10,
                NewGold is GoldTotal + 10;
             Diff = medium -> 
                NewEXP is ExpTotal + 25,
                NewGold is GoldTotal + 50;
             Diff = hard -> 
                NewEXP is ExpTotal + 50,
                NewGold is GoldTotal + 100;
             Diff = asian -> 
                NewEXP is ExpTotal + 500,
                NewGold is GoldTotal + 1000
                ),
            retract(playerStats(_, _, _, _, _, _, _, _, _, _)),
            asserta(playerStats(ID, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, NewEXP, NewGold));
        ((X =\= 0);(Y =\= 0);(Z =\= 0)) ->
            write('You still haven\'t finished your quest\n'),
            write('Finish the current quest to collect your reward'));
     (Check = false ->
        write('You don\'t deserve the reward because you don\'t even have a task'))).