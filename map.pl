:-dynamic(playerKoord/2).

mapSize(15,15).
playerKoord(1,1).
houseKoord(10,9).
ranchKoord(5,9).
questKoord(3,5).
marketplaceKoord(3,3).
generateMap:- generate(0,0).

%Generate RIGHT BORDER
generate(X,Y) :- 
    isRightBorder(X,Y),!,
    write(#),nl,generate(0,Y+1).

%Generate LEFT BORDER
generate(X,Y) :-
    isLeftBorder(X,Y),!,
    write(#),generate(X+1,Y).

%Generate BORDER ATAS
generate(X,Y) :-
    isTopBorder(X,Y),!,
    write(#),generate(X+1,Y).

%Generate BORDER BAWAH
generate(X,Y) :-
    isBotBorder(X,Y),!,
    write(#),generate(X+1,Y).

%Generate PLAYER
generate(X,Y) :-
    playerKoord(PX,PY),
    X =:= PX, Y =:= PY,!,write('P'),generate(X+1,Y).

generate(X,Y) :-
    isTopPatch(X,Y),!,
    write('='),generate(X+1,Y).

generate(X,Y) :-
    isRightPatch(X,Y),!,
    write('|'),generate(X+1,Y).

generate(X,Y) :-
    isLeftPatch(X,Y),!,
    write('|'),generate(X+1,Y).

generate(X,Y) :-
    isBotPatch(X,Y),!,
    write('='),generate(X+1,Y).


%Generate air
generate(X,Y) :-
    isWater(X,Y),!,
    write('O'),generate(X+1,Y).

%Generate Rumah
generate(X,Y) :-
    isHouse(X,Y),!,
    write('H'),generate(X+1,Y).

%Generate Ranch
generate(X,Y) :-
    isRanch(X,Y),!,
    write('R'),generate(X+1,Y).

%Generate Quest
generate(X,Y) :-
    isQuest(X,Y),!,
    write('Q'),generate(X+1,Y).

%Generate market
generate(X,Y) :-
    isMarket(X,Y),!,
    write('M'),generate(X+1,Y).


%Generate TILE
generate(X,Y) :-
    isTile(X,Y),!,
    write(-),generate(X+1,Y).


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
        retract(playerKoord(X,Y)),asserta(playerKoord(X-1,Y)),generateMap;
        write('You can\'t go there!')
    ).
d:-
    playerKoord(X,Y),
    (
        isTile(X+1,Y) ->
        retract(playerKoord(X,Y)),asserta(playerKoord(X+1,Y)),generateMap;
        write('You can\'t go there!')
    ).
w:-
    playerKoord(X,Y),
    (
        isTile(X,Y-1) ->
        retract(playerKoord(X,Y)),asserta(playerKoord(X,Y-1)),generateMap;
        write('You can\'t go there!')
    ).
s:-
    playerKoord(X,Y),
    (
        isTile(X,Y+1) ->
        retract(playerKoord(X,Y)),asserta(playerKoord(X,Y+1)),generateMap;
        write('You can\'t go there!')
    ).