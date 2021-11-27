
plant :-
  playerKoord(X,Y),
  (
    \+ isPatch(X,Y) ->
      write('Oi, you have plot north to your house.');

    \+ inventoryList(4, _) ->
    write('You don''t have any seeds to plant!');

    patchDug(X, Y, 0, _, _) ->
      plantCrop;

    patchDug(X, Y, 1, _, _) ->
      write('There''s already a plant here!');

    write('Dig it first leh, why so lazy.')
  ).

update([]).
update([H|T]) :-
  cropList(H, X, Y),
  date(_, _, Month, _),
  patchDug(X, Y, IsPlant, CropName, Time),
  crops(CropName, Season, HarvestTime),
  (
    Month =\= Season ->
      retract(patchDug(X, Y, _, _, _));
    Time < HarvestTime ->
      NTime is Time + 1,
      retract(patchDug(X, Y, _, _, _)),
      asserta(patchDug(X, Y, IsPlant, CropName, NTime));
    true
  ),
  update(T).

updateCrop :-
  findall(ID, cropList(ID, _, _), IDs),
  update(IDs).

plantCrop :-
    write('You have:\n'),
    findall(Name, inventoryList(4, Name), Names),
    displayInventoryTwo(Names, 1),
    date(_, _, Month, _),
    length(Names, Len), nl,
    write('What do you want to plant?\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
      integer(Input), Input > 0, Input =< Len ->
        NInput is Input - 1,
        nth0(NInput, Names, Element),
        item(_, Element, Plant),
        crops(Plant, Season, _),
        (
          Season =\= Month ->
            write('You want your plant to die eh? Now is not the season for it.\n\n');

          format('You planted a %s seed.\n\n', [Plant]),
          throw(Name, 1),
          cropID(ID),
          playerKoord(X, Y),
          asserta(cropList(ID, X, Y)),
          NID is ID + 1,
          retract(cropID(_)),
          asserta(cropID(NID)),
          retract(patchDug(X, Y, _, _, _)),
          asserta(patchDug(X, Y, 1, Plant, 0)),
          generateMap
        );
      Input \== 'exit' -> write('Unknown input, try again!\n\n'), plantCrop;
      true
    ).

dig :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        generateMap;
      write('You can not do that here!')
    ).

digL :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewX is X-1,
        (
          isPatch(NewX,Y)->
          asserta(patchDug(NewX,Y,0,'',0))
        ),
        generateMap;
      write('You can not do that here!')
    ).

digR :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewX is X+1,
        (
          isPatch(NewX,Y)->
          asserta(patchDug(NewX,Y,0,'',0))
        ),
        generateMap;
      write('You can not do that here!')
    ).

digT :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewY is Y-1,
        (
          isPatch(X,NewY)->
          asserta(patchDug(X,NewY,0,'',0))
        ),
        generateMap;
      write('You can not do that here!')
    ).

digB :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewY is Y+1,
          (
            isPatch(X,NewY)->
            asserta(patchDug(X,NewY,0,'',0))
          ),
          generateMap;
      write('You can not do that here!')
    ).




plantB :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(X,Y,_,_,_)->retract(patchDug(X,Y,_,_,_)),asserta(patchDug(X,Y,1,'Carrot',0)),NewY is Y+1,(
        patchDug(X, NewY,_ ,_ ,_)->retract(patchDug(X,NewY,_,_,_)),asserta(patchDug(X, NewY, 1, 'Carrot', 0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantT :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(X,Y,_,_,_)->retract(patchDug(X,Y,_,_,_)),asserta(patchDug(X,Y,1,'Carrot',0)),NewY is Y-1,(
        patchDug(X,NewY,_,_,_)->retract(patchDug(X,NewY,_,_,_)),asserta(patchDug(X, NewY, 1, 'Carrot', 0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantR :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(X,Y,_,_,_)->retract(patchDug(X,Y,_,_,_)),asserta(patchDug(X,Y,1,'Carrot',0)),NewX is X+1,(
        patchDug(NewX,Y,_,_,_)->retract(patchDug(NewX,Y,_,_,_)),asserta(patchDug(NewX, Y, 1, 'Carrot', 0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantL :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(X,Y,_,_,_)->retract(patchDug(X,Y,_,_,_)),asserta(patchDug(X,Y,1,'Carrot',0)),NewX is X-1,(
        patchDug(NewX,Y,_,_,_)->retract(patchDug(NewX,Y,_,_,_)),asserta(patchDug(NewX, Y, 1, 'Carrot', 0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).


errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
