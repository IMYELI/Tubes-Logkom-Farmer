
:- dynamic(job/2).

initJob :-
  asserta(job(1, Fisherman)),
  asserta(job(2, Farmer)),
  asserta(job(3, Rancher)).