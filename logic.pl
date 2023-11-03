:- dynamic board/1.          % Declara a estrutura dinâmica board/1.
:- dynamic previousBoard/1.  % Declara a estrutura dinâmica previousBoard/1.

% Inicializa o tabuleiro no início do jogo.
initBoard :-
    initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
    assertz(board(InitialBoard)),  % Adiciona o tabuleiro como um facto dinâmico.
    assertz(previousBoard(InitialBoard)).  % Adiciona o tabuleiro anterior como um facto dinâmico.

% Atualiza o tabuleiro atual e o tabuleiro anterior.
updateBoard(NewBoard) :-
    retract(board(_)),            % Retira o tabuleiro atual.
    assertz(board(NewBoard)),     % Adiciona o novo tabuleiro como um facto dinâmico.
    retract(previousBoard(_)),    % Retira o tabuleiro anterior.
    assertz(previousBoard(NewBoard)).  % Adiciona o novo tabuleiro como um facto dinâmico.

% Use o tabuleiro atual no início de cada jogada.
getCurrentBoard(CurrentBoard) :-
    board(CurrentBoard).


% Verifica o estado atual do jogo após cada jogada.
checkGameState(Player, Board) :-
    (checkFullBoard(Board) -> drawMessage  % Verifica se o tabuleiro está cheio.).

drawMessage :-
    write('Woops, no more space left! It is a draw!').  % Mensagem de empate.


% Verifica a validade de uma jogada.
checkMove(Board, Player, NewBoard, Expected, ColumnIndex, RowIndex) :-
    (
        % Verifica se o jogador tenta mover um trabalhador vazio para uma célula com uma peça esperada (black ou white).
        (Player = [empty], member(Expected, [[black], [white]]),
            (
                getValueFromMatrix(Board, RowIndex, ColumnIndex, Expected),
                replaceInMatrix(Board, RowIndex, ColumnIndex, Player, NewBoard)
                ;
                write('INVALID MOVE: There is no worker in that cell, please try again!\n\n'),
                askCoords(Board, Player, NewBoard, Expected)
            )
        )
        ;

        % Verifica se o jogador tenta mover uma peça (black ou white) para qualquer célula.
        ((Player = [black]; Player = [white]),
            (
                % Verifica se a célula de destino (determinada por RowIndex e ColumnIndex) está vazia (empty) ou contém uma peça do jogador ou é de outra cor.
                (getValueFromMatrix(Board, RowIndex, ColumnIndex, DestinationValue),
                (DestinationValue = []),
                replaceInMatrix(Board, RowIndex, ColumnIndex, Player, NewBoard)
                ;
                write('INVALID MOVE: This move is not allowed, please try again!\n\n'),
                askCoords(Board, Player, NewBoard, Expected)
            )
        )
        )
        ;

        % Outras situações de movimento inválido.
        (
            write('INVALID MOVE: This move is not allowed, please try again!\n\n'),
            askCoords(Board, Player, NewBoard, Expected)
        )
    ).



% Pede as coordenadas de uma jogada.
askCoords(Board, Player, NewBoard, Expected) :-
    manageRow(NewRow),  % Obtém a linha escolhida pelo jogador.
    manageColumn(NewColumn),  % Obtém a coluna escolhida pelo jogador.
    write('\n'),
    ColumnIndex is NewColumn - 1,  % Converte o número da coluna para o índice da matriz.
    RowIndex is NewRow - 1,  % Converte o número da linha para o índice da matriz.
    checkMove(Board, Player, NewBoard, Expected, ColumnIndex, RowIndex).


% Adiciona trabalhadores ao tabuleiro.
addWorkers(InitialBoard, WorkersBoard, 'P', 'P') :-
      printBoard(InitialBoard),  % Imprime o tabuleiro inicial.
      write('\n------------------ PLAYER X -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(InitialBoard, [black], Worker1Board, empty),
      printBoard(Worker1Board),  % Imprime o tabuleiro após o jogador X escolher uma célula.
      write('\n------------------ PLAYER O -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(Worker1Board, [white], WorkersBoard, empty),
      printBoard(WorkersBoard).  % Imprime o tabuleiro após o jogador O escolher uma célula.

% Funções para a vez do jogador preto e branco.
blackPlayerTurn(Board, NewBoard, 'P') :-
    playerTurn(Board, NewBoard, 'black', 'PLAYER X').

blackPlayerTurn(Board, NewBoard, 'C') :-
    playerTurn(Board, NewBoard, 'black', 'COMPUTER X').

whitePlayerTurn(Board, NewBoard, 'P') :-
    playerTurn(Board, NewBoard, 'white', 'PLAYER O').

whitePlayerTurn(Board, NewBoard, 'C') :-
    playerTurn(Board, NewBoard, 'white', 'COMPUTER O').

% Função principal para a vez de um jogador.
% Predicado para adicionar uma nova peça (Place a new disk)
addNewDisk(Board, NewBoard, PlayerColor) :-
    write('Choose a cell to add a new piece.\n'),
    askCoords(Board, [PlayerColor], NewBoard, empty).

% Função para mover uma torre
moveTower(Board, NewBoard, PlayerColor) :-
    write('Choose any tower to move.\n'),
    selectTower(Board, [PlayerColor], SelectedTower),  % Escolha de uma torre
    write('Choose the destination cell for the tower (must not be empty and must be of your color).\n'),
    askDestination(Board, [PlayerColor], SelectedTower, NewBoard).

% Selecione uma torre válida (não vazia e da cor certa) para mover
selectTower(Board, Player, SelectedTower) :-
    manageRow(Row),       % Obtenha a linha escolhida pelo jogador
    manageColumn(Column),  % Obtenha a coluna escolhida pelo jogador
    get_piece(Board, Row, Column, Piece),
    (
        is_valid_tower(Piece),  % Verifique se a torre não está vazia
        hasCorrectColor(Piece, Player) -> SelectedTower = Piece  % Verifique se a torre tem a cor certa
        ;
        write('INVALID MOVE: The selected tower is empty or not of your color, please try again!\n\n'),
        selectTower(Board, Player, SelectedTower)
    ).

% Solicita a escolha de uma célula de destino que não esteja vazia e da cor certa
askDestination(Board, Player, SelectedTower, NewBoard) :-
    manageRow(Row),       % Obtenha a linha escolhida pelo jogador
    manageColumn(Column),  % Obtenha a coluna escolhida pelo jogador
    get_piece(Board, Row, Column, Piece),
    (
        is_not_empty(Piece),  % Verifique se a célula de destino não está vazia
        hasCorrectColor(Piece, Player) ->  % Verifique se a célula de destino tem a cor certa
            (
                is_valid_tower(Piece) ->  % Verifique se a célula de destino contém uma torre
                    write('INVALID MOVE: The destination cell must not be empty, please try again!\n\n'),
                    askDestination(Board, Player, SelectedTower, NewBoard)
                ;
                remove_piece(Board, Row, Column, TempBoard),
                add_piece(TempBoard, Row, Column, SelectedTower, NewBoard),
                printBoard(NewBoard)  % Imprima o tabuleiro após a jogada
            )
        ;
        write('INVALID MOVE: The destination cell is empty or not of your color, please try again!\n\n'),
        askDestination(Board, Player, SelectedTower, NewBoard)
    ).


% Verifica se uma peça tem a cor correta
hasCorrectColor(Piece, Player) :-
    Piece = [Player|_].

% Obtém o elemento em uma posição específica da lista
nth1(1, [X|_], X).
nth1(N, [_|T], X) :-
    N > 1,
    N1 is N - 1,
    nth1(N1, T, X).


% Obtém a peça em uma posição específica do tabuleiro
get_piece(Board, Row, Col, Piece) :-
    nth1(Row, Board, RowList),  % Obtém a linha (lista) correspondente à linha 'Row'
    nth1(Col, RowList, Piece).  % Obtém a coluna (elemento) correspondente à coluna 'Col'

% Remove uma peça de uma posição específica do tabuleiro
remove_piece(Board, Row, Col, NewBoard) :-
    nth1(Row, Board, RowList),     % Obtém a linha (lista) correspondente à linha 'Row'
    select(_, RowList, NewRowList), % Remove um elemento da linha
    replace(Board, Row, NewRowList, NewBoard).  % Atualiza a linha no novo tabuleiro

% Adiciona uma peça a uma posição específica do tabuleiro
add_piece(Board, Row, Col, Piece, NewBoard) :-
    nth1(Row, Board, RowList),        % Obtém a linha (lista) correspondente à linha 'Row'
    nth1(Col, RowList, CurrentPiece),  % Obtém a peça atual na posição
    append([Piece], CurrentPiece, NewPiece),  % Adiciona a nova peça à pilha da posição
    select(CurrentPiece, RowList, UpdatedRowList),  % Remove a peça antiga da linha
    nth1(Row, NewBoard, UpdatedRowList, NewRowList),  % Atualiza a linha no novo tabuleiro
    replace(Board, Row, NewRowList, NewBoard).  % Atualiza o tabuleiro com a nova linha

% Verifica se uma torre é válida (não vazia)
is_valid_tower(Tower) :- Tower \= [].

% Verifica se uma posição não está vazia
is_not_empty(Piece) :- Piece \= [].

% Substitui o elemento 'Old' por 'New' na lista 'List' e retorna 'NewList'
replace(List, Old, New, NewList) :-
    select(Old, List, TempList),
    append([New], TempList, NewList).


    
% Função principal para o turno do jogador
playerTurn(Board, NewBoard, PlayerColor, PlayerName) :-
    write('\n------------------ '), write(PlayerName), write(' -------------------\n\n'),
    write('1. Do you want to move a tower or add a new disk? [0(Add Disk)/1(Move Tower)]'),
    manageMoveWorkerBool(MoveWorkerBool),  % Obtém a escolha do jogador (mover torre ou adicionar peça).
    (
        MoveWorkerBool =:= 1 ->
            moveTower(Board, NewBoard, PlayerColor)   % O jogador escolhe mover uma torre.
        ;
            addNewDisk(Board, NewBoard, PlayerColor)  % O jogador escolhe adicionar uma nova peça.
    ),
    printBoard(NewBoard).  % Imprime o tabuleiro após a jogada.


% Loop principal do jogo.
gameLoop(Board, Player1, Player2) :-
      blackPlayerTurn(Board, NewBoard, Player1),
      (
            (whitePlayerTurn(NewBoard, FinalBoard, Player2),
                  (
                        (gameLoop(FinalBoard, Player1, Player2))  % Continua o loop do jogo.
                  )
            )
      ).


% Função para iniciar o jogo.
startGame(Player1, Player2) :-
      initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
      addWorkers(InitialBoard, WorkersBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
      gameLoop(WorkersBoard, Player1, Player2).  % Inicia o loop do jogo.










% Definição da função nth0/3
nth0(0, [X|_], X).
nth0(N, [_|Resto], Elemento) :-
    N > 0,
    N1 is N - 1,
    nth0(N1, Resto, Elemento).


% Defina as regras de movimento para o Peão
move(peao, X1/Y1, X2/Y2, Tabuleiro) :-
    % Certifique-se de que as coordenadas X1/Y1 estão ocupadas por uma torre.
    nth0(Y1, Tabuleiro, Linha),
    nth0(X1, Linha, torre),
    % Verifique se X2/Y2 está em uma das quatro direções adjacentes.
    (X2 is X1 + 1, Y2 = Y1; X2 is X1 - 1, Y2 = Y1; X2 = X1, Y2 is Y1 + 1; X2 = X1, Y2 is Y1 - 1),
    % Certifique-se de que X2/Y2 está dentro dos limites do tabuleiro.
    dentro_dos_limites(X2, Y2, Tabuleiro).

% Defina as regras de movimento para a Torre
move(torre, X1/Y1, X2/Y2, Tabuleiro) :-
    % Certifique-se de que as coordenadas X1/Y1 estão ocupadas por uma torre.
    nth0(Y1, Tabuleiro, Linha),
    nth0(X1, Linha, torre),
    % Certifique-se de que X2/Y2 está em uma direção ortogonal (horizontal ou vertical).
    (X1 = X2; Y1 = Y2),
    % Verifique se não há torres no caminho entre X1/Y1 e X2/Y2.
    sem_torres_no_caminho(X1, Y1, X2, Y2, Tabuleiro).

% Verifique se X/Y está dentro dos limites do tabuleiro.
dentro_dos_limites(X, Y, Tabuleiro) :-
    length(Tabuleiro, Tam),
    X >= 0, Y >= 0, X < Tam, Y < Tam.

% Verifique se não há torres no caminho entre X1/Y1 e X2/Y2.
sem_torres_no_caminho(X, Y, X, Y, _).
sem_torres_no_caminho(X1, Y1, X2, Y2, Tabuleiro) :-
    (X1 = X2, Y1 < Y2, Y is Y1 + 1; X1 = X2, Y1 > Y2, Y is Y1 - 1),
    nth0(Y, Tabuleiro, Linha),
    nth0(X1, Linha, vazio),
    sem_torres_no_caminho(X1, Y, X2, Y2, Tabuleiro).

% Defina as regras de movimento para o Cavalo
move(cavalo, X1/Y1, X2/Y2, Tabuleiro) :-
    % Certifique-se de que as coordenadas X1/Y1 estão ocupadas por uma torre.
    nth0(Y1, Tabuleiro, Linha),
    nth0(X1, Linha, torre),
    % Verifique as possíveis posições de destino para um movimento em forma de "L".
    PossiveisDestinos = [X1-2/Y1-1, X1-2/Y1+1, X1-1/Y1-2, X1-1/Y1+2, X1+1/Y1-2, X1+1/Y1+2, X1+2/Y1-1, X1+2/Y1+1],
    member(X2/Y2, PossiveisDestinos),
    % Certifique-se de que X2/Y2 está dentro dos limites do tabuleiro.
    dentro_dos_limites(X2, Y2, Tabuleiro).

% Defina as regras de movimento para o Bispo
move(bispo, X1/Y1, X2/Y2, Tabuleiro) :-
    % Certifique-se de que as coordenadas X1/Y1 estão ocupadas por uma torre.
    nth0(Y1, Tabuleiro, Linha),
    nth0(X1, Linha, torre),
    % Verifique se o movimento é diagonal (delta X é igual ao delta Y).
    DX is abs(X2 - X1),
    DY is abs(Y2 - Y1),
    DX = DY,
    % Verifique se não há torres no caminho entre X1/Y1 e X2/Y2 na diagonal.
    sem_torres_na_diagonal(X1, Y1, X2, Y2, Tabuleiro).

% Defina as regras de movimento para a Rainha
move(rainha, X1/Y1, X2/Y2, Tabuleiro) :-
    % Certifique-se de que as coordenadas X1/Y1 estão ocupadas por uma torre.
    nth0(Y1, Tabuleiro, Linha),
    nth0(X1, Linha, torre),
    % Verifique se o movimento é ortogonal ou diagonal.
    (X1 = X2; Y1 = Y2; abs(X2 - X1) = abs(Y2 - Y1)),
    % Verifique se não há torres no caminho entre X1/Y1 e X2/Y2 na direção escolhida.
    sem_torres_no_caminho(X1, Y1, X2, Y2, Tabuleiro).

% Verifique se não há torres no caminho na diagonal.
sem_torres_na_diagonal(X, Y, X, Y, _).
sem_torres_na_diagonal(X1, Y1, X2, Y2, Tabuleiro) :-
    DX is sign(X2 - X1),
    DY is sign(Y2 - Y1),
    X1n is X1 + DX,
    Y1n is Y1 + DY,
    nth0(Y1n, Tabuleiro, Linha),
    nth0(X1n, Linha, vazio),
    sem_torres_na_diagonal(X1n, Y1n, X2, Y2, Tabuleiro).
