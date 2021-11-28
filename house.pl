/* Deklarasi Rules */
houseMenu :-
    write('======= Welcome To Your House =======\n'),
    write('What do you want to do?\n'),
    write('- sleep\n'),
    write('- writeDiary\n'),
    write('- readDiary\n'),
    write('- exit\n\n'),
    write('HOUSE >>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
            Input = 'sleep' -> call(sleep);
            Input = 'writeDiary' -> call(writeDiary);
            Input = 'readDiary' -> call(readDiary);
            Input = 'status' -> call(status), houseMenu;
            Input = 'inventory' -> call(inventory), houseMenu;
            Input \== 'exit' -> write('Unknown input, try again!\n\n'), houseMenu;
            write('You have exited the house. Good Luck!\n\n')
    ).


updateDay :-
    date(Total, Day, Month),
    NTotal is Total + 1,
    TempDay is Day + 1,
    (
      TempDay = 4 ->
      NDay is 1,
      (
        Month = 1 -> NMonth is 2;
        Month = 2 -> NMonth is 3;
        Month = 3 -> NMonth is 4;
        Month = 4 -> NMonth is 5
      );

      NDay is Day + 1,
      NMonth is Month
    ),
    updateCrop,
    updateRanch,
    updateFishingCount,
    retract(date(Total, Day, Month)),
    asserta(date(NTotal, NDay, NMonth)).
  
writeDiary :-
    date(_, Day, Month),
    diaryID(ID),
    format('======= Write Your Diary For Day %d =======\n', [Day]),
    write('>>> '),
    read(Input), nl,
    write('You have written a diary.\n\n'),
    assertz(diary(ID, Input, Day, Month)),
    retract(diaryID(_)),
    NID is ID + 1,
    asserta(diaryID(NID)), houseMenu.

displayDiary([]).
displayDiary([H|T]) :-
  diary(H, _, Day, Month, Year),
  season(Month, Season),
  write(H),
  write('.  Day '), write(Day), write(', '), 
  write(Season), write(', Year '), write(Year), nl,
  displayDiary(T).

readDiary :-
    \+ diary(_, _, _, _, _),
    write('You haven''t write any diary yet!\n\n'), houseMenu;

    findall(ID, diary(ID, _, _, _), IDs),
    write('Entry Diary:\n'),
    displayDiary(IDs),
    length(IDs, Len), nl,
    write('Which entry do you want to read?\n'),
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), nl,
    (
      integer(Input), Input > 0, Input =< Len ->
        write('Here is your entry:\n'),
        diary(Input, Content, _, _),
        format('"%s"\n\n', [Content]),
        houseMenu;
      write('Unknown input, try again!\n\n'), readDiary
    ).

failDebt :-
    write('==================== YOUR DEBT IS OVERDUE ======================\n'),
    write('You have worked hard, but in the end result is all that matters.\n'),
    write('May God bless you in the future with kind people!\n'),
    write('================================================================\n'),
    write('Input anything to go back to the Main Menu: '), read(_), nl,
    startGame.

sleep :-
    write('You sleep on the bed, waiting for the next day.'), nl,
    write('Zzzz.....'), nl, nl,
    updateDay,
    date(_, Day, Month),
    season(Month, Season),
    (
        Month = 5 -> failDebt;

        write('======= Good Morning For A New Day! =======\n'),
        format('Day: %d\n', [Day]),
        format('Season: %s\n', [Season]),
        write('===========================================\n'),
        nl, houseMenu
    ).

