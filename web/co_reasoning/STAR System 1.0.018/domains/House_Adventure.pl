% %%%%%%%%%%%%%%%%%%%%%% House Adventure %%%%%%%%%%%%%%%%%%%%%% %
% The doorbell rang. Mary asked "Who is it?", but there was no reply. Mary was
% alone and she was afraid to open the door. She walked towards the door and
% stopped. She could smell smoke ouside the door. Mary was trapped in her flat.
% She was afraid to open the door.

session(s(0),[],all).
session(s(1),[q(1)],[]).
session(s(2),[q(1),q(2),q(3)], []).

s(0) :: is_person(mary) at always.
s(0) :: is_doorbell(doorbell1) at always.
s(0) :: is_utterance(who_is_it) at always.
s(0) :: is_door(door1) at always.
s(0) :: out_of_door(out_of_door) at always.

s(1) :: person(mary) at 1.
s(1) :: rang(doorbell1) at 1.
s(1) :: asked(mary,who_is_it) at 2.
s(1) :: -answer_to(mary) at 3.
s(1) :: alone_at(mary,flat(mary)) at 4.
s(1) :: afraid_to(mary,open(door1)) at 4.
s(2) :: walked_to(mary,door1) at 5.
s(2) :: smelled_smoke(mary,out_of_door) at 5.
s(2) :: trapped_in(mary,flat(mary)) at 6.
s(2) :: afraid_to(mary,open(door1)) at 6.

% %%%%%%%%%%%%%%%%%%%%%% House Adventure %%%%%%%%%%%%%%%%%%%%%% %

% when someone walks past the door, it usually means they don't want to open it
p(13) :: walked_past(Someone,door) implies -wants(Someone,open(door)).

% when the doorbell rings, someone will usually want to open the door
c(21) :: person(Someone), rang(doorbell) causes wants(Someone,open(door)).
% p(13) >> c(21).

% when someone is afraid to open the door, they usually don't want to open it and they usually want to stay home
p(22) :: person(Someone), afraid_to(Someone,open(door)) implies -wants(Someone,open(door)).
% p(22) >> c(21).
p(23) :: person(Someone), afraid_to(Someone,open(door)) implies wants(Someone,stay_at_home).

% When someone smells smoke out the door, it usually means there is a fire
p(24) :: person(Someone), smelled_smoke(Someone,out_of_door) implies there_is_fire(out_of_door).

% When there is fire, people usually want to get to safety and they usually want to leave their homes
p(25) :: there_is_fire(out_of_door), person(Someone) implies wants(Someone,get_to_safety).
p(26) :: there_is_fire(out_of_door), person(Someone) implies -wants(Someone,stay_at_home).
% p(26) >> p(23).

% When there is fire and someone is trapped, they will usually call the fire department
c(27) :: there_is_fire(out_of_door), person(Someone), trapped_in(Someone,flat(Someone)) causes called(Someone,fire_department).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% What did Mary want to do after she received no answer from the door?
q(1) ?? wants(mary,open(door)) at 4;
		wants(mary,get_to_safety) at 4;
		wants(mary,stay_at_home) at 4.

% Why was Mary trapped in her flat?
q(2) ?? there_is_fire(out_of_door) at 6;
		wants(someone,hurt(mary)) at 6.

% What did Mary do afterwards?
q(3) ?? called(mary,neighbor) at 7;
		called(mary,fire_department) at 7.
