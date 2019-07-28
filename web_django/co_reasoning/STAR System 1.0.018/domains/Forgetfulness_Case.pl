% %%%%%%%%%%%%%%%%%%%%%% Forgetfulness Case %%%%%%%%%%%%%%%%%%%%%% %
% The doorbell rang. Helen smiled. She expected the doorbell to ring many
% times tonight. She grabbed the basket of chocolates and walked to the door.
% She loved listening to the carols at her house. She opened the door and saw
% Eve, her neighbor, standing embarassed. "Not again", Helen thought. Feeling
% a bit angry, Helen walked to the kitchen to bring Eve's key that she was
% keeping for these occasions.
%

session(s(0),[],all).
session(s(1),[q(1)],[]).
session(s(2),[q(1),q(2),q(3)], []).

s(0) :: is_person(helen) at always.
s(0) :: is_person(eve) at always.
s(0) :: is_doorbell(doorbell1) at always.
s(0) :: is_time(morning) at always.
s(0) :: is_time(noon) at always.
s(0) :: is_time(tonight) at always.
s(0) :: is_time(very_soon) at always.
s(0) :: is_food(chocolates1) at always.
s(0) :: is_door(door1) at always.
s(0) :: is_time(not_again) at always.
s(0) :: is_kitchen(kitchen1) at always.

s(1) :: rang(doorbell1) at 1.
s(1) :: smiled(helen) at 2.
s(1) :: expecting(helen,ring_many_times(doorbell1),tonight) at 2.
s(2) :: grabbed(helen,basket(chocolates1)) at 3.
s(2) :: walked_to(helen,door1) at 4.
s(2) :: liked(helen,listen_to(carols,house(helen))) at 4.
s(2) :: opened(helen,door1) at 5.
s(2) :: saw(helen,eve) at 6.
s(2) :: standing_at(eve,door1) at 6.
s(2) :: embarassed(helen) at 6.
s(2) :: neighbor(eve,helen) at 6.
s(2) :: thought(helen,not_again) at 7.
s(2) :: angry(helen) at 7.
s(2) :: walked_to(helen,kitchen1) at 8.
s(2) :: went_to_bring(helen,key(eve)) at 8.
s(2) :: kept(helen,key(eve)) at 8.

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


% Why was Helen expecting the doorbell to ring many times tonight?
q(1) ?? has(helen,party) at 1;
		christmas at 1.

% Why was Eve embarassed to see Helen?
q(2) ??  lost(eve,key(eve)) at 6;
		 has(helen,go_somewhere) at 6.

% Why was Helen angry?
q(3) ??  -wants_to(helen,give(eve,chocolate)) at 7;
		 bothered_alot(eve,helen) at 7.
