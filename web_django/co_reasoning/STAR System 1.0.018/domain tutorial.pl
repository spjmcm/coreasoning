% ==============================================================================
% ============= TUTORIAL ON STORY DOMAIN REPRESENTATION IN "STAR" ==============
% ==============================================================================

% This file explains how to write a domain file for a story to be comprehended 
% through the STAR -- STory comprehension through ARgumentation -- system.

% The documentation is given through the discussion of an example story excerpt,
% called the "doorbell story", which is given in natural language text below.
% To simplify the representation we are assuming in this story the existence
% of only one flat, door, doorbell, doorkeys, etc., and certain known entities.

% =============================== DOORBELL STORY ===============================
% Ann rang the doorbell. Mary, who was in the flat watching TV, got up from
% her chair and walked to the door. She was afraid. Mary looked through
% the keyhole. Mary saw Ann, her flatmate, at the door. Mary opened the
% door and asked Ann why she did not use her keys to come in the flat? Ann
% replied that she is upset that she did not agree to come with her at the
% shops. She wanted to get her up from her chair in front of the TV.
% ==============================================================================

% A domain file is an SWI-Prolog file and consists of two main parts:

% PART 1: A series of sessions for representing the story narrative up to a
% scene and answering a set of questions up to that point. It corresponds to
% reading incrementally the story and answering questions along the way.

% PART 2: The world knowledge that is used as background knowledge for the
% comprehension of the story. It corresponds to a static representation of
% such relevant commonsense knowledge, which is used across all sessions.

% ==============================================================================
% ======================= PART 1: Sessions and Narrative =======================
% ==============================================================================

% A session is defined by a series of statements of the form:

% session(s(Index),ListOfQuestions,ListOfVisisbleConcepts).

% where:

% Index is a natural number 0,1,2,3,...

% ListOfQuestions is a list of question names of the form q(Number)
% to be answered by the system during this particular session.

% ListOfVisisbleConcepts is a list of domain concepts that we wish to be
% shown on the screen as the system constructs its comprehension model.
% ListOfVisisbleConcepts can also take the value "all" requesting that 
% all domain concepts are visible in the constructed comprehension model.

% ================ Initial / Pre-Story Session

% Typically, we start with a session statement as follows:

session(s(0),[],all).

% This is a pre-story session, where background typing information is given for
% the objects in the story. This information does not change over time. In the
% "doorbell story" example, such an initial session includes the following:

s(0) :: person(ann) at always.
s(0) :: person(mary) at always.
s(0) :: request(go_to(shops)) at always.
s(0) :: request(donate(money)) at always.

% Hence "ann" and "mary" are instances of / have type "person", while
% "go_to(shops)" and "donate(money)" are instances of / have type "request".

% These observations are stated to hold at every time-point. By not declaring
% them as fluents (discussed later), we effectively define constants, which do
% not give rise to inertia arguments, but are available at every time-point.

% ================ Story / Narrative Sessions

% We can separate the given story in any number of sessions we wish. We could
% have a single session (in addition to, or including, the initial session), in
% which case we give the whole story narrative to the system for this to answer
% questions after "reading and comprehending the whole story". Alternatively, we
% could have a session after each sentence of the story where the system reads
% the story sentence by sentence and answers questions after "comprehending
% the story up to the end of the current sentence read in the last session".

% ======= Session 1 and Story Scene 1:

% Read up to scene 1 and answer questions q(1) and q(2).
session(s(1),[q(1),q(2)],all).

% Ann rang the doorbell.
s(1) :: ring(ann,doorbell) at 2.

% Questions are defined using the following format as in
% the example questions of the "doorbell story" below:

% Question 1: Does Ann (at the door) have the door keys?
q(1) ?? has(ann,doorkeys) at 1.

% Question 2: Is Ann (at the door) a visitor?
q(2) ?? is_a(ann,visitor) at 1;
        is_a(ann,resident) at 1.

% Question q(1) is a simple binary question. 
% Question q(2) is a multiple choice question.

% The same question can be asked in several distinct sessions. This is typically
% done to check if there has been a revision in the comprehension model.

% For each answer choice to a question, the system returns one of the following:
% "accepted" meaning that this choice holds in the comprehension model
% "rejected" meaning that its negation holds in the comprehension model
% "possible" when neither of the above holds

% ======= Session 2 and Story Scene 2:

session(s(2),[q(3)],all).

% Mary, who was in the flat
s(2) :: in_flat(mary) at 3.
% watching TV,
s(2) :: watch(mary,tv) at 3.
% got up from her chair
s(2) :: get_up(mary,chair) at 3.
% and walked to the door.
s(2) :: walk_to(mary,door) at 4.
% She was afraid.
s(2) :: afraid(mary) at 4.

% Question 3: Why did Mary walk to the door?
q(3) ?? wants(mary,find_out_who_at(door)) at 4;
        wants(mary,open(door)) at 4.

% ======= Session 3 and Story Scene 3:

% Answer the same previous questions q(1) and q(2), and some new ones.
session(s(3),[q(1),q(2),q(4),q(5)],all).

% Mary looked through the keyhole.
s(3) :: look_through(mary,keyhole) at 5.
% Mary saw Ann,
s(3) :: see_at(mary,ann,door) at 6.
% her flatmate, at the door.
s(3) :: flatmate(mary,ann) at 6.

% Question 4: Why did Mary walk to the door?
q(4) ?? wants(mary,find_out_who_at(door)) at 8;
        wants(mary,open(door)) at 8.

% Question 5: Why did Ann ring the doorbell?
q(5) ?? wants(ann,punish(mary)) at 1.

% ======= Session 4 and Story Scene 4:

session(s(4),[q(5)],all).

% Mary opened the door
s(4) :: open(mary,door) at 8.
% and asked Ann why she did not use her keys to come in the flat?
s(4) :: ask(mary,ann,use(doorkeys)) at 8.

% ======= Session 5 and Story Scene 5:

session(s(5),[q(1),q(2),q(5),q(6)],all).

% Ann replied that she is upset with Mary
s(5) :: upset_with(ann,mary) at 9.
% because she had not agreed to come with her at the shops.
s(5) :: -agree(mary,request_from(ann,go_to(shops))) at 1.

% Question 6: Why did Ann want to punish Mary?
q(6) ?? upset_with(ann,mary) at 1.

% ======= Session 6 and Story Scene 6:

session(s(6),[q(7)],all).

% She wanted to get her up from her chair in front of the TV.
s(6) :: wants(ann,get_up(mary,chair)) at 1.

%Question 7:  Why was Ann upset with Mary?
q(7) ?? refused(mary,ann,go_to(shops)) at 1;
        refused(mary,ann,donate(money)) at 1.

% ================ Note on Narrative Time-Points

% The exact time-points in the narrative are largely inconsequential (other than
% indicating the ordering of observations / events). However, they should be
% spaced sufficiently apart for causal laws to have sufficient time to bring
% about their (indirect / knock-on) effects. For the same reason, it is best to
% avoid having parts of the narrative or questions referencing time-point 0, or
% in fact any time-point in a sufficiently long prefix of the time-line.

% ==============================================================================
% ==================== PART 2: Background / World Knowledge ====================
% ==============================================================================

% Fluents are those properties that persist due to inertia.
% All other concepts are treated as holding instantaneously.

% Declare the domain concepts which are fluents using the statement:

% fluents(ListOfFluents).

% The fluents declaration for the example "doorbell story" is as follows:

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

% ================ General Form of the Background Knowledge

% Background knowledge is represented in terms of associations between concepts.

% There are three types of such an associations: property, causal, preclusion:

% p(Number) :: conjunction of literals implies literal.
% A static association between concepts in the form "when the conjunction of
% literals holds at time t" then the "associated literal holds at time t".
% p(Number) is the unique identifier of the property association.

% c(Number) :: conjunction of literals causes literal.
% A causal association between concepts in the form "when the conjunction of
% literals holds at time t" then the "associated literal holds at time t+",
% where t+ is the time-point immediately following t (t+1 for discrete time).
% c(Number) is the unique identifier of the causal association.

% r(Number) :: conjunction of literals precludes literal.
% A preclusion association between concepts in the form "when the conjunction of
% literals holds at time t" then the "associated literal is precluded from not
% holding at time t+ by the causation of its negation by a causal association",
% where t+ is the time-point immediately following t (t+1 for discrete time).
% r(Number) is the unique identifier of the preclusion association.

% literal = concept | -concept (i.e., the symbol for negation is "-")
% conjunction = true | literal | literal, conjunction (i.e., "true" = tautology)

% For programming reasons, association statements need to be range-restricted
% by ensuring that every variable in the statement appears at least twice.

% ================ Priorities Between Association Statements

% The background knowledge can also contain priority (i.e., relative strength)
% statements between association statements. In general, causal (labeled c(N))
% associations are stronger than (competing) inertia, inertia is stronger only
% than (competing) property (labeled p(M)) associations, and preclusion (labeled
% r(N)) associations are stronger than (competing) causal associations.

% Other domain-specific priorities are entered in the domain in the form:

% a(N1) >> a(N2), where a(N1) and a(N2) are names of two association statements.

% ======= Background Knowledge for "doorbell story"

% For the "doorbell story", part of the background knowledge is given below. It
% is a subset of the commonsense world knowledge pertaining to the particular
% story and the questions asked, that suffices for its successful comprehension.

% Normally, people who have the doorkeys do not ring the doorbell.
p(11) :: has(Person,doorkeys) implies -ring(Person,doorbell).

% Normally a visitor does not have the doorkeys and normally a resident does.
p(12) :: is_a(Person,visitor) implies -has(Person,doorkeys).
p(13) :: is_a(Person,resident) implies has(Person,doorkeys).

% Getting up from the chair normally stops a person from watching tv.
c(21) :: get_up(Person,chair), watch(Person,tv) causes -watch(Person,tv).

% Walking to the door implies wanting to open the door, unless one is afraid.
p(22) :: walk_to(Person,door), in_flat(Person) implies wants(Person,open(door)).
p(23) :: afraid(Person), in_flat(Person) implies -wants(Person,open(door)).
p(23) >> p(22). % this captures the precedence of p(23) over p(22).

% Walking to the door implies wanting to find out who is at the door.
p(24) :: walk_to(Person,door), in_flat(Person) implies wants(Person,find_out_who_at(door)).

% An interesting phenomenon: the observation of "afraid" enables its causation,
% so that it stops the persistence of the observation indefinitely in the past.
c(25) :: ring(Other,doorbell), person(Other), -expect(Person,visitors) causes afraid(Person).
p(26) :: walk_to(Person,door), in_flat(Person), afraid(Person) implies -expect(Person,visitors).
p(26) >> c(25). % if chaining these statements contradicts the story, c(25) will yield.

% Seeing who is a the door, initiates knowledge of that information.
c(31) :: see_at(Person,Other,door), person(Other) causes knows(Person,is_at(Other,door)).

% If the person is a flatmate, then this stops the state of being afraid.
c(32) :: knows(Person,is_at(Other,door)), flatmate(Person,Other) causes -afraid(Person).
c(32) >> c(25). % even if one did not expect visitors when the bell rang.

% Seeing a flatmate at the door causes one to want to open the door.
c(33) :: see_at(Person,Other,door), flatmate(Person,Other) causes wants(Person,open(door)).
c(33) >> p(23). % even if one is afraid.

% Seeing who is at the door terminates the state of wanting to find who it is.
c(34) :: see_at(Person,Other,door), person(Other) causes -wants(Person,find_out_who_at(door)).

% The flatmate of a person in the flat is also a resident of that flat.
p(35) :: flatmate(Person,Other), in_flat(Person) implies is_a(Other,resident).
p(35) >> p(13). % even if chaining this with p(13) would lead to a contradiction.

% Opening the door terminates the state of wanting to open the door.
c(41) :: open(Person,door) causes -wants(Person,open(door)).

% Not agreeing with a request ultimately leads to wanting to punish that person.
p(51) :: -agree(Person,request_from(Other,Request)) implies refused(Person,Other,Request).
p(52) :: refused(Person,Other,Request), request(Request) implies upset_with(Other,Person).
c(53) :: upset_with(Other,Person) causes wants(Other,punish(Person)).
c(53) >> p(54). % even if chaining this with p(54) would lead to a contradiction.

% An interesting phenomenon: giving a reason for ringing the bell, resolves
% whether Ann has the doorkeys (as a resident) or not (since she rang the doorbell).
p(54) :: in_flat(Person), wants(Other,punish(Person)) implies ring(Other,doorbell).
p(54) >> p(11). % wanting to punish leads to ringing even if one has the keys.

% ==============================================================================
% ==============================================================================

