% Define the initial board
initialBoard([
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty]
]).

% Define the symbols for each piece
symbol(empty, S) :- S = ' '.
symbol(black, S) :- S = 'X'.
symbol(white, S) :- S = 'O'.

% Define the letters for each row
letter(1, L) :- L = '1'.
letter(2, L) :- L = '2'.
letter(3, L) :- L = '3'.
letter(4, L) :- L = '4'.
letter(5, L) :- L = '5'.

% Print the board
printBoard(X) :-
    nl,
    write('   | 1 | 2 | 3 | 4 | 5 |\n'),
    write('---|---|---|---|---|---|\n'),
    printMatrix(X, 1).

% Update the printLine predicate to handle the new piece types
printLine([]).
printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).


% Print the matrix
printMatrix([], 6).
printMatrix([Head|Tail], N) :-
    letter(N, L),
    write(' '),
    write(L),
    N1 is N + 1,
    write(' | '),
    printLine(Head),
    write('\n---|---|---|---|---|---|\n'),
    printMatrix(Tail, N1).

% Print a line
printLine([]).
printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).


piece(empty).
piece(peao(black)).
piece(peao(white)).
piece(torre(black)).
piece(torre(white)).
piece(cavalo(black)).
piece(cavalo(white)).
piece(bispo(black)).
piece(bispo(white)).
piece(rainha(black)).
piece(rainha(white)).


% Print a piece
piece([black]) :- write('X').
piece([white]) :- write('O').

% Print a combination of two pieces
piece([black, black]) :- write('XX').
piece([white, white]) :- write('OO').
piece([black, white]) :- write('XO').
piece([white, black]) :- write('OX').

% Print a combination of three pieces
piece([black, black, black]) :- write('XXX').
piece([white, white, white]) :- write('OOO').
piece([black, black, white]) :- write('XXO').
piece([black, white, black]) :- write('XOX').
piece([white, black, black]) :- write('OXX').
piece([white, white, black]) :- write('OOX').
piece([black, white, white]) :- write('XOO').
piece([white, black, white]) :- write('OXO').

% Print a combination of four pieces
piece([black, black, black, black]) :- write('XXXX').
piece([white, white, white, white]) :- write('OOOO').
piece([black, black, black, white]) :- write('XXXO').
piece([black, black, white, black]) :- write('XXOX').
piece([black, white, black, black]) :- write('XOXX').
piece([white, black, black, black]) :- write('OXXX').
piece([white, white, white, black]) :- write('OOOX').
piece([white, white, black, white]) :- write('OOXO').
piece([white, black, white, white]) :- write('OXOO').
piece([black, white, white, white]) :- write('XOOO').
piece([white, black, white, black]) :- write('OXOX').
piece([black, white, black, white]) :- write('XOXO').

% Print a combination of five pieces
piece([black, black, black, black, black]) :- write('XXXXX').
piece([white, white, white, white, white]) :- write('OOOOO').
piece([black, black, black, black, white]) :- write('XXXXO').
piece([black, black, black, white, black]) :- write('XXXOX').
piece([black, black, white, black, black]) :- write('XXOXX').
piece([black, white, black, black, black]) :- write('XOXXX').
piece([white, black, black, black, black]) :- write('OXXXX').
piece([white, white, white, white, black]) :- write('OOOOX').
piece([white, white, white, black, white]) :- write('OOOXO').
piece([white, white, black, white, white]) :- write('OOXOO').
piece([white, black, white, white, white]) :- write('OXOOO').
piece([black, white, white, white, white]) :- write('XOOOO').
piece([white, black, white, black, white]) :- write('OXOXO').
piece([black, white, black, white, white]) :- write('XOXOO').
piece([black, black, white, white, white]) :- write('XXOOO').
piece([black, white, black, black, white]) :- write('XOXOX').
piece([white, black, black, black, white]) :- write('OXOXX').
piece([white, white, black, black, black]) :- write('OOXXX').
piece([white, black, white, black, black]) :- write('OXOXO').
piece([black, white, black, white, black]) :- write('XOXOX').

% Print the winner
piece([_, _, _, _, _, black]) :- write('X Wins').
piece([_, _, _, _, _, white]) :- write('O Wins').
