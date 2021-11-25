generateMap:- generate(0,0).

%Generate RIGHT BORDER
generate(X,Y) :- 
    isRightBorder(X,Y),!,
    NewY is Y+1,
    write(#),nl,generate(0,NewY).

%Generate LEFT BORDER
generate(X,Y) :-
    isLeftBorder(X,Y),!,
    NewX is X+1,
    write(#),generate(NewX,Y).

%Generate BORDER ATAS
generate(X,Y) :-
    isTopBorder(X,Y),!,
    NewX is X+1,
    write(#),generate(NewX,Y).

%Generate BORDER BAWAH
generate(X,Y) :-
    isBotBorder(X,Y),!,
    NewX is X+1,
    write(#),generate(NewX,Y).

%Generate PLAYER
generate(X,Y) :-
    playerKoord(PX,PY),
    NewX is X+1,
    X =:= PX, Y =:= PY,!,write('P'),generate(NewX,Y).

generate(X,Y) :-
    isTopPatch(X,Y),!,
    NewX is X+1,
    write('='),generate(NewX,Y).

generate(X,Y) :-
    isRightPatch(X,Y),!,
    NewX is X+1,
    write('|'),generate(NewX,Y).

generate(X,Y) :-
    isLeftPatch(X,Y),!,
    NewX is X+1,
    write('|'),generate(NewX,Y).

generate(X,Y) :-
    isBotPatch(X,Y),!,
    NewX is X+1,
    write('='),generate(NewX,Y).


%Generate air
generate(X,Y) :-
    isWater(X,Y),!,
    NewX is X+1,
    write('O'),generate(NewX,Y).

%Generate Rumah
generate(X,Y) :-
    isHouse(X,Y),!,
    NewX is X+1,
    write('H'),generate(NewX,Y).

%Generate Ranch
generate(X,Y) :-
    isRanch(X,Y),!,
    NewX is X+1,
    write('R'),generate(NewX,Y).

%Generate Quest
generate(X,Y) :-
    isQuest(X,Y),!,
    NewX is X+1,
    write('Q'),generate(NewX,Y).

%Generate market
generate(X,Y) :-
    isMarket(X,Y),!,
    NewX is X+1,
    write('M'),generate(NewX,Y).


%Generate TILE
generate(X,Y) :-
    isTile(X,Y),!,
    NewX is X+1,
    write(-),generate(NewX,Y).


isLeftBorder(X,Y):- 
    mapSize(H,_),
    X =:= 0, Y=<H, Y>= 0.

isRightBorder(X,Y):- 
    mapSize(H,W),
    X =:= W, Y=<H,Y>=0.

isTopBorder(X,Y):- 
    mapSize(_,W),
    X>=0,X=<W,Y=:=0.

isBotBorder(X,Y):- 
    mapSize(H,W),
    X>=0,X=<W,Y=:=H.

isTopPatch(X,Y):-
    X>=2,X=<13,Y=:=10.

isBotPatch(X,Y):-
    X>=2,X=<13,Y=:=14.

isRightPatch(X,Y):-
    X=:=14,Y>=11,Y=<13.

isLeftPatch(X,Y):-
    X=:=1,Y>=11,Y=<13.

isPatch(X,Y):-
    X>=2,X=<13,Y>=11,Y=<13.

isTile(X,Y):-
    mapSize(H,W),
    X>0,X<W,Y>0,Y<H, \+isWater(X,Y).

isWater(X,Y):-
    X=:=10,Y>=2,Y=<6;X=:=9,Y>=3,Y=<5;X=:=11,Y>=3,Y=<5.

isHouse(X,Y):-
    houseKoord(HX,HY),
    X=:=HX,Y=:=HY.

isRanch(X,Y):-
    ranchKoord(RX,RY),
    X=:=RX,Y=:=RY.

isQuest(X,Y):-
    questKoord(QX,QY),
    X=:=QX,Y=:=QY.

isMarket(X,Y):-
    marketplaceKoord(MX,MY),
    X=:=MX,Y=:=MY.

a:-
    playerKoord(X,Y),
    (

        isTile(X-1,Y) ->
        retract(playerKoord(X,Y)),NewX is X-1,asserta(playerKoord(NewX,Y)),generateMap;
        write('You can\'t go there!')
    ).
d:-
    playerKoord(X,Y),
    (
        isTile(X+1,Y) ->
        retract(playerKoord(X,Y)),NewX is X+1,asserta(playerKoord(NewX,Y)),generateMap;
        write('You can\'t go there!')
    ).
w:-
    playerKoord(X,Y),
    (
        isTile(X,Y-1) ->
        retract(playerKoord(X,Y)),NewY is Y-1,asserta(playerKoord(X,NewY)),generateMap;
        write('You can\'t go there!')
    ).
s:-
    playerKoord(X,Y),
    (
        isTile(X,Y+1) ->
        retract(playerKoord(X,Y)),NewY is Y+1,asserta(playerKoord(X,NewY)),generateMap;
        write('You can\'t go there!')
    ).