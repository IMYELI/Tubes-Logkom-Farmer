:- dynamic(date/4).
:- dynamic(isWrite/1).
:- dynamic(diary/5).
:- dynamic(diaryID/5).

/* diary(ID, Content, Day, Month, Year) */

/* date(Total, Day, Month, Year) */
date(1, 1, 1, 1).

/* diaryID */
diaryID(1).

/* season (Month, Season) */
season(1, 'Spring').
season(2, 'Summer').
season(3, 'Fall').
season(4, 'Winter').


houseMenu :-
    nl, 
    write('======= HOUSE ======='), nl,
    write('What do you want to do?'), nl,
    write('- sleep'), nl,
    write('- writeDiary'), nl,
    write('- readDiary'), nl,
    write('- exit'), nl,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
            Input = 'sleep' -> call(sleep);
            Input = 'writeDiary' -> call(writeDiary);
            Input = 'readDiary' -> call(readDiary);
            Input = 'exit' -> call(exit);

            write('Unknown input, try again!'), nl, houseMenu
    ).

updateDay :-
    date(Total, Day, Month, Year),
    NTotal is Total + 1,
    TempDay is Day + 1,
    (
      TempDay = 29 ->
      NDay is 1,
      (
        Month = 1 -> NMonth is 2, NYear is Year;
        Month = 2 -> NMonth is 3, NYear is Year;
        Month = 3 -> NMonth is 4, NYear is Year;
        Month = 4 -> NMonth is 1, NYear is Year + 1
      );

      NDay is Day + 1,
      NMonth is Month,
      NYear is Year
    ),
    retract(date(Total, Day, Month, Year)),
    asserta(date(NTotal, NDay, NMonth, NYear)).
  
writeDiary :-
    date(_, Day, Month, Year),
    diaryID(ID),
    write('Write your diary for Day '), write(Day), nl,
    write('>>> '),
    read(Input),
    assertz(diary(ID, Input, Day, Month, Year)),
    newID is ID + 1,
    retract(diaryID(_)),
    asserta(diaryID(newID)).

displayDiary([]).
displayDiary([H|T]) :-
  diary(H, _, Day, Month, Year),
  season(Month, Season),
  write(H),
  write('.  Day '), write(Day), write(', '), 
  write(Season), write(', Year '), write(Year), nl,
  displayDiary(T).

readDiary :-
    findall(ID, diary(ID, _, _, _ ,_), IDs),
    write('Entry Diary: '), nl,
    displayDiary(IDs),
    length(IDs, Len),
    write('Which entry do you want to read?'), nl, nl,
    write('>>> '),
    catch(read(Input), error(_,_), errorMessage), (
      integer(Input), Input > 0, Input =< Len ->
        write('Here is your entry:'),
        diary(Input, Content, _, _, _),
        write(Content);
      write('Unknown input, try again!'), nl, nl, readDiary
    ).
    
sleep :-
    write('You sleep on the bed, waiting for the next day.'), nl,
    write('Zzzz.....'), nl, nl,
    updateDay,
    date(Total, Day, Month, Year),
    season(Month, Season),
    write('======= NEXT DAY ======='), nl,
    write('Day: '), write(Day), nl,
    write('Season: '), write(Season), nl,
    write('Year: '), write(Year), nl.

errorMessage:-
    write('[ERROR] Something''s wrong with your input, exiting the program..'), halt.