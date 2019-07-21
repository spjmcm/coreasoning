% ==============================================================
% The STAR System (for Story Comprehension)
% Version: 1.0.018 -- Released: 10/09/2014
% Author: Loizos Michael (loizos@ouc.ac.cy)
% ==============================================================


% ================== Domain filename to be loaded:
%domain('/domains/lightson').
%domain('/domains/penguins').
%domain('/domains/surprise').
domain('/Users/yubinge/Downloads/STAR System 1.0.018/domains/doorbell.pl').


% ================== Domain-independent priorities:
r(_) >> c(_).        % preclusion over causation.
c(_) >> i(_).        % causation over inertia.
N1 >> per(_N2) :- N1\=per(_), (N1 >> i(_)).
per(N1) >> N2 :- N2=p(_), (N1 >> N2).
o(_) >> N :- member(N,[p(_),c(_),r(_),i(_)]).


% ================== Reporting of engine status:
%   timing,
%   narrative,
%   universe,
%   retracted,
%   elaborated,
%   qualified(_),
%   acceptable,

reporting([
  acceptable,
  retracted
]).
