% Define piece types
piece(pawn, 1).
piece(rook, 2).
piece(knight, 3).
piece(bishop, 4).
piece(_, 5).

% Define movement rules
chess_moves(pawn, Row, NewRow, Column, NewColumn) :-
    (Row =:= NewRow, abs(NewColumn - Column) =:= 1) ; (Column =:= NewColumn, abs(NewRow - Row) =:= 1).

chess_moves(rook, Row, NewRow, Column, NewColumn) :-
    (Row =:= NewRow, NewRow >= 0, NewRow < 5) ; (Column =:= NewColumn, NewColumn >= 0, NewColumn < 5).

chess_moves(knight, Row, NewRow, Column, NewColumn) :-
    (abs(NewColumn - Column) =:= 2, abs(NewRow - Row) =:= 1) ; (abs(NewColumn - Column) =:= 1, abs(NewRow - Row) =:= 2).

chess_moves(bishop, Row, NewRow, Column, NewColumn) :-
    abs(NewRow - Row) =:= abs(NewColumn - Column).

% Validate all moves
check_move(Row, Column, NewRow, NewColumn, PieceType) :-
    piece(Piece, PieceType),
    (chess_moves(Piece, Row, NewRow, Column, NewColumn) ->
        true
    ;
        format('Invalid move. ~w can only make the specified move. Try again.~n', [Piece]),
        false
    ).

