:- dynamic(patchDug/2).
plant :-
    \+ inventoryList(4, _),
    write('You don''t have any seeds to plant!');

    write('You have:\n'),
    findall(Name, inventoryList(4, Name), Names),
    displayInventoryTwo(Names, 1),
    length(Names, Len),
    write('What do you want to plant?\n\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage),(
      integer(Input), Input > 0, Input =< Len ->
        NInput is Input - 1,
        nth0(NInput, Names, Element),
        item(_, Element, Plant),
        format('You planted a %s seed.', [Plant]),
        throw(Name, 1);
    write('Unknown input, try again!\n\n'), plant  
    ).

dig :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),generateMap;
      write('You can not do that here!')
    ).

digL :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),NewX is X-1,
        (isPatch(NewX,Y)->asserta(patchDug(NewX,Y))),generateMap;
      write('You can not do that here!')
    ).
digR :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),NewX is X+1,
        (isPatch(NewX,Y)->asserta(patchDug(NewX,Y))),generateMap;
      write('You can not do that here!')
    ).
digT :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),NewY is Y-1,
        (isPatch(X,NewY)->asserta(patchDug(X,NewY))),generateMap;
      write('You can not do that here!')
    ).
digB :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),NewY is Y+1,
        (isPatch(X,NewY)->asserta(patchDug(X,NewY))),generateMap;
      write('You can not do that here!')
    ).
digS :-
    playerKoord(X,Y),
    (
      isPatch(X,Y) -> asserta(patchDug(X,Y)),NewY is Y+1,NewY2 is Y-1,NewX is X+1,NewX2 X-1,
        (isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
            isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)
                );
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(NewX,Y)->asserta(patchDug(NewX,Y))
                )
            );
            isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                );
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                )
            );
            isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(NewX,Y)->asserta(patchDug(NewX,Y))
                );
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                )
            )   
        );
         isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
            isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                );
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                )
            );
            isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                );
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            );
            isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(NewX,Y)->asserta(patchDug(NewX,Y))
                );
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            )
         );
         isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
            isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                );
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                )
            );
            isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y))
                );
                isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            );
            isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                );
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            )
         );
         isPatch(NewX2,Y)->asserta(patchDug(NewX2,Y)),(
            isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(NewX,Y)->asserta(patchDug(NewX,Y))
                );
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                )
            );
            isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(NewX,Y)->asserta(patchDug(NewX,Y))
                );
                isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            );
            isPatch(NewX,Y)->asserta(patchDug(NewX,Y)),(
                isPatch(X,NewY)->asserta(patchDug(X,NewY)),(
                    isPatch(X,NewY2)->asserta(patchDug(X,NewY2))
                );
                isPatch(X,NewY2)->asserta(patchDug(X,NewY2)),(
                    isPatch(X,NewY)->asserta(patchDug(X,NewY))
                )
            )
         )
         ),generateMap;
      write('You can not do that here!')
    ).


errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'),
    halt.
