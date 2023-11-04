% Define o tabuleiro inicial
% Defina o tabuleiro inicial com listas vazias.
initialBoard([
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
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
piece([black, black]) :- write('   TX    ').
piece([black, black, black]) :- write('   CX    ').
piece([black, black, black, black]) :- write('   BX    ').
piece([black, black, black, black, black]) :- write('   RX    ').


piece([white]) :- write('    O    ').
piece([white, white]) :- write('   TO    ').
piece([white, white, white]) :- write('   CO    ').
piece([white, white, white, white]) :- write('   BO    ').
piece([white, white, white, white, white]) :- write('   RO    ').
piece([black,1]) :- write('    X    ').
piece([white,1]) :- write('    O    ').

% Print a combination of two pieces
piece([black, 2]) :- write('   XX   ').
piece([white, 2]) :- write('   OO   ').

% Print a combination of three pieces
piece([black, 3]) :- write('  XXX  ').
piece([white, 3]) :- write('  OOO  ').

% Print a combination of four pieces
piece([black, 4]) :- write('XXXX').
piece([white, 4]) :- write('OOOO').

% Print a combination of five pieces
piece([black, 5]) :- write('XXXXX').
piece([white, 5]) :- write('OOOOO').


% Print the winner
piece([black, 6]) :- write('X Wins').
piece([white, 6]) :- write('O Wins').