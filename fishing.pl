:- dynamic(rangeSmallFish/2).
:- dynamic(rangeMediumFish/2).
:- dynamic(rangeBigFish/2).
:- dynamic(baseChance/1).
baseChance(30).
rangeSmallFish(3,3).
rangeMediumFish(56,56).
rangeBigFish(87,87).

initializeChanceFishing(Plus):-
    rangeSmallFish(SL,_),
    rangeMediumFish(ML,_),
    rangeBigFish(BL,_),
    SmallUp is div(Plus, 9) * 5,
    MedUp is div(Plus, 9) * 3,
    BigUp is div(Plus,9) * 1,
    retract(rangeSmallFish(_,_)),
    retract(rangeMediumFish(_,_)),
    retract(rangeBigFish(_,_)),
    asserta(rangeSmallFish(SL,SmallUp+SL)),
    asserta(rangeMediumFish(ML,MedUp+ML)),
    asserta(rangeBigFish(BL,BigUp+BL)).
    

fish:-
    playerKoord(X,Y),
    (\+ isNearWater(X,Y) -> write('You are not near water! What do you want to fish huh?');
        isNearWater(X,Y) -> fishGenerator).


fishGenerator:-
    random(0,100,RAND),(
        isSmallFishCaught(RAND) -> write('You caught a small fish.');
        isMediumFishCaught(RAND) -> write('You caught a medium fish.');
        isBigFishCaught(RAND) -> write('CONGRATS, You have finally gotten the big fish.');
        write('So sad :( you got mysterious floating boots. You decided to throw it back to the water since it is useless.')
    ).

isSmallFishCaught(X):-
    rangeSmallFish(SL,SU),
    X>=SL,X=<SU.

isMediumFishCaught(X):-
    rangeMediumFish(ML,MU),
    X>=ML,X=<MU.

isBigFishCaught(X):-
    rangeBigFish(BL,BU),
    X>=BL,X=<BU.