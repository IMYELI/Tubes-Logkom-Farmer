% Not Yet a
:- use_module(library(random)).
:- dynamic(currentQuest/5).
:- dynamic(quest_status/1).
:- dynamic(panen_quest/7).
:- dynamic(ikan_quest/7).
:- dynamic(ranching_quest/7).


startQuest:- 
    \+quest_status(_),
    write('----------------------------------------------------------\n'),
    write('|                         QUEST                          |\n'),
    write('| Kamu akan menerima quest untuk mengumpulkan beberapa   |\n'),
    write('| harvest item, ikan, dan beberapa ranching item         |\n'),
    write('| 1. Terima dan lakukan quest                            |\n'),
    write('| 2. Batalkan                                            |\n'),
    write('----------------------------------------------------------\n'),
    write('Masukkan pilihan anda (terima. / batalkan.) : '),
    read(Response),
    (Response == terima) -> assert(quest_status(1));

/*Generate item*/

/*Show Quest Status*/
questStatus:- 
    \+quest_status(_),
    write('No active quest right now. Go to Q to receive quest'),nl,!.

questStatus:- 
    quest_status(_),
    write('You Need to Collect :'),nl,
    panen_quest(_) -> (write('-  harvest item'),nl),
    ikan_quest(_) -> (write('-  fish'),nl),
    ranching_quest(_) -> (write('-  ranching item'),nl).