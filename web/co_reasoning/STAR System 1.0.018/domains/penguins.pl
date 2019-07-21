% Try as is, with uncommenting one of s(1), and with commenting out p(3).
% The last scenario demonstrates the explaining away of an observation.

session(s(1),[q(1)], all).
session(s(2),[q(1)], all).

fluents([bird,penguin,flying]).

%s(1) :: bird at 3.
%s(1) :: flying at 3.
%s(1) :: -flying at 3.
s(2) :: penguin at 6.

p(1) :: bird implies flying.
p(2) :: penguin implies -flying.
p(3) :: penguin implies bird.

p(2) >> p(1).

q(1) ?? penguin at 9; bird at 9; flying at 9.
