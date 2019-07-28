% %%%%%%%%%%%%%%%%%%%%%% Nighttime Snack %%%%%%%%%%%%%%%%%%%%%% %
% The doorbell rang.
% Jenny opened her eyes, yawned and stretched.
% Nonchalantly she walked out of the bedroom, when the doorbell rang again.
% She walked past the front door and proceeded to the kitchen.
% Her stomach was growling, and she was looking for something to eat.
% When she walked out of the kitchen, Lisa was standing on the door and she was
% helping Sarah bring her luggage inside.
% After they talked for a while, they said goodnight to each other and went to bed.
% Jenny returned to the bedroom a bit later and continued her sleep satiated.
%

session(s(0),[],all).
session(s(1),[q(1)],[]).
session(s(2),[q(1),q(2),q(3)], []).

s(0) :: person(lisa) at always.
s(0) :: person(sarah) at always.
s(0) :: is_time(morning) at always.
s(0) :: is_time(noon) at always.
s(0) :: is_time(night) at always.
s(0) :: is_time(very_soon) at always.

s(1) :: rang(doorbell) at 1.
s(1) :: opened(jenny, her_eyes) at 2.
s(1) :: yawned(jenny) at 2.
s(1) :: stretched(jenny) at 2.
s(1) :: walked_from(jenny, bedroom) at 3.
s(1) :: rang(doorbell) at 3.
s(2) :: walked_past(jenny, door) at 4.
s(2) :: proceeded_to(jenny, kitchen) at 5.
s(2) :: growled(stomach(jenny)) at 6.
s(2) :: looking_for(jenny, something_to_eat) at 6.
s(2) :: walked_out_of(jenny, kitchen) at 7.
s(2) :: standing(lisa, door) at 7.
s(2) :: helping(lisa, sarah, to_bring_inside(luggage(sarah))) at 7.
s(2) :: talked(lisa, sarah) at 8.
s(2) :: said_goodnight(lisa, sarah) at 9.
s(2) :: went_to_bed(lisa) at 10.
s(2) :: went_to_bed(sarah) at 10.
s(2) :: returned(jenny, bedroom) at 11.
s(2) :: satiated(jenny) at 11.
s(2) :: continued(jenny, sleep) at 11.

% Why did Jenny walk out of the bedroom?
q(1) ?? wants(jenny,open(door)) at 3;
		wants(jenny,find(something_to_eat)) at 3.

% What time of the day is it at the beginning of the story?
q(2) ?? time(night) at 1;
		time(noon) at 1.

% Why did Jenny ignore the doorbell?
q(3) ?? resident(jenny) at 4;
		animal(jenny) at 4.


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% BACKGROUND - WORLD KNOWLEDGE
% Merged knowledge from all 4 stories
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
fluents([
	expecting(_,_,_),
	expecting_something(_,_),
	expecting_sometime(_,_),
	afraid(_),
	sleep(_),
	eat(_,_),
	eat(_),
	commiting_felony(_),
	holding(_,_),
	time(_),

	wants(_,_),
	resident(_),
	animal(_),
	standing(_,_),
	hungry(_),

	alone_at(_,_),
	afraid_to(_,_),
	trapped_in(_,_),
	there_is_fire(_),

	liked(_,_),
	standing_at(_,_),
	embarassed(_),
	neighbor(_,_),
	angry(_),
	kept(_,_),
	has(_,_),
	christmas,
	lost(_,_),
	wants_to(_,_),
	bothered_alot(_,_),
	lost_before(_,_)
]).

% %%%%%%%%%%%%%%%%%%%%%% Unpleasant Surprise %%%%%%%%%%%%%%%%%%%%%% %

% when someone isn't expecting someone 'this early', it usually implies that it's morning
p(1) :: -expecting(Someone,Something,this_early),person(Someone),expectation(Something) implies time(morning).

% when someone spills juice from the table, it usually means they're eating
p(2) :: jumped(Someone,up),person(Someone),spilled_from(juice,table) implies eat(Someone).

% when someone eats in the morning, it's usually breakfast
p(3) :: eat(Someone),person(Someone),time(morning) implies eat(Someone,breakfast).

% when someone is eating breakfast, they can't be asleep
p(4) :: eat(Someone,breakfast) implies -sleep(Someone).

% When someone pushes someone with a gun, they're commiting a felony
p(5) :: pushes_with(Someone,Other,gun),person(Someone),person(Other) implies commiting_felony(Someone).

% When someone is being pushed with a gun, they're usually unarmed
p(6) :: pushes_with(Someone,Other,gun),person(Someone),person(Other) implies -holding(Other,gun).

% when someone doesn't expect visits, they are usually not expecting friends
p(7) :: -expecting_sometime(Someone,visits),person(Someone) implies -expecting_sometime(Someone,friends).

% if someone's waiting for a new object early in the morning, they're usually waiting for the mailman to bring it
p(8) :: expecting_sometime(Someone,has_in_hands(Something)),person(Someone),expectation(Something) implies expecting_sometime(Someone,mailman).

% conversion rules for expectations
p(9) :: expecting(Someone,Something,Sometime),is_time(Sometime),expectation(Something) implies expecting_sometime(Someone,Something).
p(10) :: expecting(Someone,Something,Sometime),is_time(Sometime),expectation(Something) implies expecting_something(Someone,Sometime).
p(11) :: -expecting(Someone,Something,Sometime),is_time(Sometime),expectation(Something) implies -expecting_sometime(Someone,Something).

% %%%%%%%%%%%%%%%%%%%%%% Nighttime Snack %%%%%%%%%%%%%%%%%%%%%% %

% when the doorbell rings and someone walks out of the bedroom, they usually want to open the door
p(12) :: rang(doorbell),walked_from(Someone,bedroom) implies wants(Someone,open(door)).

% when someone walks past the door, it usually means they don't want to open it
p(13) :: walked_past(Someone,door) implies -wants(Someone,open(door)).
p(13) >> p(12).

% when someone's stomach is growling, it usually means they're hungry
p(14) :: growled(stomach(Someone)) implies hungry(Someone).

% when someone's hungry and they're looking for something to eat, it usually means they want to find something to eat
p(15) :: hungry(Someone),looking_for(Someone,something_to_eat) implies wants(Someone,find(something_to_eat)).

% when people say goodnight to each other, it usually implies that it is nighttime
p(16) :: said_goodnight(Someone,Other),person(Someone),person(Other) implies time(night).

% when it is night, it can't be noon
p(17) :: time(night) implies -time(noon).

% when someone sleeps in a house, they are usually a resident of the house
p(18) :: continued(Someone,sleep) implies resident(Someone).

% when a resident of the house doesn't want to open the door while the doorbell is ringing, it might imply that they are not human
p(19) :: resident(Someone),rang(doorbell),-wants(Someone,open(door)) implies animal(Someone).

% when someone is an animal,they can't be human
p(20) :: animal(Someone) implies -person(Someone).

% %%%%%%%%%%%%%%%%%%%%%% House Adventure %%%%%%%%%%%%%%%%%%%%%% %

% when the doorbell rings, someone will usually want to open the door
c(21) :: person(Someone),rang(doorbell) causes wants(Someone,open(door)).
p(13) >> c(21).

% when someone is afraid to open the door, they usually don't want to open it and they usually want to stay home
p(22) :: person(Someone),afraid_to(Someone,open(door)) implies -wants(Someone,open(door)).
p(22) >> c(21).
p(23) :: person(Someone),afraid_to(Someone,open(door)) implies wants(Someone,stay_at_home).

% When someone smells smoke out the door, it usually means there is a fire
p(24) :: person(Someone),smelled_smoke(Someone,out_of_door) implies there_is_fire(out_of_door).

% When there is fire, people usually want to get to safety and they usually want to leave their homes
p(25) :: there_is_fire(out_of_door),person(Someone) implies wants(Someone,get_to_safety).
p(26) :: there_is_fire(out_of_door),person(Someone) implies -wants(Someone,stay_at_home).
p(26) >> p(23).

% When there is fire and someone is trapped, they will usually call the fire department
c(27) :: there_is_fire(out_of_door),person(Someone),trapped_in(Someone,flat(Someone)) causes called(Someone,fire_department).

% %%%%%%%%%%%%%%%%%%%%%% Forgetfulness Case %%%%%%%%%%%%%%%%%%%%%% %

% when someone is smiling and expecting the doorbell to ring many times, they're usually expecting someone they like
p(28) :: person(Someone),smiled(Someone),expecting(Someone, ring_many_times(doorbell),tonight),liked(Someone,Something) implies expecting_sometime(Someone,Something).

% usually everyone likes their friends
p(29) :: person(Someone) implies liked(Someone,friends).

% when someone expects to listen to the carols, usually it's christmas
p(30) :: person(Someone),expecting_sometime(Someone,listen_to(carols, house(Someone))) implies christmas.

% when someone expects their friends and the doorbell to ring many times, they might be having a party
p(31) :: person(Someone),expecting(Someone, ring_many_times(doorbell), tonight),expecting_sometime(Someone,friends) implies has(Someone,party).

% when someone keeps their neighbor's key and they bring it to them, it usually means the neighbor lost theirs
p(32) :: person(Someone),person(Neighbor),kept(Someone,key(Neighbor)),went_to_bring(Someone,key(Neighbor)) implies lost(Neighbor,key(Neighbor)).

% when someone expects the doorbell to ring many times, they usually don't have to go anywhere
p(33) :: person(Someone),expecting(Someone, ring_many_times(doorbell),tonight) implies -have(Someone,go_somewhere).

% when someone's neighbor loses their keys and the person thinks 'not again' it usually means this has happened before
p(34) :: person(Someone),person(Neighbor),lost(Neighbor,key(Neighbor)),thought(Someone,not_again) implies lost_before(Neighbor,key(Neighbor)).

% when someone is angry because something that has happened before happens again, they are usually bothered many times
p(35) :: person(Someone),person(Neighbor),lost_before(Neighbor,key(Neighbor)),angry(Someone),lost(Neighbor,key(Neighbor)) implies bothered_alot(Neighbor,Someone).

% when someone expects the doorbell to ring many times, it usually means they don't have to go somewhere
p(36) :: expecting(Someone, ring_many_times(doorbell), tonight),person(Someone) implies -has(Someone,go_somewhere).

% Rule: One correct answer excludes the other (see README)
% p(37) :: christmas,person(Someone) implies -has(Someone,party).
% p(37) >> p(31).
