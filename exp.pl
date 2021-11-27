addExpPlayer(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    NExpTotal is ExpTotal + Exp,
    (
        LvlPlayer =\= 4, playerLvlCap(LvlPlayer, Cap), NExpTotal > Cap ->
            NLvlPlayer is LvlPlayer + 1;
        NLvlPlayer is LvlPlayer
    ),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, NLvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, NExpTotal, Gold)).

addExpRanch(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 3 -> GainedEXP is Exp + 25;
        GainedEXP is Exp
    ),
        NExpRanch is ExpRanch + GainedEXP,
    (
        LvlRanch =\= 4, professionLvlCap(LvlRanch, Cap), NExpRanch > Cap ->
            NLvlRanch is LvlRanch + 1;
        NLvlRanch is LvlRanch
    ),
    format('You gain %d Ranching EXP!', [GainedEXP]),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, NLvlRanch, NExpRanch, ExpTotal, Gold)),
    addExpPlayer(Exp).

addExpFarm(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 2 -> GainedEXP is Exp + 25;
        GainedEXP is Exp
    ),
        NExpFarm is ExpFarm + GainedEXP,
    (
        LvlFarm =\= 4, professionLvlCap(LvlFarm, Cap), NExpFarm > Cap ->
            NLvlFarm is LvlFarm + 1;
        NLvlFarm is LvlFarm
    ),
    format('You gain %d Farming EXP!', [GainedEXP]),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, NLvlFarm, NExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)),
    addExpPlayer(Exp).

addExpFish(Exp) :-
    playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold),
    (
        Job = 1 -> GainedEXP is Exp + 25;
        GainedEXP is ExpFish + Exp
    ),
        NExpFish is ExpFish + GainedEXP,
    (
        LvlFish =\= 4, professionLvlCap(LvlFish, Cap), NExpFish > Cap ->
            NLvlFish is LvlFish + 1;
        NLvlFish is LvlFish
    ),
    format('You gain %d Fishing EXP!', [GainedEXP]),
    retract(playerStats(Job, _, _, _, _, _, _, _, _, _)),
    assertz(playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, NLvlFish, NExpFish, LvlRanch, ExpRanch, ExpTotal, Gold)),
    addExpPlayer(Exp).

