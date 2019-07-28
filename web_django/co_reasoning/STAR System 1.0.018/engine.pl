% ==============================================================
% The STAR System (for Story Comprehension)
% Version: 1.0.018 -- Released: 10/09/2014
% Author: Loizos Michael (loizos@ouc.ac.cy)
% ==============================================================


:- op(1150, xfx, [::, >>, ??]).
:- op(1100, xfx, [implies, causes, precludes]).
:- op(800, xfx, [at]).
:- op(700, xfx, [#,=,~]).

:- discontiguous([session/3, '::'/2, '>>'/2, '??'/2]).
:- [config], domain(Domain), (multifile '>>'/2), [Domain].

% ==============================================================

compile :-
   qsave_program(engine, [goal(start),stand_alone(true)]).
   % Compiled file should be in Prolog's 'bin' directory.

start :- run(session).

% ==============================================================

run(Script) :-
   Script = [_|_], !,
   reasonStep([],[],([],0),Script).
run(SessionName) :-
   functor(Session,SessionName,3),
   arg(1,Session,Sc),
   arg(2,Session,Qs),
   arg(3,Session,Vz),
   findall((Sc,Qs,Vz), Session, Script),
   reasonStep(([],0),[],[],Script).

% ==============================================================

reasonStep(_SR1,_Delta1,_Univ1,[]) :-
   say(['>>> Finished reading the story!\n\n']), !.
reasonStep(SR1,Delta1,Univ1,[(Sc,Qs,Vz)|Script]) :-
   report(timing, (
      trackTimes(end,Times1)
   )),

   say(['===================================\n']),
   say(['>>> Reading story up to scene ',Sc,'\n']),
   say(['===================================\n']),
   readStory(SR1,(Sc,Qs),SR2),
   report(timing, (
      trackTimes(Times1,Times2)
   )),

   say(['>>> Universal argument...\n']),
   activationClosure(SR2,Univ1,Univ2),
   report(universe, (
      showRules(Univ2)
   )),
   report(timing, (
      trackTimes(Times2,Times3)
   )),

   say(['>>> Acceptable argument...\n']),
   reduce(SR2,Univ2,[],Univ2,Delta2),
   report(acceptable, (
      showRules(Delta2)
   )),
   report(timing, (
      trackTimes(Times3,Times4)
   )),

   report(retracted, (
      say(['>>> Delta retractions...\n']),
      subtract(Delta1,Delta2,Delta12),
      showRules(Delta12)
   )),

   report(elaborated, (
      say(['>>> Delta elaborations...\n']),
      subtract(Delta2,Delta1,Delta21),
      showRules(Delta21)
   )),

   nl, say(['>>> Comprehension model:\n']),
   report(narrative, (
      nl, showNarrative(SR2), nl
   )),
   visualize(Delta2,SR2,Vz), nl, answer(Delta2,SR2,Qs),
   report(timing, (
      trackTimes(Times4,end)
   )),
   % (continue -> reasonStep(SR2,Delta2,Univ2,Script) ; true).
   reasonStep(SR2,Delta2,Univ2,Script).

% ==============================================================

reduce(SR,UD,BD,BA,ND) :-
   report(qualified(_), (
      say(['\nReduction round:\n'])
   )),
   report(qualified(_), (
      say(['\nremove strongly qualified rules from Delta...\n\n'])
   )),
   retract(strongly,SR,UD,BA,D1),
   report(qualified(_), (
      say(['\nremove strongly qualified rules from attacks...\n\n'])
   )),
   retract(strongly,SR,BA,D1,NA),
   report(qualified(_), (
      say(['\nremove weakly qualified rules from Delta...\n\n'])
   )),
   retract(_,SR,D1,NA,D2),
   report(qualified(_), (
      say(['\nremove internally qualified rules from Delta...\n\n'])
   )),
   retract(_,SR,D2,D2,D3),
   ( D3==BD -> (ND=BD,
      report(qualified(_), (
         say(['\n'])
      )))
   ; reduce(SR,UD,D3,NA,ND) ).


retract(Strength,SR,I1,U,I2) :-
   dropQualified(Strength,SR,I1,U,Imax),
   activationClosure(SR,[],Imax,I2).

dropQualified(_Strength,_SR,[],_U,[]).
dropQualified(Strength,SR,[R1|I1],U,I2) :-
   qualifies(Strength,SR,U,[R1]), !,
   dropQualified(Strength,SR,I1,U,I2).
dropQualified(Strength,SR,[R1|I1],U,[R1|I2]) :-
   dropQualified(Strength,SR,I1,U,I2).

% ==============================================================

% Takes care of rule qualifications.

qualifies(_Strength,SR,_I1,I2) :-
   member(R2,I2),
   exogenouslyQualifies(SR,R2),
   R2=rule(_Arg2,_Th2,_D2,conc(C2,_T2,_P2)),
   report(qualified(C2), (
      say([' ']), showRules([R2]),
      say(['   > qualified exogenously by the narrative\n'])
   )).

qualifies(Strength,_SR,I1,I2) :-
   member(R1,I1), member(R2,I2),
   endogenouslyQualifies(Strength,R1,R2),
   R2=rule(_Arg2,_Th2,_D2,conc(C2,_T2,_P2)),
   report(qualified(C2), (
      say([' ']), showRules([R2]),
      say(['   > qualified by: ']), showRules([R1])
   )).


endogenouslyQualifies(weakly,
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)) :-
   \+ priority(Conc2,Conc1),
   directRuleConflict(
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)).

endogenouslyQualifies(strongly,
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)) :-
   priority(Conc1,Conc2),
   (member(A1,[pro,per])->true;D1=f),
   (member(A2,[pro])->true;D2=f),
   directRuleConflict(
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)).

endogenouslyQualifies(strongly,
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)) :-
   priority(Conc1,Conc2), D1=f, D2=b,
   indirectRuleConflict(
   rule(arg(N1,A1,H1,B1),Th1,D1,Conc1),
   rule(arg(N2,A2,H2,B2),Th2,D2,Conc2)).

exogenouslyQualifies(SR,
   rule(_Arg2,_Th2,_D2,conc(C2,T2,_P2))) :-
   readNarrative(obs(NC2,T2),SR),
   conflict(C2,NC2).

directRuleConflict(
   rule(_Arg1,_Th1,_D1,conc(C1,T1,_P1)),
   rule(_Arg2,_Th2,_D2,conc(C2,T2,_P2))) :-
   T1 = T2, conflict(C1,C2).

indirectRuleConflict(
   rule(arg(_N1,_A1,H1,_B1),Th1,_D1,_Conc1),
   rule(arg(_N2,_A2,H2,_B2),Th2,_D2,_Conc2)) :-
   Th1 = Th2, conflict(H1,H2).

priority(conc(_X1,_T1,P1),conc(_X2,_T2,P2)) :-
   clause(P1 >> P2, Conds), call(Conds).

% ==============================================================

% Takes care of story-groundedness.

activationClosure(SR,Imin,Iend) :-
   activationClosure(SR,Imin,[_],Iend).

activationClosure(SR,Imin,Imax,Iend) :-
   activationFront(SR,Imin,Rs),
   findall(R, (
      member(R,Rs),
      member(R,Imax)
   ), RRs),
   RRs\=[], !,
   append(RRs,Imin,I1),
   activationClosure(SR,I1,Imax,Iend).
activationClosure(_SR,Imin,_Imax,Imin).

activationFront(SR,I,UniqueRs) :-
   findall(R, (
      readDomain(Arg,Th,SR),
      R=rule(Arg,Th,_D,_Conc),
      activates(SR,I,R),
      \+ member(R,I)
   ), Rs),
   list_to_set(Rs,UniqueRs).


activates(SR,I,rule(arg(_N,A,H,B),Th,f,conc(H,Th,per(PP)))) :-
   A=per, B=[X],
   baseTime(A,Th,T),
   storyTime(Th,SR),
   supported(conc(X,T,P),I,SR),
   (P=per(PP) -> true ; PP=P).
activates(SR,I,rule(arg(_N,A,H,B),Th,b,conc(X,T,per(PP)))) :-
   A=per, B=[NX],
   baseTime(A,Th,T),
   storyTime(T,SR),
   supported(conc(NH,Th,P),I,SR),
   conflict(H,NH),
   conflict(X,NX),
   (P=per(PP) -> true ; PP=P).

activates(SR,I,rule(arg(N,A,H,B),Th,f,conc(H,Th,P))) :-
   A\=per, P=N,
   baseTime(A,Th,T),
   storyTime(Th,SR),
   supportedSet(B,T,I,SR).
activates(SR,I,rule(arg(N,A,H,B),Th,b,conc(X,T,P))) :-
   A\=per, P=N,
   member(NX,B),
   delete(B,NX,RB),
   baseTime(A,Th,T),
   storyTime(T,SR),
   supportedSet([NH],Th,I,SR),
   conflict(H,NH),
   supportedSet(RB,T,I,SR),
   conflict(X,NX).

supportedSet([],_T,_I,_SR).
supportedSet([(true=true)|M],T,I,SR) :-
   supportedSet(M,T,I,SR).
supportedSet([X|M],T,I,SR) :-
   supported(conc(X,T,_P),I,SR),
   supportedSet(M,T,I,SR).

supported(conc(C,T,o(0)),_I,SR) :-
   readNarrative(obs(C,T),SR).
supported(conc(C,T,P),I,_SR) :-
   member(rule(_Arg,_Th,_D,conc(C,T,P)),I).

% ==============================================================

answer(_Delta,_SR,[]) :- !.
answer(Delta,SR,[N|Qs]) :-
   readQuestion(que(N,Cs)),
   findall((Ans,Choice), (
      member(Choice,Cs),
      response(Choice,Delta,SR,Ans)
   ), As),
   say(['>>> Answering question ',N,':\n']), show(As),
   answer(Delta,SR,Qs).

response(Choice,Delta,SR,'- rejected choice: ') :-
   member(X at T,Choice),
   encode([X],[EX]),
   supported(conc(NX,T,_P),Delta,SR),
   conflict(EX,NX), !.
response(Choice,Delta,SR,'+ accepted choice: ') :-
   forall(member(L,Choice), (
      L = (X at T),
      encode([X],[EX]),
      supported(conc(EX,T,_P),Delta,SR)
   )), !.
response(_Choice,_Delta,_SR,'? possible choice: ').

% ==============================================================

readStory(SR1,(Sc,Qs),SR2) :-
   SR1=(Scs1,MaxT1),
   findall(T, (
      readNarrative(obs(_,T),([Sc],0))
   ), ScTs2),
   findall(T, (
      member(N,Qs),
      readQuestion(que(N,CLs)),
      member(C,CLs),
      member(_Xq at T,C)
   ), QsTs2),
   append(ScTs2,QsTs2,Ts2),
   maxList([MaxT1|Ts2],MaxT2),
   SR2=([Sc|Scs1],MaxT2).

readNarrative(obs(EX,T),SR) :-
   clause(N :: X at always, true),
   encode([X],[EX]),
   storyScene(N,SR),
   storyTime(T,SR).
readNarrative(obs(EX,T),SR) :-
   clause(N :: X at [T1,T2], true),
   encode([X],[EX]),
   storyScene(N,SR),
   between(T1,T2,T).
readNarrative(obs(EX,T),SR) :-
   clause(N :: X at T, true),
   encode([X],[EX]),
   T \= always, T \= [_,_],
   storyScene(N,SR).

readDomain(arg(N,A,EH,EBL),Th,SR) :-
   (
      (clause(N :: B causes H, true), A=cau) ;
      (clause(N :: B precludes H, true), A=prc) ;
      (clause(N :: B implies H, true), A=pro)
   ),
   toList(',',B,BL),
   encode([H],[EH]),
   encode(BL,EBL),
   storyTime(Th,SR).
readDomain(arg(i(0),per,L,[L]),Th,SR) :-
   literal(L),
   storyTime(Th,SR).

readQuestion(que(N,CLs)) :-
   clause(N ?? Cs, true),
   findall(CL, (
      toList(';',Cs,CsL),
      member(C,CsL),
      toList(',',C,CL)
   ), CLs).

% ==============================================================

storyScene(N,(Scs,_MaxT)) :-
   member(N,Scs).

storyTime(T,(_Scs,MaxT)) :-
   between(0,MaxT,T).

baseTime(pro,Th,T) :- T is Th.
baseTime(cau,Th,T) :- T is Th - 1.
baseTime(per,Th,T) :- T is Th - 1.
baseTime(prc,Th,T) :- T is Th - 1.

literal(EL) :-
   fluents(Fs), member(F,Fs),
   (F = (N~Vs) ->
   (member(V,Vs), L = (N=V))
   ; member(L, [F,-F])),
   encode([L],[EL]).

negate((X#V),(X=V)) :- ground(V).
negate((X=V),(X#V)) :- ground(V).

absolute((X=_),X).
absolute((X#_),X).

conflict(L1,L2) :-
   negate(L1,L2).
conflict(L1,L2) :-
   L1 = (F=V1), ground(V1),
   L2 = (F=V2), ground(V2),
   V1 \= V2.
conflict(L1,L2) :-
   clause(mutex(Ls), Conds), call(Conds),
   encode(Ls,ELs),
   member(L1,ELs), member(L2,ELs), L1 \= L2.

encode(Ls,ELs) :-
   fluents(Fs),
   encode(Ls,ELs,Fs).

encode([],[],_Fs).
encode([(F#V)|Rest],[(F#V)|ERest],Fs) :-
   !, encode(Rest,ERest,Fs).
encode([(F=V)|Rest],[(F=V)|ERest],Fs) :-
   !, encode(Rest,ERest,Fs).
encode([-F|Rest],[(F#true)|ERest],Fs) :-
   !, encode(Rest,ERest,Fs).
encode([F|Rest],[(F=true)|ERest],Fs) :-
   !, encode(Rest,ERest,Fs).

% ==============================================================

visualize(Delta,SR,Vz) :-
   getAxes(Delta,SR,Vz,Xaxis,Yaxis),
   viewTable(Delta,SR,Xaxis,Yaxis), !.

getAxes(Delta,SR,Vz,Xaxis,Yaxis) :-
   findall(F, (
      supported(conc(X,_T,_P),Delta,SR),
      absolute(X,F),
      once(Vz==all ; member(F,Vz))
   ), Xs),
   sort(Xs,Xaxis),
   findall(T, (
      storyTime(T,SR)
   ), Ts),
   sort(Ts,Yaxis).

viewTable(_Delta,_SR,_Xaxis,[]).
viewTable(Delta,SR,Xaxis,[Y|Yaxis]) :-
   findall(V, (
      supported(conc(X,Y,P),Delta,SR),
      (P=o(0) -> V=obs(X) ; V=inf(X))
   ), InfersY),
   write_length(Y,YLength,[]),
   YLengthComp is 3 - YLength,
   between(1,YLengthComp,K),
   say([' ']), K>=YLengthComp,
   say([Y,':']), viewRow(InfersY,Xaxis), say(['\n']),
   viewTable(Delta,SR,Xaxis,Yaxis).

viewRow(_InfersY,[]).
viewRow(InfersY,[X|Xaxis]) :-
   member(obs((X=true)),InfersY), !,
   say(['  < ',X,'>']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   member(obs((X#true)),InfersY), !,
   say(['  <-',X,'>']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   member(inf((X=true)),InfersY), !,
   say(['    ',X,' ']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   member(inf((X#true)),InfersY), !,
   say(['   -',X,' ']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   member(obs((X=V)),InfersY), !,
   say(['  <',X=V,'>']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   member(inf((X=V)),InfersY), !,
   say(['   ',X=V,' ']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   findall(V,member(obs((X#V)),InfersY),Vs), Vs\=[], !,
   say([' <',X#Vs,'>']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   findall(V,member(inf((X#V)),InfersY),Vs), Vs\=[], !,
   say(['  ',X#Vs,' ']),
   viewRow(InfersY,Xaxis).
viewRow(InfersY,[X|Xaxis]) :-
   write_length(X,XLength,[]),
   between(-3,XLength,K),
   say([' ']), K>=XLength,
   viewRow(InfersY,Xaxis).

showRules([]).
showRules([rule(arg(N,A,H,B),Th,D,conc(X,T,P))|Rest]) :-
   say([N,' : ',A,'(',H,',',B,') @ ',Th,' -',D,'-> (',X,',',T,',',P,')\n']),
   showRules(Rest).

showNarrative(SR) :-
   findall(_, (
      clause(N :: X at Ts, true),
      storyScene(N,SR),
      say([N,' : ',X,' at ',Ts,'\n'])
   ), _).

% ==============================================================

show([]).
show([H|B]) :-
   say([H,'\n']),
   show(B).

say([]).
say([H|B]) :-
   write(H),
   say(B).

toList(_,true,[]) :- !.
toList(',',(A,B),[A|BL]) :-
   !, toList(',',B,BL).
toList(';',(A;B),[A|BL]) :-
   !, toList(';',B,BL).
toList(_,A,[A]).

continue :-
   say(['\nContinue (y/n)? ']),
   read(y), nl.

maxList([Max],Max).
maxList([H|B],Max) :-
   maxList(B,MaxB),
   Max is max(H,MaxB).


report(Type,Goal) :-
   ((reporting(Types), member(Type,Types))
    -> call(Goal) ; true), !.


trackTimes((WT1,CT1),(WT2,CT2)) :-
   !, get_time(WT2), CT2 is cputime, WT is WT2-WT1, CT is CT2-CT1,
   say(['\n[Time since last tracking: ', WT, ' / ', CT, ']\n\n']).

trackTimes(end,(WT2,CT2)) :-
   !, trackTimes((WT2,CT2),(WT2,CT2)).

trackTimes((WT1,CT1),end) :-
   !, trackTimes((WT1,CT1),(_,_)).

% ==============================================================
