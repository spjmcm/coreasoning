% ================ Story in STAR Syntax ================
% Examples from NL to STAR converter
% Author Adamos Koumi

% Bob called Mary.
% She did not want to answer the phone.
% Bob had asked her for a favor.
% She had agreed to do the favor.
% She answered the phone.
% She apologized to Bob.
% Was Mary embarrassed?
% Was the favor carried out?

session(s(0),[],all).
session(s(1),[q(1),q(2)],all).

s(0) :: is_favor(favor1) at always.
s(0) :: is_person(bob) at always.
s(0) :: is_person(mary) at always.
s(0) :: is_phone(phone1) at always.

s(1) :: call(bob,mary) at 3.
s(1) :: -do_want(mary,answer(phone1)) at 4.
s(1) :: have_ask(bob,mary,favor1) at 1.
s(1) :: have_agreed(mary,do(favor1)) at 2.
s(1) :: answer(mary,phone1) at 5.
s(1) :: apologize(mary,bob) at 6.

%%%%%%%%%%%%%%%% Background Knowledge %%%%%%%%%%%%%%%%

fluents([
   do_want(_,_),
   is_embarrassed(_),
   carried_out(_),
   has_asked_for(_,_,_),
   has_agreed_to(_,_)
]).

p(01) :: have_ask(X,O,S) implies has_asked_for(X,O,S).
p(02) :: have_agreed(O,do(S)) implies has_agreed_to(O,S).

c(11) :: has_asked_for(X,O,S), has_agreed_to(O,S), apologize(O,X) causes -carried_out(S).

p(21) :: has_asked_for(X,O,S), -carried_out(S) implies is_embarrassed(O).

c(31) :: has_asked_for(X,O,S), has_agreed_to(O,S), -carried_out(S), call(X,O), is_phone(P) causes -do_want(O,answer(P)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q(1) ?? is_embarrassed(mary) at 7.
q(2) ?? carried_out(favor1) at 8.
