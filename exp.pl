addExpPlayer(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    NExpTotal is ExpTotal + Exp,
    (
        LvlPlayer =\= 4, playerLvlCap(LvlPlayer, Cap), NExpTotal >= Cap ->
            NLvlPlayer is LvlPlayer + 1,
            write('\n============ Player Level Up! ============\n'),
            format('Player Level: %d -> %d\n', [LvlPlayer, NLvlPlayer]),
            write('Fishing Chance: +1\n'),
            write('Fishing Limit: +1\n'),
            write('===========================================\n\n'),
            increaseFishingChance(1),
            increaseFishingLimit(1);
        NLvlPlayer is LvlPlayer
    ),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, NLvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, NExpTotal, Gold)).

decreaseProduction([]).
decreaseProduction([H|T]) :-
    production(H, Production),
    NProduction is Production - 1,
    retract(production(H, _)),
    assertz(production(H, NProduction)),
    decreaseProduction(T).

decreaseHarvest([]).
decreaseHarvest([H|T]) :-
    crops(H, Season, HarvestTime),
    NHarvestTime is HarvestTime - 1,
    retract(crops(H, _, _)),
    assertz(crops(H, Season, NHarvestTime)),
    decreaseHarvest(T).

addExpRanch(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 3 -> GainedEXP is Exp + 3;
        GainedEXP is Exp
    ),
        format('You gain %d Ranching EXP!\n\n', [GainedEXP]),
        NExpRanch is ExpRanch + GainedEXP,
    (
        LvlRanch =\= 4, professionLvlCap(LvlRanch, Cap), NExpRanch > Cap ->
            NLvlRanch is LvlRanch + 1,
            write('============ Ranching Level Up! ============\n'),
            format('Ranching Level: %d -> %d\n', [LvlRanch, NLvlRanch]),
            write('Animal Production Speed: +1\n'),
            write('Animal Product Price: ++\n'),
            write('===========================================\n\n'),
            findall(AnimalType, production(AnimalType, _), AnimalTypes),
            decreaseProduction(AnimalTypes);
        NLvlRanch is LvlRanch
    ),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, NLvlRanch, NExpRanch, ExpTotal, Gold)),
    addExpPlayer(GainedEXP).

addExpFarm(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 2 -> GainedEXP is Exp + 3;
        GainedEXP is Exp
    ),
        format('You gain %d Farming EXP!\n\n', [GainedEXP]),
        NExpFarm is ExpFarm + GainedEXP,
    (
        LvlFarm =\= 4, professionLvlCap(LvlFarm, Cap), NExpFarm > Cap ->
            NLvlFarm is LvlFarm + 1,
            write('============ Farming Level Up! ============\n'),
            format('Farming Level: %d -> %d\n', [LvlFarm, NLvlFarm]),
            write('Crops Harvesting Speed: +1\n'),
            write('Crops Price: ++\n'),
            write('===========================================\n\n'),
            findall(Crop, crops(Crop, _, _), Crops),
            decreaseHarvest(Crops);
        NLvlFarm is LvlFarm
    ),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, NLvlFarm, NExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)),
    addExpPlayer(GainedEXP).

addExpFish(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 1 -> GainedEXP is Exp + 3;
        GainedEXP is ExpFish + Exp
    ),
        format('You gain %d Fishing EXP!\n\n', [GainedEXP]),
        NExpFish is ExpFish + GainedEXP,
    (
        LvlFish =\= 4, professionLvlCap(LvlFish, Cap), NExpFish > Cap ->
            NLvlFish is LvlFish + 1,
            write('============ Fishing Level Up! ============\n'),
            format('Fishing Level: %d -> %d\n', [LvlFish, NLvlFish]),
            write('Fishing Chance: +10\n'),
            write('Fishing Limit: +2\n'),
            write('===========================================\n\n'),
            increaseFishingChance(10),
            increaseFishingLimit(2);
        NLvlFish is LvlFish
    ),

    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, NLvlFish, NExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)),
    addExpPlayer(GainedEXP).

