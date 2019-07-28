session(s(0),[], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(1),[q(01)], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(2),[q(06)], [xmasDay,longWalk(_),motive(_,_),want(_,_),huntFor(_),firedat(_,_)]).
session(s(31),[q(07)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(32),[q(08)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(33),[q(09)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(34),[q(10)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).


fluents([
%    night,
%    xmasEve,
%    has(_,_),
%    lives(_,_),
%    isAt(_,_),
%    working(_),
%
   motive(_,_),
%
   animal(_),
   gun(_),
%   firedat(_,_),
   alive(_),
%   noise,
   nearby(_),
%   chirp(_),
   gunloaded(_)
]).



s(1) :: night at 0.
s(1) :: xmasEve at 0.
s(1) :: clean(pj,barn) at 0.

s(2) :: xmasDay at 1.
s(2) :: gun(pjGun) at 1.
s(2) :: longWalk(pj) at 1.
s(2) :: animal(turkey1) at 2.
s(2) :: animal(turkey2) at 2.
s(2) :: alive(turkey1) at 2.
s(2) :: alive(turkey2) at 2.
s(2) :: chirp(bird) at 2.
s(2) :: nearby(bird) at 2.
s(2) :: aim(pjGun,turkey1) at 2.
s(2) :: pulltrigger(pjGun) at 2.

s(32) :: -gunloaded(pjGun) at 5.
s(32) :: loadgun(pjGun) at 6.

s(33) :: aim(pjGun,turkey1) at 7.
s(33) :: pulltrigger(pjGun) at 7.

s(34) :: nearby(bird) at [2,11].
s(34) :: chirp(bird) at [2,11].




p(11) :: has(home(pj),barn) implies lives(pj,countrySide).
p(12) :: true implies -lives(pj,hotel).
p(13) :: true implies lives(pj,city).
p(14) :: has(home(pj),barn) implies -lives(pj,city).
p(15) :: clean(pj,barn) implies isAt(pj,barn).
p(16) :: isAt(pj,home), isAt(pj,barn) implies has(home(pj),barn).
p(17) :: xmasEve, night implies isAt(pj,home).
p(18) :: working(pj) implies -isAt(pj,home).

p(111) :: lives(pj,countrySide) implies lives(pj,village).
p(112) :: lives(pj,countrySide) implies lives(pj,farm).
p(113) :: lives(pj,village) implies -lives(pj,farm).
p(114) :: lives(pj,farm) implies -lives(pj,village).
%p(115) :: lives(pj,village), lives(pj,farm) implies -true.


p(18) >> p(17).
%p(114) >> p(111). not needed
%p(113) >> p(112).

p(21) :: want(pj,foodFor(dinner)) implies motive(walking(pj,forest),huntFor(food)).
p(22) :: hunter(pj) implies motive(walking(pj,forest),huntFor(food)).
p(23) :: firedat(pjGun,X), animal(X) implies -motive(walking(pj,forest),catch(X)).
p(24) :: firedat(pjGun,X), animal(X) implies -motive(walking(pj,forest),hearBirdsChirp).
p(25) :: xmasDay implies want(pj,foodFor(dinner)).
p(26) :: longWalk(pj) implies -motive(walking(pj,forest),practiceShooting).


c(31) :: aim(G,X), pulltrigger(G) causes firedat(G,X).
c(32) :: firedat(G,X), gun(G), animal(X) causes -alive(X).
p(33) :: firedat(G,X), gun(G), animal(X) causes noise.
c(34) :: noise, nearby(bird) causes -chirp(bird).
c(35) :: loadgun(G), gun(G) causes gunloaded(G).
p(31) :: -gunloaded(G), gun(G), animal(X) implies -firedat(G,X).
p(32) :: true implies -noise.
p(33) :: gun(G), animal(X) implies -firedat(G,X).


% Domain-independent preferences (can be modified if needed).
i(0) >> p(_).    % persistence overrides property.
c(_) >> i(0).    % causal overrides persistence.
o(0) >> _ on _.  % observation disputes everything.

% Knowledge-specific preferences.
p(14) >> p(13).

p(31) >> c(31).
c(34) >> p(33) on noise.        y.

p(33) >> p(32).
c(31) >> p(33).
i(0) >> _ on gun(_).
i(0) >> _ on animal(_).

% Story-specific preferences.
p(33) >> c(31) on firedat(pjGun,_).



q(1) ?? lives(pj,city) at 0 ;
         lives(pj,hotel) at 0 ;
         lives(pj,countrySide) at 0;
         lives(pj,farm) at 0;
         lives(pj,village) at 0.

q(2) ?? motive(walking(pj,forest),practiceShooting) at 3 ;
         motive(walking(pj,forest),huntFor(food)) at 3 ;
         (motive(walking(pj,forest),catch(turkey1)) at 3, motive(walking(pj,forest),catch(turkey2)) at 3) ;
         motive(walking(pj,forest),hearBirdsChirp) at 3.

q(3) ?? (alive(turkey1) at 4, alive(turkey2) at 4) ;
         (alive(turkey1) at 4, -alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, -alive(turkey2) at 4).

q(4) ?? (alive(turkey1) at 5, alive(turkey2) at 5) ;
         (alive(turkey1) at 5, -alive(turkey2) at 5) ;
         (-alive(turkey1) at 5, alive(turkey2) at 5) ;
         (-alive(turkey1) at 5, -alive(turkey2) at 5).

q(5) ?? (alive(turkey1) at 10, alive(turkey2) at 10) ;
         (alive(turkey1) at 10, -alive(turkey2) at 10) ;
         (-alive(turkey1) at 10, alive(turkey2) at 10) ;
         (-alive(turkey1) at 10, -alive(turkey2) at 10).

q(6) ?? (alive(turkey1) at 11, alive(turkey2) at 11) ;
         (alive(turkey1) at 11, -alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, -alive(turkey2) at 11).
