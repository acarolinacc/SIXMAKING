clear:- 
    write('\33\[2J').

% Definição da função nth0/3
nth0(0, [X|_], X).
nth0(N, [_|Resto], Elemento) :-
    N > 0,
    N1 is N - 1,
    nth0(N1, Resto, Elemento).

% Obtém o elemento em uma posição específica da lista
nth1(1, [X|_], X).
nth1(N, [_|T], X) :-
    N > 1,
    N1 is N - 1,
    nth1(N1, T, X).

% Verifica se uma peça tem a cor correta
hasCorrectColor(Piece, Player) :-
    Piece = [Player|_].

% Verifica se uma torre é válida (não vazia)
is_valid_tower(Tower) :- Tower \= [].