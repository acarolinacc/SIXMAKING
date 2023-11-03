% Define o tabuleiro inicial
% Defina o tabuleiro inicial com listas vazias.
initialBoard([
    [[], [], [], [black, white, black], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [black], [], [], []],
    [[], [], [], [], []]
]).


% Define as letras para cada linha
letter(1, '1').
letter(2, '2').
letter(3, '3').
letter(4, '4').
letter(5, '5').

% Imprime o tabuleiro
printBoard(X) :-
    nl,
    write('   |    1    |    2    |    3    |    4    |    5    |\n'),
    write('---|---------|---------|---------|---------|---------|\n'),
    printMatrix(X, 1).

% Atualiza a regra printLine para lidar com os novos tipos de peças
printLine([]).
printLine([Head|Tail]) :-
    piece(Head), % Usa a regra piece/1 para obter a representação da peça
    printLine(Tail).

% Imprime a matriz
printMatrix([], 6).
printMatrix([Head|Tail], N) :-
    letter(N, L),
    N1 is N + 1,
    write('   |         |         |         |         |         |\n'),
    write(' '),
    write(L),
    write(' |'),
    printLine(Head),
    write('\n---|---------|---------|---------|---------|---------|\n'),
    printMatrix(Tail, N1).

% Imprime uma linha
printLine([]).
printLine([Head|Tail]) :-
    piece(Head), % Usa a regra piece/1 para obter a representação da peça
    printLine(Tail).


% Print a piece
piece([]) :- write('          ').
piece([black]) :- write('    X    ').
piece([white]) :- write('    O    ').

% Print a combination of two pieces
piece([black, black]) :- write('   XX   ').
piece([white, white]) :- write('   OO   ').
piece([black, white]) :- write('   XO   ').
piece([white, black]) :- write('   OX   ').

% Print a combination of three pieces
piece([black, black, black]) :- write('  XXX  ').
piece([white, white, white]) :- write('  OOO  ').
piece([black, black, white]) :- write('  XXO  ').
piece([black, white, black]) :- write('  XOX  ').
piece([white, black, black]) :- write('  OXX  ').
piece([white, white, black]) :- write('  OOX  ').
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