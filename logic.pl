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
    (
        checkFullBoard(Board) -> drawMessage  % Verifica se o tabuleiro está cheio.
        ;
        checkValidSpots(Board, 0, 0, Result), Result =:= 0 -> drawMessage  % Verifica se há jogadas válidas.
    ).

drawMessage :-
    write('Woops, no more space left! It is a draw!').  % Mensagem de empate.

% Loop do jogo, em que recebe a jogada de cada jogador e verifica o estado do jogo a seguir.
gameLoop(Board, Player1, Player2) :-
    getCurrentBoard(CurrentBoard),  % Obtém o tabuleiro atual.
    (
        Player1 == 'P' -> 
            (
                blackPlayerTurn(CurrentBoard, NewBoard, Player1),
                updateBoard(NewBoard)
            );
        Player1 == 'C' -> 
            (
                blackPlayerTurn(CurrentBoard, NewBoard, Player1),
                updateBoard(NewBoard)
            )
    ),
    (
        (checkGameState('black', NewBoard), write('\nThanks for playing!\n'));  % Verifica o estado do jogo para o jogador preto.
        (
            Player2 == 'P' -> 
                (
                    % Use o tabuleiro atual e a vez do jogador branco.
                    whitePlayerTurn(NewBoard, FinalBoard, Player2),
                    updateBoard(FinalBoard)
                );
            Player2 == 'C' -> 
                (
                    % Use o tabuleiro atual e a vez do jogador branco (computador).
                    whitePlayerTurn(NewBoard, FinalBoard, Player2),
                    updateBoard(FinalBoard)
                )
        ),
        (
            (checkGameState('white', FinalBoard), write('\nThanks for playing!\n'));  % Verifica o estado do jogo para o jogador branco.
            gameLoop(FinalBoard, Player1, Player2)  % Continua o jogo.
        )
    ).

% Verifica se existem jogadas válidas em todas as células do tabuleiro.
checkValidSpots(Board, Row, Column, Result) :-
      (
            (Column =:= 11, Row1 is Row + 1, checkValidSpots(Board, Row1, 0, Result));
            (Row =:= 11, Result is 0);
            ((isValidPosLines(Board, Row, Column, Res)), 
                  ((Res =:= 0, Column1 is Column + 1, checkValidSpots(Board, Row, Column1, Result));
                  (Res =:=1 , Result is 1)))
      ), !.

% Verifica se uma célula está vazia.
isValidPosLines(Board, Row, Column, Res) :-
    isEmptyCell(Board, Row, Column, Res).

isEmptyCell(Board, Row, Column, Res) :-
    ((getValueFromMatrix(Board, Row, Column, Value), Value == empty, !, Res is 1);
    Res is 0).

% Verifica a validade de uma jogada.
checkMove(Board, Player, NewBoard, Expected, ColumnIndex, RowIndex) :-
    (
        % Verifica se o jogador tenta mover um trabalhador vazio para uma célula com uma peça esperada (black ou white).
        (Player == empty, member(Expected, [black, white]),
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
        ((Player == black; Player == white),
            (
                % Verifica se a célula de destino (determinada por RowIndex e ColumnIndex) está vazia (empty) ou contém uma peça do jogador ou é de outra cor.
                (getValueFromMatrix(Board, RowIndex, ColumnIndex, DestinationValue),
                (DestinationValue == empty ; DestinationValue == Player ; DestinationValue \== Player),
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

% Função para mover um trabalhador.
moveWorker(Board, 1, NewBoard, PlayerColor) :-
    write('\n2. Choose tower current cell.\n'),
    askCoords(Board, empty, NoWorkerBoard, PlayerColor),
    write('3. Choose tower new cell.\n'),
    askCoords(NoWorkerBoard, PlayerColor, NewBoard, empty),
    printBoard(NewBoard).

% Em seguida, você pode usar moveWorkerBlack e moveWorkerWhite como segue:

moveWorkerBlack(Board, 1, NewBoard) :- moveWorker(Board, 1, NewBoard, black).
moveWorkerWhite(Board, 1, NewBoard) :- moveWorker(Board, 1, NewBoard, white).

% Adiciona trabalhadores ao tabuleiro.
addWorkers(InitialBoard, WorkersBoard, 'P', 'P') :-
      printBoard(InitialBoard),  % Imprime o tabuleiro inicial.
      write('\n------------------ PLAYER X -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(InitialBoard, black, Worker1Board, empty),
      printBoard(Worker1Board),  % Imprime o tabuleiro após o jogador X escolher uma célula.
      write('\n------------------ PLAYER O -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(Worker1Board, white, WorkersBoard, empty),
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
    askCoords(Board, PlayerColor, NewBoard, empty).

% Predicado para mover uma torre (Move a tower)
moveTower(Board, NewBoard, PlayerColor) :-
    write('Do you want to move a tower? [0(No)/1(Yes)]'),
    manageMoveWorkerBool(MoveWorkerBool),
    (
        MoveWorkerBool =:= 1 ->
            moveWorker(Board, 1, NewBoard, PlayerColor)  % Implemente a lógica de mover uma torre aqui
        ;
            write('You chose not to move a tower.\n'),
            NewBoard = Board  % Se o jogador optar por não mover uma torre, o tabuleiro permanece inalterado.
    ).

% Função principal para o turno do jogador
playerTurn(Board, NewBoard, PlayerColor, PlayerName) :-
    write('\n------------------ '), write(PlayerName), write(' -------------------\n\n'),
    write('1. Do you want to move a tower or add a new disk? [0(Add Disk)/1(Move Tower)]'),
    manageMoveWorkerBool(MoveWorkerBool),  % Obtém a escolha do jogador (mover torre ou adicionar peça).
    (
        MoveWorkerBool =:= 1 ->
            moveTower(Board, NewBoard, PlayerColor)  % O jogador escolhe mover uma torre.
        ;
            addNewDisk(Board, NewBoard, PlayerColor)  % O jogador escolhe adicionar uma nova peça.
    ),
    printBoard(NewBoard).  % Imprime o tabuleiro após a jogada.


% Loop principal do jogo.
gameLoop(Board, Player1, Player2) :-
      blackPlayerTurn(Board, NewBoard, Player1),
      (
            (checkGameState('black', NewBoard), write('\nThanks for playing!\n'));  % Verifica o estado do jogo para o jogador preto.
            (whitePlayerTurn(NewBoard, FinalBoard, Player2),
                  (
                        (checkGameState('white', FinalBoard), write('\nThanks for playing!\n'));  % Verifica o estado do jogo para o jogador branco.
                        (gameLoop(FinalBoard, Player1, Player2))  % Continua o loop do jogo.
                  )
            )
      ).














% Função para iniciar o jogo.
startGame(Player1, Player2) :-
      initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
      addWorkers(InitialBoard, WorkersBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
      gameLoop(WorkersBoard, Player1, Player2).  % Inicia o loop do jogo.


isValidMovePeao(State, X1, Y1, X2, Y2) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y1, Board, Row1),
    nth1(Y2, Board, Row2),
    nth1(X1, Row1, Player),  % Verifica se há uma peça do jogador na posição inicial
    (
        (X1 =:= X2, Y2 is Y1 + 1, isClearPath(X1, Y1, X2, Y2, Board)) ;  % Movimento para cima
        (X1 =:= X2, Y2 is Y1 - 1, isClearPath(X1, Y2, X1, Y1, Board))  % Movimento para baixo
    ).

% Regra para promover um peão a uma torre
promoteToTorre(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Player),  % Verifica se há uma peça do jogador na posição
    length(Row, NumPieces),  % Verifique quantas peças estão empilhadas
    NumPieces = 1,  % Se houver exatamente 1 peça na posição, promova o peão
    promotePiece(Row, NewRow),  % Promova o peão a uma torre
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Promove um peão empilhado a uma torre
promotePiece([Player], [torre(Player)]).

% Regras de movimento para a torre (2 discos)
isValidMoveTower(State, X1, Y1, X2, Y2) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y1, Board, Row1),
    nth1(Y2, Board, Row2),
    nth1(X1, Row1, Player),  % Verifica se há uma peça do jogador na posição inicial
    (
        (X1 =:= X2, Y1 =\= Y2 ; X1 =\= X2, Y1 =:= Y2),  % Movimento ortogonal
        isClearPath(X1, Y1, X2, Y2, Board)  % Verifica se o caminho está livre de peças
    ).

% Verifica se o caminho entre (X1, Y1) e (X2, Y2) está livre de peças
isClearPath(X, Y, X, Y, _).
isClearPath(X1, Y1, X2, Y2, Board) :-
    X1 =:= X2,  % Movimento na mesma coluna
    Y1 < Y2,  % Movimento para baixo
    Y is Y1 + 1,
    nth1(Y, Board, Row),
    nth1(X1, Row, empty),
    isClearPath(X1, Y, X2, Y2, Board).
isClearPath(X1, Y1, X2, Y2, Board) :-
    X1 =:= X2,  % Movimento na mesma coluna
    Y1 > Y2,  % Movimento para cima
    Y is Y1 - 1,
    nth1(Y, Board, Row),
    nth1(X1, Row, empty),
    isClearPath(X1, Y, X2, Y2, Board).
isClearPath(X1, Y1, X2, Y2, Board) :-
    Y1 =:= Y2,  % Movimento na mesma linha
    X1 < X2,  % Movimento para a direita
    X is X1 + 1,
    nth1(Y1, Board, Row),
    nth1(X, Row, empty),
    isClearPath(X, Y1, X2, Y2, Board).
isClearPath(X1, Y1, X2, Y2, Board) :-
    Y1 =:= Y2,  % Movimento na mesma linha
    X1 > X2,  % Movimento para a esquerda
    X is X1 - 1,
    nth1(Y1, Board, Row),
    nth1(X, Row, empty),
    isClearPath(X, Y1, X2, Y2, Board).


% Regras de movimento para o cavalo (3 discos)
isValidMoveCavalo(State, X1, Y1, X2, Y2) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y1, Board, Row1),
    nth1(Y2, Board, Row2),
    nth1(X1, Row1, Player),  % Verifica se há uma peça do jogador na posição inicial
    (
        (abs(X2 - X1) =:= 1, abs(Y2 - Y1) =:= 2) ;  % Movimento em forma de L
        (abs(X2 - X1) =:= 2, abs(Y2 - Y1) =:= 1)
    ),
    nth1(X2, Row2, empty).  % Verifica se a célula de destino está vazia


% Regras de movimento para o bispo (4 discos)
isValidMoveBispo(State, X1, Y1, X2, Y2) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y1, Board, Row1),
    nth1(Y2, Board, Row2),
    nth1(X1, Row1, Player),  % Verifica se há uma peça do jogador na posição inicial
    abs(X2 - X1) =:= abs(Y2 - Y1),  % Movimento diagonal
    isClearDiagonalPath(X1, Y1, X2, Y2, Board).  % Verifica se o caminho diagonal está livre de peças

% Verifica se o caminho diagonal entre (X1, Y1) e (X2, Y2) está livre de peças
isClearDiagonalPath(X, Y, X, Y, _).
isClearDiagonalPath(X1, Y1, X2, Y2, Board) :-
    X1 < X2, Y1 < Y2,  % Movimento para a diagonal inferior direita
    X is X1 + 1, Y is Y1 + 1,
    nth1(Y, Board, Row),
    nth1(X, Row, empty),
    isClearDiagonalPath(X, Y, X2, Y2, Board).
isClearDiagonalPath(X1, Y1, X2, Y2, Board) :-
    X1 < X2, Y1 > Y2,  % Movimento para a diagonal superior direita
    X is X1 + 1, Y is Y1 - 1,
    nth1(Y, Board, Row),
    nth1(X, Row, empty),
    isClearDiagonalPath(X, Y, X2, Y2, Board).
isClearDiagonalPath(X1, Y1, X2, Y2, Board) :-
    X1 > X2, Y1 < Y2,  % Movimento para a diagonal inferior esquerda
    X is X1 - 1, Y is Y1 + 1,
    nth1(Y, Board, Row),
    nth1(X, Row, empty),
    isClearDiagonalPath(X, Y, X2, Y2, Board).
isClearDiagonalPath(X1, Y1, X2, Y2, Board) :-
    X1 > X2, Y1 > Y2,  % Movimento para a diagonal superior esquerda
    X is X1 - 1, Y is Y1 - 1,
    nth1(Y, Board, Row),
    nth1(X, Row, empty),
    isClearDiagonalPath(X, Y, X2, Y2, Board).

% Regras de movimento para a rainha (5 discos)
isValidMoveRainha(State, X1, Y1, X2, Y2) :-
    isValidMoveTower(State, X1, Y1, X2, Y2) ;  % Pode mover como uma torre
    isValidMoveCavalo(State, X1, Y1, X2, Y2) ;  % Pode mover como um cavalo
    isValidMoveBispo(State, X1, Y1, X2, Y2).  % Pode mover como um bispo


% Empilhar uma peça no tabuleiro
stackPieces(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Stack),
    append([Player], Stack, NewStack),  % Empilhe a peça atual em cima das peças existentes
    replace(Row, X, NewStack, NewRow),  % Atualize a linha no tabuleiro
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Substitua o elemento na posição I de uma lista por um novo elemento
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 1,
    I1 is I - 1,
    replace(T, I1, X, R).


% Regra para promover um peão a uma torre
promoteToTorre(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Stack),
    length(Stack, NumPieces),  % Verifique quantas peças estão empilhadas
    NumPieces = 2,  % Se houver pelo menos 2 peças empilhadas
    promotePiece(Stack, NewStack),  % Promova o peão a uma torre
    replace(Row, X, NewStack, NewRow),  % Atualize a linha no tabuleiro
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Promova um peão empilhado a uma torre
promotePiece([peao(Player) | Rest], [torre(Player) | Rest]).

% Regra para transformar uma torre em um cavalo
transformToCavalo(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Stack),
    length(Stack, NumPieces),  % Verifique quantas peças estão empilhadas
    NumPieces = 3,  % Se houver pelo menos 3 peças empilhadas
    transformPiece(Stack, NewStack, cavalo(Player)),  % Transforme a torre em um cavalo
    replace(Row, X, NewStack, NewRow),  % Atualize a linha no tabuleiro
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Transforma uma torre empilhada em um cavalo
transformPiece([torre(Player) | Rest], [cavalo(Player) | Rest], cavalo(Player)).

% Regra para transformar um cavalo em um bispo
transformToBispo(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Stack),
    length(Stack, NumPieces),  % Verifique quantas peças estão empilhadas
    NumPieces = 4,  % Se houver pelo menos 4 peças empilhadas
    transformPiece(Stack, NewStack, bispo(Player)),  % Transforme o cavalo em um bispo
    replace(Row, X, NewStack, NewRow),  % Atualize a linha no tabuleiro
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Transforma um cavalo empilhado em um bispo
transformPiece([cavalo(Player) | Rest], [bispo(Player) | Rest], bispo(Player)).


% Regra para promover uma torre a uma rainha
promoteToRainha(State, X, Y, NewState) :-
    getCurrentPlayer(State, Player),
    getState(State, Board, _),
    nth1(Y, Board, Row),
    nth1(X, Row, Stack),
    length(Stack, NumPieces),  % Verifique quantas peças estão empilhadas
    NumPieces = 5,  % Se houver pelo menos 5 peças empilhadas
    promotePiece(Stack, NewStack),  % Promova a torre a uma rainha
    replace(Row, X, NewStack, NewRow),  % Atualize a linha no tabuleiro
    replace(Board, Y, NewRow, NewBoard),  % Atualize o tabuleiro
    setState(State, NewBoard, Player, NewState).

% Promova uma torre empilhada a uma rainha
promotePiece([torre(Player) | Rest], [rainha(Player) | Rest]).
