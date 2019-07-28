session(s(0),[], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(1),[q(01)], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(2),[q(02),q(03),q(04),q(05),q(06),q(07)], []).
session(s(32),[q(08),q(09)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(33),[q(10)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(34),[q(11),q(12)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).



fluents([
    night,
    feed_animals(_),
    has(_,_),
    intention(_,_),
    motive(_,_),
    person(_),
    wants(_,_),
    xmasDay,
    is_hunter(_),
    animal(_),
    occassion(_),
    huntFor(_),
    gun(_),
    alive(_),
    nearby(_),
    out(_),
    place(_),
    longWalk(_,_),
    gunloaded(_)
]).



s(1) :: night at 0.
s(1) :: xmasEve at 0.
s(1) :: clean(pj,barn) at 0.
s(1) :: feed_animals(pj) at 0.
s(1) :: clean(pj,pjGun) at 0.
s(1) :: diff(farm,village) at 0.
s(1) :: diff(farm,city) at 0.
s(1) :: diff(city,farm) at 0.
s(1) :: diff(city,village) at 0.
s(1) :: diff(village,farm) at 0.
s(1) :: diff(village,city) at 0.
s(1) :: diff(village,city) at 0.
s(1) :: diff(city,countryside) at 0.
s(1) :: diff(city,near_forest) at 0.
s(1) :: diff(farm,near_shopping_centre) at 0.

s(1):: diff(home,barn) at 0.
s(1) :: person(pj) at 0.
s(1):: place(town) at 0.
s(1):: out(outPorch) at 0.

s(2) :: xmasDay at 1.
s(2) :: gun(pjGun) at 1.
s(2) :: occassion(dinner) at 1.
s(2) :: longWalk(pj,forest) at 1.
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


p(11) :: has(Person,home,barn) implies lives(Person,farm).
p(12) :: person(Person) implies -lives(Person,hotel).
p(13) :: person(Person) implies lives(Person,city).
p(14) :: has(home(Person),barn) implies -lives(Person,city).
p(15) :: clean(Person,Place) implies isAt(Person,Place).
p(16) :: isAt(Person,Place1), isAt(Person,Place) implies has(Person,Place1,Place).
p(17) :: xmasEve, night,person(Person) implies isAt(Person,home).
p(18) :: working(Person) implies -isAt(Person,home).
p(19) :: has(home(Person),reception_office) implies lives(Person,hotel).
p(190):: person(Person) implies lives(Person,village).
p(18) >> p(17).
p(14) >> p(13).
p(2000):: lives(Person,Place1),diff(Place1,Place2) implies -lives(Person,Place2).
p(2000) >> p(190).
p(2000) >> p(13).
p(2000) >> p(12).
p(11) >> p(2000).

p(21):: xmasEve,person(Person) implies -suitable_time(doDailyChores(Person)).
p(22)::	-suitable_time(doDailyChores(Person)),gun(Gun) implies -motive(clean1(Person,Gun),doDailyChores(Person)).
p(23):: ordinary_day,clean1(Person,Gun) implies motive(clean1(Person,Gun),doDailyChores(Person)).
p(24):: gun(Gun) implies -motive(clean1(Person,Gun),nothing_else_to_do(Person)).
p(25):: is_hunter(Person),nothing_else_to_do(Person),gun(Gun) implies motive(clean1(Person,Gun),nothing_else_to_do(Person)).
p(26):: has(Person,Gun),gun(Gun) implies is_hunter(Person).
p(226):: clean(Person,Gun) implies has(Person,Gun).
p(27):: goingTomeetFriends(Person),clean1(Person,Gun) implies motive(clean1(Person,Gun),show_off(Person,Gun,friends)).
p(28):: true implies -motive(clean1(Person,Gun),show_off(Person,Gun,friends)).
p(29):: intention(Person,huntFor(Occassion)),gun(Gun),occassion(Occassion) implies motive(clean1(Person,Gun),hunting).
p(30):: xmasDay,person(Person) implies wants(Person,food_for(dinner)).
p(301):: wants(Person,food_for(Occassion)),is_hunter(Person),occassion(Occassion) implies intention(Person,huntFor(Occassion)).
p(27) >> p(28).

p(332):: gun(Gun),out(Out) implies motive(clean(Person,Gun,Out),not_soil(home(Person))).
p(333):: dirty(home(Person)),gun(Gun),out(Out)  implies -motive(clean(Person,Gun,Out),not_soil(home(Person))).
p(334):: out(Out)  implies -motive(clean(Person,Gun,Out),afraid(Person,fired(Gun))).
p(335):: daytime,person(Person),gun(Gun),out(Out)  implies motive(clean(Person,Gun,Out),brighter_out).
p(336):: night,gun(Gun),person(Person),out(Out)  implies -motive(clean(Person,Gun,Out),brighter_out).
p(337):: goingTomeetFriends(Person),gun(Gun),out(Out)  implies motive(clean(Person,Gun,Out),waiting_friends(Person)).
p(338):: gun(Gun),out(Out)  implies -motive(clean(Person,Gun,Out), waiting_friends(Person)).

p(333) >> p(332).
p(335) >> p(334).
p(337) >> p(338).

p(39):: is_sick(Person),place(Place) implies -intention(Person,walk(Person,Place)).
p(40):: prepare(Person) implies intention(Person,walk(pj,town)).
p(41):: true implies -intention(Person,clean1(Person,bullets)).
p(42):: lives(Person,farm) implies -intention(Person,walk(pj,town)).
p(43):: lives(Person,farm) implies has(Person,animals).
p(44):: night implies intention(Person,go_to_bed(Person)).
p(45):: goingToMeetFriends(Person) implies -intention(Person,go_to_bed(Person)).
p(46):: has(Person,animals),feed_animals(Person) implies -intention(Person,feed_animals(Person)).
p(47):: has(Person,animals),-feed_animals(Person) implies intention(Person,feed_animals(Person)).

p(40) >> p(39).
p(40) >> p(42).
p(45) >> p(44).

p(103):: aim(Gun,X),person(Person),gun(Gun) implies -motive(walking(Person,forest),catch(X)).
p(52):: aim(Gun,X),gun(Gun),animal(X),person(Person) implies -motive(walking(Person,forest),hearBirdsChirp).
p(54):: longWalk(Person,Place) implies -motive(walking(Person,Place),practiceShooting).
p(56):: intention(Person,huntFor(Occassion)) implies motive(walking(Person,forest),huntFor(Occassion)).

c(31) :: aim(G,X), pulltrigger(G) causes firedat(G,X).
c(32) :: firedat(G,X), gun(G), animal(X) causes -alive(X).
p(33) :: firedat(G,X), gun(G), animal(X) causes noise.
c(34) :: noise, nearby(bird) causes -chirp(bird).
c(35) :: loadgun(G), gun(G) causes gunloaded(G).
p(31) :: -gunloaded(G), gun(G), animal(X) implies -firedat(G,X).
p(32) :: true implies -noise.
p(33) :: gun(G), animal(X) implies -firedat(G,X).

p(76):: -firedat(Gun,X),intention(Person,huntFor(Occassion)),pulltrigger(Gun),aim(Gun,X),occassion(Occassion),animal(X) implies motive(Person,wondering(-fire(Gun))).
p(77)::	aim(Gun,X),pulltrigger(Gun),gun(Gun),person(Person) implies  want_to_kill(Person,X).
p(78)::	want_to_kill(Person,X),animal(Y) implies -motive(Person,feeling_sorry(Person,X,Y)).
p(90):: feed_animals(Person) implies -motive(Person,wondering(if_close(Person,barn_door))).

p(80)::	-firedat(Gun,X), aim(Gun,X),person(Person) implies -shoot(Person,X).
p(89)::	-shoot(Person,X),animal(Y),animal(X) implies -motive(Person,wondering_should_shoot(Person,Y)).

p(91):: -firedat(Gun,X),intention(Person,huntFor(Occassion)),occassion(Occassion),animal(X) implies motive(was_confused(Person),not_fired(Gun)).
p(92):: alive(X), alive(Y),person(Person) implies -motive(was_confused(Person),dead(X,Y)).
p(96):: -alive(X), -alive(Y), love(Person,animals) implies motive(was_confused(Person),dead(X,Y)).
p(93):: -firedat(Gun,X),animal(X),person(Person) implies -motive(was_confused(Person),made_unusually_noise(Gun)).
p(95):: firedat(Gun,X), unusually_noise(Gun),person(Person),animal(X) implies motive(was_confused(Person),made_unusually_noise(Gun)).
p(94):: is_hunter(Person),intention(Person,huntFor(Occassion)),occassion(Occassion) implies -motive(was_confused(Person),more_birds_arrived).


% Domain-independent preferences (can be modified if needed).
i(0) >> p(_).    % persistence overrides property.
c(_) >> i(0).    % causal overrides persistence.
o(0) >> _ on _.  % observation disputes everything.

% Knowledge-specific preferences.
p(14) >> p(13).

p(31) >> c(31).
c(34) >> p(33) on noise.
p(33) >> p(32).
c(31) >> p(33).
i(0) >> _ on gun(_).
i(0) >> _ on animal(_).

% Story-specific preferences.
p(33) >> c(31) on firedat(pjGun,_).



q(01) ?? lives(pj,city) at 0 ;
         lives(pj,hotel) at 0 ;
	 lives(pj,farm) at 0;
         lives(pj,village) at 0.

q(02) ?? motive(clean1(pj,pjGun),nothing_else_to_do(pj)) at 1;
	 motive(clean1(pj,pjGun),doDailyChores(pj))at 1;
	 motive(clean1(pj,pjGun),show_off(pj,pjGun,friends))at 1;
         motive(clean1(pj,pjGun),hunting)at 1.

q(03) ?? motive(clean(pj,pjGun,outPorch),not_soil(home(pj))) at 1;
         motive(clean(pj,pjGun,outPorch),afraid(pj,fired(pjGun))) at 1;
	 motive(clean(pj,pjGun,outPorch),brighter_out) at 1;
	 motive(clean(pj,pjGun,outPorch),waiting_friends(pj)) at 1.

q(04) ?? intention(pj,feed_animals(pj)) at 1;
         intention(pj,go_to_bed(pj)) at 1;
	 intention(pj,walk(pj,town)) at 1;
	 intention(pj,clean1(pj,bullets)) at 1.

q(05) ?? gunloaded(pjGun) at 1;
      -gunloaded(pjGun) at 1.


q(06) ?? motive(walking(pj,forest),practiceShooting) at 2 ;
         motive(walking(pj,forest),huntFor(dinner)) at 2 ;
         (motive(walking(pj,forest),catch(turkey1)) at 2, motive(walking(pj,forest),catch(turkey2)) at 2) ;
         motive(walking(pj,forest),hearBirdsChirp) at 2.

q(07) ?? (alive(turkey1) at 4, alive(turkey2) at 4) ;
         (alive(turkey1) at 4, -alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, -alive(turkey2) at 4).

q(08) ?? (alive(turkey1) at 5, alive(turkey2) at 5) ;
         (alive(turkey1) at 5, -alive(turkey2) at 5) ;
         (-alive(turkey1) at 5, alive(turkey2) at 5) ;
         (-alive(turkey1) at 5, -alive(turkey2) at 5).

q(09) ?? motive(pj,wondering(-fire(pjGun))) at 5;
         motive(pj,feeling_sorry(pj,turkey1,turkey2)) at 5;
         motive(pj,wondering(if_close(pj,barn_door))) at 5;
         motive(pj,wondering_should_shoot(pj,turkey2)) at 5.

q(10) ?? (alive(turkey1) at 10, alive(turkey2) at 10) ;
         (alive(turkey1) at 10, -alive(turkey2) at 10) ;
         (-alive(turkey1) at 10, alive(turkey2) at 10) ;
         (-alive(turkey1) at 10, -alive(turkey2) at 10).

q(11) ?? (alive(turkey1) at 11, alive(turkey2) at 11) ;
         (alive(turkey1) at 11, -alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, -alive(turkey2) at 11).

q(12) ?? motive(was_confused(pj),not_fired(pjGun)) at 12;
         motive(was_confused(pj),dead(turkey1,turkey2)) at 12;
         motive(was_confused(pj),more_birds_arrived) at 12;
         motive(was_confused(pj),made_unusually_noise(pjGun)) at 12.
