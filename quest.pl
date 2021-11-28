% Not Yet a
:- use_module(library(random)).
:- dynamic(getQuest/0).
:- dynamic(goalQuest/2).
:- dynamic(isQuestActive/1).

isQuestActive(false).
goalQuest(harvest, 0).
goalQuest(fish, 0).
goalQuest(ranch, 0).
getQuestreward(0,0).


startQuest :- 
    isQuestActive(Check),
    (Check = true -> 
        write('-----------------------------------------------------\n'),
        write('| Bruh, u have another job. Please, more diciplined.|\n'),
        write('| Finish your current job first                     |\n'), 
        write('| /--------------------------------------------------\n'),
        write('|/ '),
        exitQuest;
     Check = false->
        retract(goalQuest(harvest,_)),
        retract(goalQuest(fish,_)),
        retract(goalQuest(ranch,_)),

        write('----------------------------------------------------------\n'),
        write('|                         QUEST                          |\n'),
        write('| You will receive a quest to collect some               |\n'),
        write('| harvest items, fish, and ranching items                |\n'),
        write('| 1. Accept challange                                    |\n'),
        write('| 2. Cancel                                              |\n'),
        write('| /-------------------------------------------------------\n'),
        write('|/\n'),
        write('(accept./cancel.) >>> '),
        read(Response),
        nl,
        (Response = accept -> generateQuest;
         Response = cancel -> exitQuest),
        quest_status,
        retract(isQuestActive(_)),
        asserta(isQuestActive(true))
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
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(1,3,RndmEzHarvest),
    random_between(1,3,RndmEzFish),
    random_between(1,3,RndmEzRanch),
    asserta(goalQuest(harvest,RndmEzHarvest)),
    asserta(goalQuest(fish,RndmEzFish)),
    asserta(goalQuest(ranch,RndmEzRanch)).

generateMedQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(3,6,RndmMedHarvest),
    random_between(3,6,RndmMedFish),
    random_between(3,6,RndmMedRanch),
    asserta(goalQuest(harvest,RndmMedHarvest)),
    asserta(goalQuest(fish,RndmMedFish)),
    asserta(goalQuest(ranch,RndmMedRanch)).

generateHardQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(6,11,RndmHardHarvest),
    random_between(6,11,RndmHardFish),
    random_between(6,11,RndmHardRanch),
    asserta(goalQuest(harvest,RndmHardHarvest)),
    asserta(goalQuest(fish,RndmHardFish)),
    asserta(goalQuest(ranch,RndmHardRanch)).

generateAsianQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
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
    write('------------------------------\n').

exitQuest :-
    write('Okey, you got warning from that nigga...\n'),
    write('Ganbatte kudasai').
