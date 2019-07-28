session(s(0),[], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(1),[q(01)], [clean(_,_),night,xmasEve,has(_,_),lives(_,_),isAt(_,_),working(_)]).
session(s(2),[q(02),q(03),q(04),q(05),q(06),q(07)], []).
session(s(21),[q(08)], []).
session(s(33),[q(09),q(10)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).
session(s(34),[q(11)],[firedat(_,turkey1),alive(turkey1),noise,chirp(_),gunloaded(_),aim(_,turkey1),pulltrigger(_),loadgun(_)]).



fluents([
    night,
    feed_animals(_),
    has(_,_,_),
    clean1(_,_,_),
    intention(_,_),
    motive(_,_),
    person(_),
    aim(_,_),
    pulltrigger(_),
    firedat(_,_),
    wants(_,_),
    xmasDay,
    is_hunter(_),
    animal(_),
    occassion(_),
    huntFor(_),
    gun(_),
    isAt(_,_),
    alive(_),
    nearby(_),
    out(_),
    place(_),
    alone(_),
    xmasEve,
    noise,
    goingTomeetFriends(_),
    longWalk(_,_),
    has_many_animals(_),
    usually_do_loud_noise(_),
want_safety(_),
    gunloaded(_),
    loadgun(_)
]).



s(1) :: night at 0.
s(1) :: xmasEve at 0.
s(1) :: clean(pj,barns) at 0.
s(1) :: feed_animals(pj) at 0.
s(1) :: gun(pjGun) at 0.
s(1) :: on_fireplace(pjGun) at 0.
s(1) :: clean1(pj,pjGun,outPorch) at 0.
s(1) ::	has(pj,pjGun,young) at 0.
s(1) :: usually_do_loud_noise(pjGun) at 0.
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
s(1):: place(forest) at 0.
s(1):: out(outPorch) at 0.

s(2) :: xmasDay at 1.
s(2) :: occassion(dinner) at 1.
s(2) :: longWalk(pj,forest) at 1.
s(2) :: animal(turkey1) at 2.
s(2) :: animal(turkey2) at 2.
s(2) :: chirp(bird) at 2.
s(2) :: nearby(bird) at 2.
s(2) :: aim(pjGun,turkey1) at 2.
s(2) :: pulltrigger(pjGun) at 2.

s(21) :: -gunloaded(pjGun) at 5.
s(33) :: loadgun(pjGun) at 6.

s(33) :: aim(pjGun,turkey1) at 7.
s(33) :: pulltrigger(pjGun) at 7.

s(34) :: nearby(bird) at [2,11].
s(34) :: chirp(bird) at [2,11].


%erotisi 1
p(1) :: has(Person,home,barns) implies lives(Person,farm).
p(2) :: has(Person,home,barns) implies -lives(Person,city).
p(3) :: has(Person,home,barns) implies -lives(Person,hotel).
p(4) :: clean(Person,Place) implies isAt(Person,Place).
p(5) :: isAt(Person,Place1), isAt(Person,Place) implies has(Person,Place1,Place).
p(6) :: xmasEve, night,person(Person) implies isAt(Person,home).
p(7) :: person(Person) implies lives(Person,farm).
p(8) ::	clean1(X,Y,outPorch),gun(Y) implies -isAt(X,farm).
p(9) ::	isAt(Person,home), -isAt(Person,Y) implies -lives(Person,Y).
p(10):: has(Person,home,barn) implies lives(Person,village).
p(11):: on_fireplace(Gun),person(Person),gun(Gun) implies isAt(Person,village).
p(12):: isAt(Person,X), isAt(Person,home) implies lives(Person,X).
p(13):: xmasEve,clean1(X,Gun,Y),gun(Gun),out(Y) implies alone(X).
p(14):: clean(X,barns) implies has_many_animals(X).
p(15):: has_many_animals(X) implies -lives(X,village).


p(16):: xmasEve,gun(Gun),person(Person) implies -motive(clean2(Person,Gun),nothing_else_to_do(Person)).
p(17):: alone(Person),gun(Gun) implies motive(clean2(Person,Gun),nothing_else_to_do(Person)).
p(19):: has(Person,Gun,Young),gun(Gun) implies is_hunter(Person).
p(20):: is_hunter(Person),gun(Gun) implies motive(clean2(Person,Gun),hunting).
p(20):: xmasEve,person(Person),gun(Gun) implies -motive(clean2(Person,Gun),hunting).
p(21):: alone(Person),gun(Gun) implies -motive(clean2(Person,Gun),show_off(Person,Gun,friends)).
p(22):: goingTomeetFriends(Person),clean1(Person,Gun,Out),out(Out) implies motive(clean2(Person,Gun),show_off(Person,Gun,friends)).
p(23):: xmasEve,person(Person) implies	goingTomeetFriends(Person).
p(24):: xmasEve,person(Person) implies -suitable_time(doDailyChores(Person)).
p(25)::	-suitable_time(doDailyChores(Person)),gun(Gun) implies -motive(clean2(Person,Gun),doDailyChores(Person)).
p(26):: do_ordinary_chores(Person),gun(Gun) implies motive(clean2(Person,Gun),doDailyChores(Person)).
p(27):: clean(X,barns), clean1(X,Gun,Z),gun(Gun),out(Z) implies do_ordinary_chores(X).


p(28):: xmasEve, gun(Gun),out(Out) implies -motive(clean3(Person,Gun,Out),not_soil(home(Person))).
p(29):: gun(Gun),out(Out) implies motive(clean3(Person,Gun,Out),not_soil(home(Person))).
p(30):: night,gun(Gun),person(Person),out(Out)  implies -motive(clean3(Person,Gun,Out),brighter_out).
p(52):: out(Out),person(Person),gun(Gun)  implies motive(clean3(Person,Gun,Out),brighter_out).
p(53):: goingTomeetFriends(Person),gun(Gun),out(Out)  implies motive(clean3(Person,Gun,Out),waiting_friends(Person)).
p(54):: goingTomeetFriends(Person),gun(Gun),out(Out)  implies -motive(clean3(Person,Gun,Out),waiting_friends(Person)).
p(55):: has(Person,Gun,young),out(Out)  implies -motive(clean3(Person,Gun,Out),afraid_of_firing).
p(56):: usually_do_loud_noise(Gun),out(Out) implies motive(clean3(Person,Gun,Out),afraid_of_firing).

p(34):: true implies -intention(Person,clean3(Person,bullets)).
p(35):: clean1(Person,Gun,Out),gun(Gun),out(Out) implies intention(Person,clean3(Person,bullets)).
p(36):: lives(Person,farm) implies -intention(Person,walk(Person,town)).
p(37):: goingTomeetFriends(Person) implies -intention(Person,walk(Person,town)).
p(38):: xmasEve implies intention(Person,walk(Person,town)).
p(39):: goingTomeetFriends(Person) implies -intention(Person,go_to_bed(Person)).
p(40):: night implies intention(Person,go_to_bed(Person)).
p(41):: has_many_animals(Person),feed_animals(Person) implies -intention(Person,feed_animals(Person)).


p(42):: lives(Person,farm), alone(Person) implies want_safety(Person).
p(43):: want_safety(Person),has(Person,Gun,Young),gun(Gun) implies has_bullets(Gun).
p(44):: gun(Gun) implies -has_bullets(Gun).
p(45):: clean1(Person,Gun,Out),out(Out),person(Person) implies -has_bullets(Gun).

p(46):: intention(Person,huntFor(Occassion)) implies motive(walking(Person,forest),huntFor(Occassion)).
p(47):: xmasDay,person(Person),occassion(Occassion) implies intention(Person,huntFor(Occassion)).
p(48):: xmasDay,person(Person)  implies -motive(walking(Person,forest),practiceShooting).
p(49):: aim(Gun,X),person(Person),gun(Gun) implies  -motive(walking(Person,forest),practiceShooting).
p(50):: aim(Gun,X),person(Person),gun(Gun) implies -motive(walking(Person,forest),catch(X)).
p(51):: aim(Gun,X),person(Person),gun(Gun) implies -motive(walking(Person,forest),hearBirdsChirp).


p(57) :: aim(G,X), pulltrigger(G) implies alive(X).
p(58) :: aim(G,X), pulltrigger(G),animal(Y) implies alive(Y).

c(31) :: aim(G,X), pulltrigger(G) causes firedat(G,X).
c(32) :: firedat(G,X), gun(G), animal(X) causes -alive(X).


p(61):: -gunloaded(Gun),aim(Gun,X) implies alive(X).
p(67):: -gunloaded(G) implies -fired(G).
p(80):: -gunloaded(G),animal(X) implies -fired(G,X).

p(69):: aim(G,turkey1) implies -firedat(G,turkey2).


p(72):: loadgun(Gun) implies aim(Gun,turkey2).

p(75):: chirp(bird) implies -noise.
p(76):: chirp(bird),away(bird),gun(Gun),animal(X) implies fired(G,X).
p(77):: chirp(bird),away(bird),gun(Gun),animal(X) implies -fired(G,X).


p(62):: person(Person) implies motive(Person,wondering_if_close_barn_door).
p(64):: aim(G,X),gun(Gun),animal(X),person(Person) implies intention(Person,hunting).
p(63):: intention(Person,hunting) implies -motive(Person,wondering_if_close_barn_door).
p(65):: -fired(Gun),intention(Person,hunting) implies motive(Person,wondering(-fire(Gun))).
p(66):: -gunloaded(Gun),person(Person) implies -motive(Person,wondering(-fire(Gun))).
p(67)::	aim(Gun,X),pulltrigger(Gun),gun(Gun),person(Person) implies  want_to_kill(Person,X).
p(68)::	want_to_kill(Person,X),animal(Y) implies -motive(Person,feeling_sorry(Person,X,Y)).
p(69)::	aim(Gun,X),animal(X),animal(Y),gun(Gun),has_many_animals(Person) implies motive(Person,feeling_sorry(Person,X,Y)).
p(71):: firedat(G,X),animal(X),gun(G),person(Person) implies motive(Person,wondering_should_shoot_other).
p(70):: -gunloaded(Gun),gun(Gun),person(Person) implies -motive(Person,wondering_should_shoot_other).



%erotisi 12

p(90):: -firedat(G,X),animal(Y) implies -motive(was_confused(Person),dead(X,Y)).
p(91):: -alive(X), -alive(Y) implies motive(was_confused(Person),dead(X,Y)).
p(92):: -noise, person(Person) implies -motive(was_confused(Person),made_unusually_noise).
p(93):: person(Person),earache(Person) implies motive(was_confused(Person),made_unusually_noise).
p(94):: person(Person) implies -motive(was_confused(Person),more_birds_arrived).
p(95):: person(Person) implies -motive(was_confused(Person),not_fired_gun).
p(96):: chirp(bird),-fired(G,X),gun(Gun),animal(X) implies motive(was_confused(Person),not_fired_gun).


% Domain-independent preferences (can be modified if needed).
i(0) >> p(_).    % persistence overrides property.
c(_) >> i(0).    % causal overrides persistence.
o(0) >> _ on _.  % observation disputes everything.

% Knowledge-specific preferences.

i(0) >> _ on gun(_).
i(0) >> _ on animal(_).

% Story-specific preferences.
p(33) >> c(31) on firedat(pjGun,_).



q(01) ?? lives(pj,city) at 0 ;
         lives(pj,hotel) at 0 ;
	 lives(pj,farm) at 0;
	 lives(pj,village) at 0.

q(02) ?? motive(clean2(pj,pjGun),nothing_else_to_do(pj)) at 1;
	 motive(clean2(pj,pjGun),doDailyChores(pj))at 1;
	 motive(clean2(pj,pjGun),show_off(pj,pjGun,friends))at 1;
         motive(clean2(pj,pjGun),hunting)at 1.

q(03) ?? motive(clean3(pj,pjGun,outPorch),not_soil(home(pj))) at 1;
         motive(clean3(pj,pjGun,outPorch),afraid_of_firing) at 1;
	 motive(clean3(pj,pjGun,outPorch),brighter_out) at 1;
	 motive(clean3(pj,pjGun,outPorch),waiting_friends(pj)) at 1.

q(04) ?? intention(pj,feed_animals(pj)) at 1;
         intention(pj,go_to_bed(pj)) at 1;
	 intention(pj,walk(pj,town)) at 1;
	 intention(pj,clean3(pj,bullets)) at 1.

q(05) ?? has_bullets(pjGun) at 1;
        -has_bullets(pjGun) at 1.


q(06) ?? motive(walking(pj,forest),practiceShooting) at 2 ;
         motive(walking(pj,forest),huntFor(dinner)) at 2 ;
         (motive(walking(pj,forest),catch(turkey1)) at 2, motive(walking(pj,forest),catch(turkey2)) at 2) ;
         motive(walking(pj,forest),hearBirdsChirp) at 2.

q(07) ?? (alive(turkey1) at 4, alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, alive(turkey2) at 4) ;
         (-alive(turkey1) at 4, -alive(turkey2) at 4).

q(08) ?? (alive(turkey1) at 5, alive(turkey2) at 5) ;
         (-alive(turkey1) at 5, alive(turkey2) at 5) ;
	 (-alive(turkey1) at 5, -alive(turkey2) at 5).


q(09) ?? motive(pj,wondering(-fire(pjGun))) at 5;
         motive(pj,feeling_sorry(pj,turkey1,turkey2)) at 5;
         motive(pj,wondering_if_close_barn_door) at 5;
         motive(pj,wondering_should_shoot_other) at 5.

q(10) ?? (alive(turkey1) at 10, alive(turkey2) at 10) ;

         (-alive(turkey1) at 10, alive(turkey2) at 10) ;
	 (-alive(turkey1) at 10, -alive(turkey2) at 10).


q(11) ?? (alive(turkey1) at 11, alive(turkey2) at 11) ;
         (alive(turkey1) at 11, -alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, alive(turkey2) at 11) ;
         (-alive(turkey1) at 11, -alive(turkey2) at 11).

q(12) ?? motive(was_confused(pj),not_fired_gun) at 12;
         motive(was_confused(pj),dead(turkey1,turkey2)) at 12;
         motive(was_confused(pj),more_birds_arrived) at 12;
         motive(was_confused(pj),made_unusually_noise(pjGun)) at 12.
