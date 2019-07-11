% ================ Story in STAR Syntax ================


% Francis bought a pie at the grocery store.

% He decided to eat the entire pie at once.

% Francis felt sick after eating the pie.

% He began to regret eating the pie.

% Francis decided to eat pies more gradually in the future.


session(s(0),[],all).

session(s(1),[q(1)],all).



s(0) :: is_person(francis) at always.

s(0) :: is_pie(pie) at always.


s(1) :: buy(francis,pie) at 1.

s(1) :: decide(francis,eat(pie)) at 2.

s(1) :: is_entire(pie) at 2.

s(1) :: felt(francis,sick) at 3.

s(1) :: began(francis,regret, eat(pie)) at 4.

s(1) :: decide(francis,eat_gradually(pie)) at 5.

q(1) ?? wants(francis, ease(sick, pie)) at 1.

fluents([
     buy(_,_),
     decide(_,_),
     is_entire(_),
     felt(_,_),
     began(_,_,_),
     is_person(_),
     is_pie(_),
     eat(_),
     eat_gradually(_),
     wants(_,_),
     ease(_,_)
    ]).

p(1) :: buy(Person, pie) implies decide(Person, eat(pie)).
c(2) :: decide(Person, eat(pie)), is_entire(pie) causes felt(Person, sick).
c(3) :: felt(Person, sick), decide(Person, eat(pie)) causes began(Person, regret, eat(pie)).
c(4) :: began(Person, regret, eat(pie)) causes decide(Person, eat_gradually(pie)).
p(5) :: decide(Person, eat_gradually(pie)), felt(Person, sick) implies wants(Person, ease(sick, pie)).
