:- dynamic(patchDug/7).
:- dynamic(patchID/1).

patchID(1).
%patchDug(ID,X,Y,Bool_Tanam,Nama_Plant,Season)

% plant :-
%     \+ inventoryList(4, _),
%     write('You don''t have any seeds to plant!');

%     write('You have:\n'),
%     findall(Name, inventoryList(4, Name), Names),
%     displayInventoryTwo(Names, 1),
%     length(Names, Len),
%     write('What do you want to plant?\n\n'),
%     write('>>> '),
%     catch(read(Input), error(_,_), errorMessage),(
%       integer(Input), Input > 0, Input =< Len ->
%         NInput is Input - 1,
%         nth0(NInput, Names, Element),
%         item(_, Element, Plant),
%         format('You planted a %s seed.', [Plant]),
%         throw(Name, 1);
%     write('Unknown input, try again!\n\n'), plant  
%     ).



dig :-
    playerKoord(X,Y),date(_,SEASON,_,_),season(SEASON,Z),
    (
      isPatch(X,Y) -> 
        patchID(ID),
        NID is ID + 1,
        asserta(patchDug(ID,X,Y,0,'',0,Z)),
        retract(patchID(_)),
        asserta(patchID(NID)),
        generateMap;
      write('You can not do that here!')
    ).

digL :-
    playerKoord(X,Y),date(_,SEASON,_,_),season(SEASON,Z),
    (
      isPatch(X,Y) -> 
        patchID(ID),
        NID is ID + 1,
        asserta(patchDug(ID,X,Y,0,'',0,Z)),
        retract(patchID(_)),
        asserta(patchID(NID)),
        NewX is X-1,
        (isPatch(NewX,Y)-> 
          NID2 is ID2 + 1,
          asserta(patchDug(ID2,NewX,Y,0,'',0,Z))),
          retract(patchID(_)),
          asserta(patchID(NID2)),
          generateMap;
      write('You can not do that here!')
    ).
digR :-
    playerKoord(X,Y),date(_,SEASON,_,_),season(SEASON,Z),
    (
      isPatch(X,Y) -> 
        patchID(ID),
        NID is ID + 1,
        asserta(patchDug(ID,X,Y,0,'',0,Z)),
        retract(patchID(_)),
        asserta(patchID(NID)),
        NewX is X+1,
        (isPatch(NewX,Y)->
          patchID(ID2),
          NID2 is ID2 + 1,
          asserta(patchDug(ID2,NewX,Y,0,'',0,Z))),
          retract(patchID(_)),
          asserta(patchID(NID2)),
          generateMap;
      write('You can not do that here!')
    ).
digT :-
    playerKoord(X,Y),date(_,SEASON,_,_),season(SEASON,Z),
    (
      isPatch(X,Y) -> 
        patchID(ID),
        asserta(patchDug(ID,X,Y,0,'',0,Z)),NewY is Y-1,
        NID is ID + 1,
        retract(patchID(_)),
        asserta(NID),
        (isPatch(X,NewY)->
          patchID(ID2),
          asserta(patchDug(ID2,X,NewY,0,'',0,Z))),
          NID2 is ID2 + 1,
          retract(patchID(_)),
          asserta(patchID(NID2)),
        generateMap;
      write('You can not do that here!')
    ).
digB :-
    playerKoord(X,Y),date(_,SEASON,_,_),season(SEASON,Z),
    (
      isPatch(X,Y) -> 
        patchID(ID),
        asserta(patchDug(ID,X,Y,0,'',0,Z)),NewY is Y+1,
        NID is ID + 1,
        retract(patchID(_)),
        asserta(NID),
          (isPatch(X,NewY)->
          patchID(ID2),
          asserta(patchDug(ID2,X,NewY,0,'',0,Z))),
          NID2 is ID2 + 1,
          retract(patchID(_)),
          asserta(patchID(NID2)),
          generateMap;
      write('You can not do that here!')
    ).

plant :-
  playerKoord(X,Y),
  (
    \+ isPatch(X,Y) -> 
      write('Oi, you have plot north to your house.');
    
     \+ inventoryList(4, _) ->
    write('You don''t have any seeds to plant!');

    patchDug(_,X,Y,_,_,_) ->
      plantCrop;
      
    write('Dig it first leh, why so lazy.')
    
  ).
    
update([]).
update([H|T]):-
  date(_, _, Month, _),
  season(Month, Season),
  patchDug(H,X,Y,Bool_Tanam,Nama_Plant, Time, SeasonPlant),
  crops(Nama_Plant, _, HarvestTime),
  (
    Season \== SeasonPlant ->
      retract(patchDug(H, _, _, _, _, _, _));
    Time < HarvestTime ->
      NTime is Time + 1,
      retract(patchDug(H, _, _, _, _, _, _)),
      assertz(patchDug(H,X,Y,Bool_Tanam,Nama_Plant, NTime, SeasonPlant));
    true
  ),
  update(T).

updateCrop :-
  findall(ID, patchDug(ID, _, _, _, _, _, _), IDs),
  update(IDs).

plantB :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(ID, X,Y,_,_,_)->retract(patchDug(ID, X,Y,_,_,_)),asserta(patchDug(ID, X,Y,1,'Carrot',0)),NewY is Y+1,(
        patchDug(ID, X,NewY,_,_,_)->retract(patchDug(ID, X,NewY,_,_,_)),asserta(patchDug(ID, X,NewY,1,'Carrot',0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantT :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(ID, X,Y,_,_,_)->retract(patchDug(ID, X,Y,_,_,_)),asserta(patchDug(ID, X,Y,1,'Carrot',0)),NewY is Y-1,(
        patchDug(ID, X,NewY,_,_,_)->retract(patchDug(ID, X,NewY,_,_,_)),asserta(patchDug(ID, X,NewY,1,'Carrot',0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantR :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(ID, X,Y,_,_,_)->retract(patchDug(ID,X,Y,_,_,_)),asserta(patchDug(ID,X,Y,1,'Carrot',0)),NewX is X+1,(
        patchDug(ID,NewX,Y,_,_,_)->retract(patchDug(ID,NewX,Y,_,_,_)),asserta(patchDug(ID,NewX,Y,1,'Carrot',0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).

plantL :- 
  playerKoord(X,Y),
  (\+isPatch(X,Y) -> write('Oi, you have plot north to your house.');
    patchDug(ID,X,Y,_,_,_)->retract(patchDug(ID,X,Y,_,_,_)),asserta(patchDug(ID,X,Y,1,'Carrot',0)),NewX is X-1,(
        patchDug(ID,NewX,Y,_,_,_)->retract(patchDug(ID,NewX,Y,_,_,_)),asserta(patchDug(ID,NewX,Y,1,'Carrot',0)),generateMap;
        generateMap);
    write('Dig it first leh, why so lazy.')).


errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
