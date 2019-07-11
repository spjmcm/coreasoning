% %%%%%%%%%%%%%%%%%%%%%%%%% DOORBELL STORY AND QUESTIONS %%%%%%%%%%%%%%%%%%%%%%%

% Ann rang the doorbell. Mary, who was in the flat watching TV, got up from
% her chair and walked to the door. She was afraid. Mary looked through
% the keyhole. Mary saw Ann, her flatmate, at the door. Mary opened the
% door and asked Ann why she did not use her keys to come in the flat? Ann
% replied that she is upset that she did not agree to come with her at the
% shops. She wanted to get her up from her chair in front of the TV.

session(s(0),[],all).
session(s(1),[q(1),q(2)],all).
session(s(2),[q(3)],all).
session(s(3),[q(1),q(2),q(4),q(5)],all).
session(s(4),[q(5)],all).
session(s(5),[q(1),q(2),q(5),q(6)],all).
session(s(6),[q(7)],all).

s(0) :: person(ann) at always.
s(0) :: person(mary) at always.
s(0) :: request(go_to(shops)) at always.
s(0) :: request(donate(money)) at always.
s(1) :: ring(ann,doorbell) at 2.
s(2) :: in_flat(mary) at 3.
s(2) :: watch(mary,tv) at 3.
s(2) :: get_up(mary,chair) at 3.
s(2) :: walk_to(mary,door) at 4.
s(2) :: afraid(mary) at 4.
s(3) :: look_through(mary,keyhole) at 5.
s(3) :: see_at(mary,ann,door) at 6.
s(3) :: flatmate(mary,ann) at 6.
s(4) :: open(mary,door) at 8.
s(4) :: ask(mary,ann,use(doorkeys)) at 8.
s(5) :: upset_with(ann,mary) at 9.
s(5) :: -agree(mary,request_from(ann,go_to(shops))) at 1.
s(6) :: wants(ann,get_up(mary,chair)) at 1.

q(1) ?? has(ann,doorkeys) at 1.

q(2) ?? is_a(ann,visitor) at 1;
        is_a(ann,resident) at 1.

q(3) ?? wants(mary,find_out_who_at(door)) at 4;
        wants(mary,open(door)) at 4.

q(4) ?? wants(mary,find_out_who_at(door)) at 8;
        wants(mary,open(door)) at 8.

q(5) ?? wants(ann,punish(mary)) at 1.

q(6) ?? upset_with(ann,mary) at 1.

q(7) ?? refused(mary,ann,go_to(shops)) at 1;
        refused(mary,ann,donate(money)) at 1.

% %%%%%%%%%%%%%%%%%%%%%%%%% BACKGROUND / WORLD KNOWLEDGE %%%%%%%%%%%%%%%%%%%%%%%

fluents([
     in_flat(_),
     watch(_,_),
     afraid(_),
     flatmate(_,_),
     upset_with(_,_),
     has(_,_),
     is_a(_,_),
     expect(_,_),
     wants(_,_),
     knows(_,_),
     agree(_,_),
     refused(_,_)
    ]).

p(11) :: has(Person,doorkeys) implies -ring(Person,doorbell).
p(12) :: is_a(Person,visitor) implies -has(Person,doorkeys).
p(13) :: is_a(Person,resident) implies has(Person,doorkeys).

c(21) :: get_up(Person,chair), watch(Person,tv) causes -watch(Person,tv).
p(22) :: walk_to(Person,door), in_flat(Person) implies wants(Person,open(door)).
p(23) :: afraid(Person), in_flat(Person) implies -wants(Person,open(door)).
p(23) >> p(22).
p(24) :: walk_to(Person,door), in_flat(Person) implies wants(Person,find_out_who_at(door)).

% An interesting phenomenon: the observation of "afraid" enables its causation,
% so that it stops the persistence of the observation infinetely in the past.
c(25) :: ring(Other,doorbell), person(Other), -expect(Person,visitors) causes afraid(Person).
p(26) :: walk_to(Person,door), in_flat(Person), afraid(Person) implies -expect(Person,visitors).
p(26) >> c(25).

c(31) :: see_at(Person,Other,door), person(Other) causes knows(Person,is_at(Other,door)).
c(32) :: knows(Person,is_at(Other,door)), flatmate(Person,Other) causes -afraid(Person).
c(32) >> c(25).
c(33) :: see_at(Person,Other,door), flatmate(Person,Other) causes wants(Person,open(door)).
c(33) >> p(23).
c(34) :: see_at(Person,Other,door), person(Other) causes -wants(Person,find_out_who_at(door)).
p(35) :: flatmate(Person,Other), in_flat(Person) implies is_a(Other,resident).
p(35) >> p(13).

c(41) :: open(Person,door) causes -wants(Person,open(door)).

p(51) :: -agree(Person,request_from(Other,Request)) implies refused(Person,Other,Request).
p(52) :: refused(Person,Other,Request), request(Request) implies upset_with(Other,Person).
c(53) :: upset_with(Other,Person) causes wants(Other,punish(Person)).
c(53) >> p(54).

% An interesting phenomenon: giving a reason for ringing the bell, resolves
% whether Ann has the doorkeys (as a resident) or not (since she rang the doorbell).
p(54) :: in_flat(Person), wants(Other,punish(Person)) implies ring(Other,doorbell).
p(54) >> p(11).

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
