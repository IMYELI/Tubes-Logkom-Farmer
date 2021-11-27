:- dynamic(rangeSmallFish/2).
:- dynamic(rangeMediumFish/2).
:- dynamic(rangeBigFish/2).
:- dynamic(baseChance/1).
:- dynamic(fishingLimit/1).
:- dynamic(fishingCount/1).

baseChance(30).
rangeSmallFish(3,3).
rangeMediumFish(56,56).
rangeBigFish(87,87).
fishingLimit(10).
fishingCount(0).

increaseFishingChance(Plus):-
    rangeSmallFish(SL,_),
    rangeMediumFish(ML,_),
    rangeBigFish(BL,_),
    SmallUp is div(Plus, 9) * 5,
    MedUp is div(Plus, 9) * 3,
    BigUp is div(Plus,9) * 1,
    retract(rangeSmallFish(_,_)),
    retract(rangeMediumFish(_,_)),
    retract(rangeBigFish(_,_)),
    NewSmallUp is SmallUp + SL,
    NewMediumUp is MedUp + ML,
    NewBigUp is BigUp + BL,
    asserta(rangeSmallFish(SL,NewSmallUp)),
    asserta(rangeMediumFish(ML,NewMediumUp)),
    asserta(rangeBigFish(BL,NewBigUp)).

decreaseFishingChance(Min):-
    rangeSmallFish(SL,US),
    rangeMediumFish(ML,UM),
    rangeBigFish(BL,UB),
    SmallUp is div(Min, 9) * 5,
    MedUp is div(Min, 9) * 3,
    BigUp is div(Min,9) * 1,
    retract(rangeSmallFish(_,_)),
    retract(rangeMediumFish(_,_)),
    retract(rangeBigFish(_,_)),
    NewSmallUp is US - SmallUp + SL,
    NewMediumUp is UM - MedUp + ML,
    NewBigUp is UB-BigUp+BL,
    asserta(rangeSmallFish(SL,NewSmallUp)),
    asserta(rangeMediumFish(ML,NewMediumUp)),
    asserta(rangeBigFish(BL,NewBigUp)).

increaseFishingLimit(Plus):-
    fishingLimit(N),
    retract(fishingLimit(N)),
    assertz(fishingLimit(N+Plus)).


updateFishingCount:-
    fishingCount(FC),
    retract(fishingCount(FC)),
    assertz(fishingCount(0)).

plusFishingCount:-
    fishingCount(FC),
    retract(fishingCount(FC)),
    assertz(fishingCount(FC+1)).

fish:-
    playerKoord(X,Y),
    fishingLimit(Max),
    fishingCount(FC),
    (   FC>=Max -> write('Hey, that''s enough for today. You must level up if you want to fish more.');
        \+ isNearWater(X,Y) -> write('You are not near water! What do you want to fish huh?');
        isNearWater(X,Y) -> fishGenerator).


fishGenerator:-
    random(0,100,RAND),(
        isSmallFishCaught(RAND) ->
            write('You caught a small fish.'),
            add('Small Fish', 1);
        isMediumFishCaught(RAND) ->
            write('You caught a medium fish.'),
            add('Medium Fish', 1);
        isBigFishCaught(RAND) ->
            write('CONGRATS, You have finally gotten the big fish.'),
            add('Big Fish', 1);
        write('So sad :( you got mysterious floating boots.\nYou decided to throw it back to the water since it is useless.')
    ),
    nl,
    addExpFish(1),
    plusFishingCount.

isSmallFishCaught(X):-
    rangeSmallFish(SL,SU),
    X>=SL,X=<SU.

isMediumFishCaught(X):-
    rangeMediumFish(ML,MU),
    X>=ML,X=<MU.

isBigFishCaught(X):-
    rangeBigFish(BL,BU),
    X>=BL,X=<BU.
