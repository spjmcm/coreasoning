session(s(0),[], [relaxed_at(_,_),isAt(_,_),can_see(_,_),had(_,_),is_blind(_),diff(_,_)]).
session(s(1),[q(01),q(02)], []).
session(s(2),[q(03),q(04),q(05)], []).
session(s(3),[q(06),q(07),q(08)],[]).
session(s(4),[q(09)],[]).


fluents([
    breakfast_time,
    can_see(_,_),
    relaxed_at(_,_),
    isAt(_,_),
    is_blind(_),
    had(_,_),
    diff(_,_),
    is_person(_),
    is_retirement_day(_),
    lives_together(_,_),
    still_working(_),
    going_school(_),
    has_type(_,_),
    is_working_dog(_,_),
    age(_,_),
    is_dog(_),
    barked(_),
    yawned(_),
    lives(_,_),
    is_working(_,_),
    in_trouble(_,_),
    wondered_if(_,_),
    relived(_,_),
    will_help(_,_,_),
    give_money(_,_),
    is_good(_),
    isAtHome(_),
    place(_),
    has(_,_),
    felt_around(_,_),
    nudged_hand(_,_),
    win_competition(_)
   ]).


%NARRATIVE
s(1) :: breakfast_time at 0.
s(1) :: relaxed_at(rose,farmhouse_kitchen) at 0.
s(1) :: relaxed_at(albert,farmhouse_kitchen) at 0.
s(1) :: had(rose,breakfast) at 0.
s(1)::  place(barn_fields) at 0.
s(1)::  place(sand) at 0.
s(1)::  place(shopping_centre) at 0.
s(1) :: had(albert,breakfast) at 0.
s(1) :: different(around_60_70,around_10_20) at 0.
s(1) :: different(around_60_70,around_30_40) at 0.
s(1) :: different(around_60_70,around_70_80) at 0.
s(1) :: different(around_30_40,around_10_20) at 0.
s(1) :: different(around_30_40,around_70_80) at 0.
s(1) :: different(around_10_20,around_60_70) at 0.
s(1) :: different(around_10_20,around_30_40) at 0.
s(1) :: different(around_10_20,around_20_50) at 0.
s(1) :: different(around_10_20,around_70_80) at 0.

s(1) :: different(sheep_dog,guide_dog) at 0.
s(1) :: different(sheep_dog,slate_dog) at 0.
s(1) :: different(sheep_dog,hound_dog) at 0.
s(1) :: different(guide_dog,slate_dog) at 0.
s(1) :: different(guide_dog,sheep_dog) at 0.
s(1) :: different(guide_dog,hound_dog) at 0.
s(1) :: different(slate_dog,sheep_dog) at 0.
s(1) :: different(slate_dog,guide_dog) at 0.
s(1) :: different(slate_dog,hound_dog) at 0.
s(1) :: different(hound_dog,guide_dog) at 0.
s(1) :: different(hound_dog,sheep_dog) at 0.
s(1) :: different(hound_dog,slate_dog) at 0.

s(1) :: sound_of(chickens) at 1.
s(1) :: smell_of(barn) at 1.
s(1) :: is_retirement_day(albert) at 1.
s(2) :: yawned(albert) at 2.
s(2) :: barked(albert) at 2.
s(3) :: felt_around(rose,stick) at 3.
s(3) :: nudged_hand(albert,rose) at 3.
s(3) :: wondered_if(rose,is_good(the_new_guide_dog)) at 3.
s(4) :: phone_rang at 4.
s(4) :: tired_of(roseDaughter,city) at 4.
s(4) :: will_help(roseDaughter,rose,the_new_guide_dog) at 4.


%ARGUMENTS
p(11) :: relaxed_at(Person,Place) implies isAt(Person,Place).
p(13) :: isAt(Person,farmhouse_kitchen) implies can_see(Person,barn_fields).
p(14) :: isAt(Person,dessert) implies can_see(Person,sand).
p(15) :: isAt(Person,farmhouse_kitchen) implies -can_see(Person,sand).
p(16) :: isAt(Person,city) implies can_see(Person,shopping_centre).
p(17) :: isAt(rose,farmhouse_kitchen) implies -can_see(rose,shopping_centre).
p(18) :: can_see(Person,barn_fields) implies -can_see(Person,nothing).
p(111) :: is_blind(Person) implies can_see(Person,nothing).
p(1110) :: can_see(Person,nothing),place(X) implies -can_see(Person,X).
p(112) :: had(Person,breakfast) implies is_person(Person).
p(1110) >> p(13).
p(111) >> p(18).
p(1110) >> p(16).
p(1110) >> p(14).

p(113) :: is_person(Person), is_retirement_day(Person) implies age(Person,around_60_70).
p(114) :: is_person(Person), is_retirement_day(Person) implies -age(Person,around_10_20).
p(115) :: is_person(Person), is_retirement_day(Person) implies -age(Person,around_30_40).
p(116) :: is_person(Person), going_school(Person) implies age(Person,around_10_20).
p(117) :: is_person(Person), still_working(Person) implies age(Person,around_30_40).
p(118) :: is_person(Person), still_working(Person) implies -age(Person,around_60_70).
p(119) :: age(Person,Age1),different(Age1,Age2) implies -age(Person,Age2).
p(119) >> p(116).
p(119)>>p(113).


p(21) :: barked(Animal) implies is_dog(Animal).
p(22) :: is_dog(Animal) implies -is_person(Animal).
p(22) >> p(112).

p(23) :: is_dog(Animal) implies age(Animal,around_10_20).
p(24) :: is_dog(Animal) implies -age(Animal,around_30_40).
p(25) :: is_dog(Animal) implies -age(Animal,around_60_70).
p(39) :: felt_around(Person,stick) implies is_blind(Person).

p(26) :: is_retirement_day(X), is_dog(X),lives(X,farm) implies is_working(X,farm).
p(29) :: is_blind(Person),is_working(X,farm),lives(Person,farm) implies has_type(X,guide_dog).
p(27) :: is_working(Animal,farm), is_dog(Animal) implies has_type(Animal,sheep_dog).
p(41) :: win_competition(Animal), is_dog(Animal) implies has_type(Animal,sheep_dog).
p(28) :: is_working(Animal,snow), is_dog(Animal) implies has_type(Animal,slate_dog).
%p(29) >> p(30).
%p(301) >> p(27).
%p(301) >> p(41).

p(29) >> p(2151).
p(2151) >> p(27).
p(2151) >> p(41).

p(2151):: has_type(Animal,Type1),different(Type1,Type2) implies -has_type(Animal,Type2).
p(31) :: breakfast_time,is_person(Person) implies isAtHome(Person).
p(32) :: breakfast_time implies isAtHome(albert).
p(33) :: isAtHome(Person), isAt(Person,Place) implies has(home(Person),Place).
p(35) :: has(home(Person),farmhouse_kitchen) implies lives(Person,farm).
p(40) :: lives(Person1,farm), lives(Person2,farm) implies lives_together(Person1,Person2).
p(42) :: true implies has(farm,sheep). %sinithws oi farmes exoun provata, gourounia kai agelades.
p(43) :: true implies has(farm,pig).
p(44) :: true implies has(farm,cow).

p(50) :: wondered_if(Person,is_good(the_new_guide_dog)) implies in_trouble(Person,the_new_guide_dog).
p(51) ::in_trouble(Person,the_new_guide_dog), will_help(Y,Person,the_new_guide_dog) implies relived(Person,will_help(Y,Person,the_new_guide_dog)).
p(52) ::in_trouble(Person,the_new_guide_dog), will_help(Y,Person,the_new_guide_dog) implies -relived(Person,give_money(Y,Person)).
p(53) :: tired_of(X,city),is_person(Person) implies -relived(Person,tired_Of(X,city)).
p(54) :: in_trouble(Person,money), give_money(PersonA,Person) implies relived(Person,give_money(PersonA,Person)).
p(55) :: tired_of(PersonA,Something), hates(Person,PersonA) implies relived(Person,tired_of(Person,Something)).

% Domain-independent preferences (can be modified if needed).
i(0) >> p(_).    % persistence overrides property.
c(_) >> i(0).    % causal overrides persistence.
o(0) >> _ on _.  % observation disputes everything.




%Question 1: What could Rose see out of the kitchen window?
q(01) ?? can_see(rose,barn_fields) at 0;
         can_see(rose,sand) at 0;
         can_see(rose,shopping_centre) at 0;
	 can_see(rose,nothing) at 0.


% Question 2: Is Albert?
q(02) ?? age(albert,around_10_20) at 1;
         age(albert,around_30_40) at 1;
         age(albert,around_60_70) at 1.

% Question 3: Is Albert?
q(03) ?? age(albert,around_10_20) at 2;
         age(albert,around_30_40) at 2;
         age(albert,around_60_70) at 2.

% Question 4: What type of dog is Albert?
q(04) ?? has_type(albert,sheep_dog) at 2;
	 has_type(albert,guide_dog) at 2;
	 has_type(albert,slate_dog) at 2.

% Question 5: Are there sheep on Rose's farm?
q(05) ?? has(farm,sheep) at 2.

% Question 6: What type of dog is Albert?
q(06) ?? has_type(albert,sheep_dog) at 3;
         has_type(albert,guide_dog) at 3;
         has_type(albert,slate_dog) at 3.

% Question 7: Are there sheep on Rose's farm?
q(07) ?? has(farm,sheep) at 3.

%Question 8: What could Rose see out of the kitchen window?
q(08) ?? can_see(rose,barn_fields) at 3;
         can_see(rose,sand) at 3;
         can_see(rose,shopping_centre) at 3;
	 can_see(rose,nothing) at 3.

%Question 9: Why relieved Rose?
q(09) ?? relived(rose,will_help(roseDaughter,rose,the_new_guide_dog)) at 4;
	 relived(rose,give_money(roseDaughter,rose)) at 4;
         relived(rose,tired_Of(roseDaughter,city)) at 4.


