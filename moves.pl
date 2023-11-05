% P movement

% Check if the move is horizontal (same row)
valid_horizontal_move_P(CurrentX, NewX, CurrentY, NewY) :-
    CurrentX =:= NewX,                   % Same row
    abs(NewY - CurrentY) =:= 1.          % Move only one cell in the row

% Check if the move is vertical (same column)
valid_vertical_move_P(CurrentX, NewX, CurrentY, NewY) :-
    CurrentY =:= NewY,                   % Same column
    abs(NewX - CurrentX) =:= 1.          % Move only one cell in the column

% Ensure the move is either horizontal or vertical
valid_horizontal_or_vertical_move_P(CurrentX, NewX, CurrentY, NewY) :-
    valid_horizontal_move_P(CurrentX, NewX, CurrentY, NewY);
    valid_vertical_move_P(CurrentX, NewX, CurrentY, NewY).

% R movement

valid_horizontal_move_R(CurrentX, NewX, CurrentY, NewY) :-
    CurrentX =:= NewX,                   % Same row
    NewX >= 0, NewX < 5.

% Check if the move is vertical (same column)
valid_vertical_move_R(CurrentX, NewX, CurrentY, NewY) :-
    CurrentY =:= NewY,                   % Same column
    NewY >= 0, NewY < 5.

% Ensure the move is either horizontal or vertical
valid_horizontal_or_vertical_move_R(CurrentX, NewX, CurrentY, NewY) :-
    valid_horizontal_move_R(CurrentX, NewX, CurrentY, NewY);
    valid_vertical_move_R(CurrentX, NewX, CurrentY, NewY).

% L movement
valid_knight_move_1(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewY - CurrentY) =:= 2,          
    abs(NewX - CurrentX) =:= 1.          

valid_knight_move_2(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewY - CurrentY) =:= 1,          
    abs(NewX - CurrentX) =:= 2.          

valid_knight_move(CurrentX, NewX, CurrentY, NewY):-
    valid_knight_move_1(CurrentX, NewX, CurrentY, NewY);
    valid_knight_move_2(CurrentX, NewX, CurrentY, NewY).

% B movement
valid_bishop_move(CurrentX, NewX, CurrentY, NewY) :-
    abs(NewX - CurrentX) =:= abs(NewY - CurrentY).




% validates all moves

validate_move(CurrentX, CurrentY, NewX, NewY, 1):-
    (valid_horizontal_or_vertical_move_P(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Pawn can only move in horizontal or vertical moves and one cell. Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 2):-
    (valid_horizontal_or_vertical_move_R(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Rook can only move in horizontal or vertical moves. Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 3):-
    (valid_knight_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Knight can only move in L shape (1 step orthogonal and then 1 step diagonal). Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 4):-
    (valid_bishop_move(CurrentX, NewX, CurrentY, NewY) ->
        true
    ;
        write('Invalid move. Bishop only moves diagonally. Try again.'),
        false
    ).

validate_move(CurrentX, CurrentY, NewX, NewY, 5):-
    true.
