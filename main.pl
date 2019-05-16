%Creates the environment
place_mirrors(Start, Barriers, Mirrors) :-
    mirror(Start,Barriers,right,[1,Start],[[1,Start],[0,Start]],[],Mirrors).


%Final
mirror(A, _,_,[11,A],_,M,M).
%Start
mirror(Start, Barriers, PrevDirection,[X,Y],Visited,OldMirrors,M) :-
    move(Start,PrevDirection,NewPrevDirection,[X,Y],[NewX,NewY],OldMirrors,NewMirrors),
    in_bounds([NewX,NewY]),
    check_obstacles([NewX,NewY], Barriers),
    visited([NewX,NewY],Visited),
    mirror(Start, Barriers, NewPrevDirection, [NewX,NewY],[[NewX,NewY]|Visited],NewMirrors,M).

%Right
move(_,up,UpdatedPrev,[CurrX,CurrY],[X,CurrY],OldMirrors,NewMirrors) :-
    X is CurrX+1,
    UpdatedPrev = right,
    NewMirrors = [[CurrX,CurrY,/]|OldMirrors].

move(_,down,UpdatedPrev,[CurrX,CurrY],[X,CurrY],OldMirrors,NewMirrors) :-
    X is CurrX+1,
    UpdatedPrev = right,
    NewMirrors = [[CurrX,CurrY,\]|OldMirrors].

move(_,right,UpdatedPrev,[CurrX,CurrY],[X,CurrY],OldMirrors,OldMirrors)  :-
    X is CurrX+1,
    UpdatedPrev = right.
%Down
move(Start,right,UpdatedPrev,[CurrX,CurrY],[CurrX,Y],OldMirrors,NewMirrors) :-
    Y is CurrY-1,
    UpdatedPrev = down,
    [CurrX,Y] \= [11,Start],
    NewMirrors = [[CurrX,CurrY,\]|OldMirrors].

move(Start,down,UpdatedPrev,[CurrX,CurrY],[CurrX,Y],OldMirrors,OldMirrors) :-
    Y is CurrY-1,
    [CurrX,Y] \= [11,Start],
    UpdatedPrev = down.


%Up
move(Start,right,UpdatedPrev,[CurrX,CurrY],[CurrX,Y],OldMirrors,NewMirrors) :-
    Y is CurrY+1,
    UpdatedPrev = up,
    [CurrX,Y] \= [11,Start],
    NewMirrors = [[CurrX,CurrY,/]|OldMirrors].

move(Start,up,UpdatedPrev,[CurrX,CurrY],[CurrX,Y],OldMirrors,OldMirrors)  :-
    Y is CurrY+1,
    [CurrX,Y] \= [11,Start],
    UpdatedPrev = up.


%Checks if the laser is within boundaries
in_bounds([X,Y]) :-
    X < 12,
    X >= 0,
    Y >= 0,
    Y < 10.

wall([A,B],[X,Z,Y]) :-
    D is X+Z,
    A is A,
    not(between(X,D,A));
    B < 10-Y.

not_hitting_person([A,B]) :-
    B > 5;
    A > 6;
	A < 4.

check_obstacles([X,Y], [Head|Tail]) :-
    nth0(0,Head,TX),
    nth0(1,Head,Width),
    nth0(2,Head,Height),
    not_hitting_person([X,Y]),
    wall([X,Y],[TX,Width,Height]),
    check_obstacles([X,Y],Tail).
check_obstacles([_,_], []).

visited([_,_],[]).
visited([CurrX,CurrY],[Head|Tail]):-
	[CurrX,CurrY] \= Head,
	visited([CurrX, CurrY],Tail).