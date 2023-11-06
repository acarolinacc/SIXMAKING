% Predicado para substituir um elemento em uma lista (baseado em indexação 0).
replaceInList([H|T], 0, Value, [Value|T]) :- !.  % Quando o índice é 0, substitua o elemento.
replaceInList([H|T], Index, Value, [H|TNew]) :-
    Index > 0,
    Index1 is Index - 1,
    replaceInList(T, Index1, Value, TNew).  % Recursivamente, continue procurando o índice para substituir.

% Predicado para substituir um elemento em uma matriz (baseado em indexação 0).
replaceInMatrix([H|T], 0, Column, Value, [HNew|T]) :-
    replaceInList(H, Column, Value, HNew).  % Quando o índice da linha é 0, substitua na linha.
replaceInMatrix([H|T], Row, Column, Value, [H|TNew]) :-
    Row > 0,
    Row1 is Row - 1,
    replaceInMatrix(T, Row1, Column, Value, TNew).  % Recursivamente, continue procurando a linha e coluna para substituir.

% Predicado para obter um valor de uma lista (baseado em indexação 0).
getValueFromList([H|_], 0, Value) :-
    Value = H.  % Quando o índice é 0, obtenha o valor.
getValueFromList([H|T], Index, Value) :-
    Index > 0,
    Index1 is Index - 1,
    getValueFromList(T, Index1, Value).  % Recursivamente, continue procurando o índice para obter o valor.

% Predicado para obter um valor de uma matriz (baseado em indexação 0).
getValueFromMatrix([H|_], 0, Column, Value) :-
    getValueFromList(H, Column, Value).  % Quando o índice da linha é 0, obtenha o valor na coluna.
getValueFromMatrix([H|T], Row, Column, Value) :-
    Row > 0,
    Row1 is Row - 1,
    getValueFromMatrix(T, Row1, Column, Value).  % Recursivamente, continue procurando a linha e coluna para obter o valor.

% Predicado para verificar se o tabuleiro está completamente preenchido.
checkFullBoard(Board) :-
    \+ (append(_, [R|_], Board),
        append(_, ['empty'|_], R)).  % O tabuleiro está completo se não houver 'empty' em nenhuma linha.
