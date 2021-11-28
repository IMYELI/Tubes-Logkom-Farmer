:- dynamic(teleportX/1).
:- dynamic(teleportY/1).
teleportX(0).
teleportY(0).

fairyChanceGenerator :-
    random(0,100,RAND),
    (isFairyEncountered(RAND)->fairyEncounter)

isFairyEncountered(RAND):-
    RAND>13,RAND=<20;RAND>57,RAND=<60;RAND>90,RAND=<95.

fairyEncounter :-
    write('As you fall deepeer into your slumber...\n'),
    write('You hear a familiar sound near you\n'),
    write('It'' been a long time, you finally remember something from your childhood..\n'),
    write('"konpeko konpeko konpeko\n"'),
    write('"OH MY GOD IT''S YOU, CAN I HAVE A PHOTO WITH YOU PLS?\n"'),
    write('"No peko, I''m only here to give you a free teleport everywhere in this world peko"\n'),
    write('"PLS PLS PLS\n"'),
    write('"where do you want to go peko\n"'),
    write('"PLS\n"'),
    write('"WHERE do you want to go peko\n"'),
    write('sheesh, ok then\n'),
    readTeleX,readTeleY,teleportX(X),teleportY(Y),retract(playerKoord(_,_)),asserta(playerKoord(X,Y)).

readTeleX :-
    write('Where do you want to go peko?(in X coordinate) >> '),
    read(InputX),(
        isTile(InputX) -> retract(teleportX(_)),asserta(teleportX(InputX));
        write('HEY! don''t go out from your small little world peko. it is dyanjarasu peko. there are monsters out there peko.'),readTeleX       
    )

readTeleY :-
    write('Where do you want to go peko?(in Y coordinate) >> '),
    read(InputY),(
        isTile(InputY) -> retract(teleportY(_)),asserta(teleportY(InputY));
        write('HEY! don''t go out from your small little world peko. it is dyanjarasu peko. there are monsters out there peko.'),readTeleY       
    )
