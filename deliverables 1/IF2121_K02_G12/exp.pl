
:- dynamic(job/2).

initJob :-
  asserta(job(1, fisherman)),
  asserta(job(2, farmer)),
  asserta(job(3, rancher)).