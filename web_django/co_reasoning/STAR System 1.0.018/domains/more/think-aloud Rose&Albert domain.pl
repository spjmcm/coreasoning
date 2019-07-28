session(s(0),[], [relaxed_at(_,_),isAt(_,_),can_see(_,_),had(_,_),is_blind(_),diff(_,_)]).
session(s(1),[q(01),q(02),q(03),q(04)], []).
session(s(2),[q(05),q(06)], []).
session(s(3),[q(07),q(08),q(09)],[]).
session(s(4),[q(10)],[]).


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
    sound_of(_),
    yawned(_),
    lives(_,_),
    usually_have_breakfast(_,_,_),
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
    usual_day,
    farmhouse,
    special_day,
    felt_around(_,_),
    nudged_hand(_,_),
    felt(_,_),
    stick(_),
    help_to_walk(_,_),
    is_couple(_,_),
    mother(_,_),
    works(_,_),
    win_competition(_)
   ]).


%NARRATIVE
s(1) :: relaxed_at(rose,farmhouse) at 0.
s(1) :: relaxed_at(albert,farmhouse) at 0.
s(1) :: had(rose,breakfast) at 0.
s(1) :: had(albert,breakfast) at 0.
s(1) :: usually_have_breakfast(rose,albert,near_window)at 0.
s(1)::  place(barn_fields) at 0.
s(1):: farmhouse at 0.
s(1)::  place(sand) at 0.
s(1)::  place(barn) at 0.
s(1)::  place(shopping_centre) at 0.
s(1)::  stick(white_stick) at 0.
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
s(1)::  usual_day at 1.
s(1) :: sound_of(chickens) at 1.
s(1) :: smell_of(barn) at 1.
s(1)::  a_special_day at 1.
s(1) :: is_retirement_day(albert) at 1.
s(1)::  worried(rose) at 1.
s(2) :: yawned(albert) at 2.
s(2) :: barked(albert) at 2.
s(2) :: is_working(albert,farm) at 2.
s(3) :: felt_around(rose,white_stick) at 3.
s(3) :: felt_nose(rose,albert) at 3.
s(3) :: nudged_hand(albert,rose) at 3.
s(3)::  has_type(albert,guide_dog) at 3.
s(3) :: wondered_if(rose,is_good(the_new_guide_dog)) at 3.
s(4) :: phone_rang at 4.
s(4):: mother(rose,roseDaughter) at 4.
s(4):: works(roseDaughter,city) at 4.
s(4) :: tired_of(roseDaughter,city) at 4.
s(4) :: will_help(roseDaughter,rose,the_new_guide_dog) at 4.


%ARGUMENTS
p(11) :: relaxed_at(Person,Place) implies isAt(Person,Place).
p(13) :: isAt(Person,countryside) implies can_see(Person,barn_fields).
p(222) :: isAt(Person,farmhouse) implies isAt(Person,countryside).
p(16) :: isAt(Person,city) implies can_see(Person,shopping_centre).
p(14) :: isAt(Person,dessert) implies can_see(Person,sand).
p(15) :: isAt(Person,countryside) implies -can_see(Person,sand).
p(17) :: isAt(rose,countryside) implies -can_see(rose,shopping_centre).
p(111):: is_person(Person) implies -can_see(Person,nothing).
p(112) :: had(Person,breakfast) implies is_person(Person).
p(1111):: had(Person,breakfast),is_person(Person) implies breakfast_time.
p(66)::   lives_together(X,Y) implies is_couple(X,Y).
p(111) :: is_blind(Person) implies can_see(Person,nothing).
p(85):: is_blind(Person)implies -can_see(rose,shopping_centre).
p(86):: is_blind(Person)implies -can_see(rose,sand).

p(3):: smell_of(barn) implies has(farm,many_animals).

p(2):: true implies -motive(special_day,change_season).
p(7):: -motive(special_day,change_season) implies -motive(special_day,summer_has_arrived).
p(4):: usually_have_breakfast(rose,albert,near_window) implies -motive(special_day,have_breakfast_near_window).
p(5):: a_special_day implies will_be_something_important.
p(6):: will_be_something_important, is_retirement_day(Person) implies motive(special_day,retirement_day(Person)).

p(61):: is_couple(Person1,Person2),is_retirement_day(Person2) implies motive(was_worried(Person1),couldnot_help(Person2,Person1)).
p(62):: is_couple(Person1,Person2),is_retirement_day(Person2) implies -motive(was_worried(Person1),couldnot_help(Person2,Person1)).
p(66):: usual_day,lives(Person1,farm) implies -motive(was_worried(Person1),smell_out_of_window).
p(67):: is_retirement_day(Person2),is_person(Person1) implies -motive(was_worried(Person1),healh_problem(Person2)).
p(68):: is_couple(X,Y), worried(X), is_retirement_day(Y) implies motive(was_worried(X),healh_problem(Y)).
p(69):: is_person(X) implies -motive(was_worried(X),old_age).
p(70)::	is_retirement_day(Y),is_couple(X,Y)  implies  motive(was_worried(X),old_age).

p(113) :: is_person(Person), is_retirement_day(Person) implies old(Person).
p(1137):: old(Person)implies age(Person,around_60_70).
p(114) :: is_person(Person), is_retirement_day(Person) implies -age(Person,around_10_20).
p(115) :: is_person(Person), is_retirement_day(Person) implies -age(Person,around_30_40).
p(116) :: is_person(Person), going_school(Person) implies age(Person,around_10_20).
p(117) :: is_person(Person),  is_retirement_day(Person), early_retirement(Person) implies age(Person,around_30_40).
p(119) :: is_person(Person),  is_retirement_day(Person), health_problems(Person) implies age(Person,around_30_40).

p(23) :: is_dog(Animal) implies age(Animal,around_10_20).
p(51) :: is_dog(Animal) implies age(Animal,around_30_40).
p(52) :: is_dog(Animal) implies -age(Animal,around_60_70).


p(21) :: barked(Animal) implies is_dog(Animal).
p(22) :: barked(Person) implies person_doing_joke(Person).
p(9):: is_working(X,farm) implies is_person(X).
p(10):: is_working(X,farm), is_dog(X) implies has_type(X,sheep_dog).
p(12):: is_working(X,farm), has_type(X,sheep_dog) implies help_farm(X).


p(26):: is_working(X,farm),has_type(X,sheep_dog) implies has(farm,sheep).
p(24):: sound_of(chickens) implies -has(farm,sheep).
%o skillos ine gia tin idia p ine tifli
p(48):: is_blind(X),is_person(X) implies -has(farm,sheep).
p(49):: help(X,Y),is_dog(X),is_blind(Y) implies has(farm,sheep).
p(50):: is_blind(X),has_type(Y,guide_dog) implies help(X,Y).
p(58):: farmhouse implies has(farm,many_animals).
p(58):: farmhouse implies has(farm,sheep).

p(33):: felt_around(Person,white_stick) implies is_blind(Person).
p(34):: felt_around(Person,white_stick) implies -old(Person).
p(35):: felt_around(Person,Stick), stick(Stick) implies walking_problem(Person).
p(36):: felt_nose(X,Y), is_person(X), is_person(Y) implies familiar(X,Y).
p(37):: felt_nose(X,Y),is_person(Y), is_dog(X) implies faifthul_dog(X).
p(38):: nudged_hand(X,Y),is_person(X),is_person(Y),old(Y),is_couple(X,Y) implies help_to_take_stick(X,Y).
p(39):: nudged_hand(X,Y),is_dog(X),is_person(Y),is_blind(Y) implies help_to_walk(X,Y).

p(75):: has(home(Person),farmhouse), sound_of(chickens) implies has(Person,chickens).
p(53)::	felt_nose(X,Y), is_person(X), is_dog(Y) is blind(X).
p(56):: has(home(Person),farmhouse),has(Person,chickens) implies -is_blind(Person).
p(58):: has_wheel_chair(X) implies old(X).
p(59):: felt_around(Person,white_stick) implies problem_with_leg(Person).
p(60)::	felt_around(Person,white_stick), help_to_walk(X,Person), is_person(Person),is_dog(X) implies -problem_with_leg(Person).

p(54) :: isAtHome(Person), isAt(Person,Place) implies has(home(Person),Place).
p(55):: had(Person,breakfast) implies isAtHome(Person).

p(63) :: has(home(Person),farmhouse) implies lives(Person,farm).
p(64) :: has(home(rose),farmhouse) implies lives(rose,farm).
p(65) :: lives(Person1,farm), lives(Person2,farm) implies lives_together(Person1,Person2).


p(50) :: wondered_if(Person,is_good(the_new_guide_dog)) implies in_trouble(Person,the_new_guide_dog).
p(51) ::in_trouble(Person,Something), will_help(Y,Person,Something) implies relived(Person,will_help(Y,Person,Something)).
p(53) :: tired_of(X,city),is_person(Person),mother(Person,X) implies -relived(Person,tired_Of(X,city)).
p(54) :: in_trouble(Person,money), give_money(PersonA,Person) implies relived(Person,give_money(PersonA,Person)).
p(55) :: tired_of(PersonA,city), miss(Person,PersonA) implies relived(Person,tired_of(PersonA,city)).
p(90):: is_person(Person) implies -relived(Person,will_help(Y,Person,the_new_guide_dog)).
p(91):: works(X,city), lives(Y,farm), mother(Y,X) implies miss(Y,X).
p(92):: mother(X,Y) implies not_give_money(Y,X).
p(93):: not_give_money(Y,X) implies -relived(X,give_money(Y,X)).

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
q(02) ??  motive(special_day,summer_has_arrived) at 1;
	  motive(special_day,retirement_day(albert)) at 1;
          motive(special_day,have_breakfast_near_window) at 1.

% Question 2: Is Albert?
q(03) ?? age(albert,around_10_20) at 1;
         age(albert,around_30_40) at 1;
         age(albert,around_60_70) at 1.

% Question 2: Is Albert?
q(04) ?? motive(was_worried(rose),healh_problem(albert)) at 1;
         motive(was_worried(rose),couldnot_help(albert,rose)) at 1;
         motive(was_worried(rose),smell_out_of_window) at 1;
         motive(was_worried(rose),old_age) at 1.


% Question 3: Is Albert?
q(05) ?? age(albert,around_10_20) at 2;
         age(albert,around_30_40) at 2;
         age(albert,around_60_70) at 2.


% Question 5: Are there sheep on Rose's farm?
q(06) ??   has(farm,sheep) at 2;
          -has(farm,sheep) at 2.



% Question 7: Are there sheep on Rose's farm?
q(07) ?? has(farm,sheep) at 3;
          -has(farm,sheep) at 3.

q(08) ?? is_blind(rose) at 3;
	 old(rose) at 3;
	 problem_with_leg(rose) at 3.

	  %Question 8: What could Rose see out of the kitchen window?
q(09) ?? can_see(rose,barn_fields) at 3;
         can_see(rose,sand) at 3;
         can_see(rose,shopping_centre) at 3;
	 can_see(rose,nothing) at 3.

%Question 9: Why relieved Rose?
q(10) ?? relived(rose,will_help(roseDaughter,rose,the_new_guide_dog)) at 4;
	 relived(rose,give_money(roseDaughter,rose)) at 4;
         relived(rose,tired_Of(roseDaughter,city)) at 4.


