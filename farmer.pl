:- dynamic(cropList/2).

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

updateC([]).
updateC([H|T]) :-
  cropList(H, X, Y),
  date(_, _, Month),
  patchDug(X, Y, IsPlant, CropName, Time),
  crops(CropName, Season, HarvestTime),
  (
    Month =\= Season ->
      retract(patchDug(X, Y, _, _, _));
    NTime is Time + 1,
    retract(patchDug(X, Y, _, _, _)),
    asserta(patchDug(X, Y, IsPlant, CropName, NTime))
  ),
  updateC(T).

updateCrop :-
  \+ cropList(_, _, _), !;
  findall(ID, cropList(ID, _, _), IDs),
  update(IDs).

plantCrop :-
    write('You have:\n'),
    findall(Name, inventoryList(4, Name), Names),
    displayInventory2(Names, 1),
    date(_, _, Month),
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
          throw(Element, 1),
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
  
digUB :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewY is Y+1,
          (
            isPatch(X,NewY)->
            asserta(patchDug(X,NewY,0,'',0)),NewY2 is NewY + 1
          ),
              (
                isPatch(X,NewY2) -> asserta(patchDug(X,NewY2,0,'',0))
              ),
          generateMap;
      write('You can not do that here!')
    ).

digUT :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewY is Y-1,
          (
            isPatch(X,NewY)->
            asserta(patchDug(X,NewY,0,'',0)),NewY2 is NewY - 1
          ),
              (
                isPatch(X,NewY2) -> asserta(patchDug(X,NewY2,0,'',0))
              ),
          generateMap;
      write('You can not do that here!')
    ).

digUR :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewX is X+1,
          (
            isPatch(NewX,Y)->
            asserta(patchDug(NewX,Y,0,'',0)),NewX2 is NewX + 1
          ),
              (
                isPatch(NewX2,Y) -> asserta(patchDug(NewX2,Y,0,'',0))
              ),
          generateMap;
      write('You can not do that here!')
    ).

digUL :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> 
        asserta(patchDug(X,Y,0,'',0)),
        NewX is X-1,
          (
            isPatch(NewX,Y)->
            asserta(patchDug(NewX,Y,0,'',0)),NewX2 is NewX - 1
          ),
              (
                isPatch(NewX2,Y) -> asserta(patchDug(NewX2,Y,0,'',0))
              ),
          generateMap;
      write('You can not do that here!')
    ).

harvest :-
    playerKoord(X,Y),
    (
      patchDug(X, Y, 1, CropName, Time) ->
        crops(CropName, _, HarvestTime),
        (
          Time >= HarvestTime ->
            retract(cropList(_, X, Y)),
            retract(patchDug(X, Y, _, _, _)),
            assertz(patchDug(X,Y,0,'',0)),
            item(1, Crop, CropName),
            add(Crop, 1),
            format('You harvested a/an %s.', [CropName]),
            addExpFarm(15);
          write('It''s not riped yet!')
        );
      write('What are you trying to harvest?')
    ), nl, nl.

cheatHarvest :-
    playerKoord(X,Y),
    patchDug(X,Y,_,Name,_),
    (crops(Name,_,_) -> 
        retract(cropList(_, X, Y)),
        retract(patchDug(X, Y, _, _, _)),
        assertz(patchDug(X,Y,0,'',0)),
        item(1, Crop, Name),
        addExpFarm(15),
        add(Crop, 1);
      write('Developer ko nda tau tempat yang bisa diharvest.')
    ).
