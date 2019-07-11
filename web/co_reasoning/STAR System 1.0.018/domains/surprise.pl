% Try as is.
% This scenario demonstrates a seemingly circular reasoning setting, where
% an observation indirectly triggers its causation at some earlier time-point.

session(s(1),[q(1)], all).
session(s(2),[q(1)], all).

fluents([expect,surprise]).

s(1) :: event at 3.
s(2) :: surprise at 6.

c(1) :: event, -expect causes surprise.
p(2) :: surprise implies -expect.

q(1) ?? surprise at 9; expect at 9.

