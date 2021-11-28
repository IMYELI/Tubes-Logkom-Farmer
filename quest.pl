% Not Yet a
:- use_module(library(random)).
:- dynamic(getQuest/0).
:- dynamic(goalQuest/2).

isQuestActive(false).
goalQuest(harvest, 0).
goalQuest(fish, 0).
goalQuest(ranch, 0).
getQuestreward(0,0).


startQuest :- 
    write('Hei bro, u want some challange?'),nl,
    isQuestActive(Check),
    (Check = true -> 
        write('Bruh, u have another job. Please be more diciplined. Finish your current job first\n')),
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
        write('----------------------------------------------------------\n'),
        write('(accept./cancel.) >>> '),
        read(Response),
        nl,
        (Response = accept -> generateQuest;
         Response = cancel -> exitQuest)

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
        DifficultyQuest = asian -> generateAsianQuest;
    ).

generateEzQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(1,3,rndmEzHarvest),
    random_between(1,3,rndmEzFish),
    random_between(1,3,rndmEzRanch),
    asserta(goalQuest(harvest,rndmEzHarvest)),
    asserta(goalQuest(fish,rndmEzFish)),
    asserta(goalQuest(ranch,rndmEzRanch)).

generateMedQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(3,6,rndmMedHarvest),
    random_between(3,6,rndmMedFish),
    random_between(3,6,rndmMedRanch),
    asserta(goalQuest(harvest,rndmMedHarvest)),
    asserta(goalQuest(fish,rndmMedFish)),
    asserta(goalQuest(ranch,rndmMedRanch)).

generateHardQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(6,11,rndmHardHarvest),
    random_between(6,11,rndmHardFish),
    random_between(6,11,rndmHardRanch),
    asserta(goalQuest(harvest,rndmHardHarvest)),
    asserta(goalQuest(fish,rndmHardFish)),
    asserta(goalQuest(ranch,rndmHardRanch)).

generateAsianQuest :-
    retract(isQuestActive(_)),
    asserta(isQuestActive(yes)),
    random_between(11,50,rndmAsianHarvest),
    random_between(11,50,rndmAsianFish),
    random_between(11,50,rndmAsianRanch),
    asserta(goalQuest(harvest,rndmAsianHarvest)),
    asserta(goalQuest(fish,rndmAsianFish)),
    asserta(goalQuest(ranch,rndmAsianRanch)).


/*

questStatus:- 
    quest_status(_),
    write('You Need to Collect :'),nl,
    panen_quest(_) -> (write('-  harvest item'),nl),
    ikan_quest(_) -> (write('-  fish'),nl),
    ranching_quest(_) -> (write('-  ranching item'),nl).
*/