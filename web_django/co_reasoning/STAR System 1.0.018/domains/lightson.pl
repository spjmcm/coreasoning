% Try as is, with uncommenting one of s(2), and with changing 5->3 or 8->6.
% The last scenario with the original times demonstrates the generalized
% ramification problem in the presence of exogenous qualification.

session(s(1),[q(1)], all).
session(s(2),[q(1)], all).

fluents([current,lightson]).


s(1) :: current at 3.
s(1) :: switch at 5.
%s(2) :: lightson at 8.
%s(2) :: -lightson at 8.

c(1) :: switch,current causes lightson.

q(1) ?? current at 9; lightson at 9.
