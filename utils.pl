clear:- 
    write('\33\[2J').

:- use_module(library(time)).

% Exemplo de atraso de 2 segundos
delay_seconds(N) :-
    sleep(N).

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

is_valid_index(Board, RowIndex, ColumnIndex, PlayerColor) :- 
    % Verifique se a célula de destino não está vazia e é da cor do jogador
    nth0(RowIndex, Board, RowList),
    nth0(ColumnIndex, RowList, DestCell),
    is_valid_tower(DestCell),
    hasCorrectColor(DestCell, PlayerColor).


% Predicado para adicionar N elementos a uma lista
add_n_elements(N, Element, InputList, ResultList) :-
    add_n_elements(N, Element, InputList, ResultList, []).

% Caso base: quando N é zero, a lista resultante é a mesma que a lista de entrada
add_n_elements(0, _, ResultList, ResultList, _).

% Caso recursivo: adicionar o elemento à lista e continuar com N-1
add_n_elements(N, Element, InputList, ResultList, Acc) :-
    N > 0,
    N1 is N - 1,
    add_n_elements(N1, Element, InputList, ResultList, [Element | Acc]).

% Predicado para remover N elementos de uma lista
remove_n_elements(N, InputList, ResultList) :-
    remove_n_elements(N, InputList, ResultList, []).

% Caso base: quando N é zero, a lista resultante é a mesma que a lista de entrada
remove_n_elements(0, ResultList, ResultList, _).

% Caso recursivo: remove o primeiro elemento da lista e continua com N-1
remove_n_elements(N, [Head | Tail], ResultList, Acc) :-
    N > 0,
    N1 is N - 1,
    remove_n_elements(N1, Tail, ResultList, [Head | Acc]).