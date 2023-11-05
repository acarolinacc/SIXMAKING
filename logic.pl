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
    manageRow(Row),  % Obtém a linha escolhida pelo jogador.
    manageColumn(Column),  % Obtém a coluna escolhida pelo jogador.
    write('\n'),
    % Obtenha o índice da linha e da coluna
    ColumnIndex is Column - 1,
    RowIndex is Row - 1,

    % Acesse o elemento da matriz usando nth0/4
    nth0(RowIndex, Board, RowList),
    nth0(ColumnIndex, RowList, Piece),

    % Verifique se a torre não está vazia
    (is_valid_tower(Piece) ->
        % Verifique se a torre tem a cor certa
        (hasCorrectColor(Piece, PlayerColor) ->
            write('Choose the destination cell for the tower (must not be empty and must be of your color).\n'),
            manageRow(NewRow),       % Obtenha a linha escolhida pelo jogador
            manageColumn(NewColumn),  % Obtenha a coluna escolhida pelo jogador
            write('\n'),
            % Obtenha o índice da linha e da coluna da célula de destino
            ColumnInd is NewColumn - 1,
            RowInd is NewRow - 1,

            % Acesse o elemento da matriz usando nth0/4 para a célula de destino
            nth0(RowInd, Board, NewRowList),
            nth0(ColumnInd, NewRowList, SelectedTower),

            length(Piece, Size),
            % Valide o movimento
            (validate_move(RowIndex, ColumnIndex, RowInd, ColumnInd, Size) ->
                append(Piece, SelectedTower, NewTower),

                % Substitua a torre original na posição inicial pelo NewTower
                replaceInMatrix(Board, RowIndex, ColumnIndex, [], TempBoard),

                % Substitua a torre de destino pela lista vazia na matriz TempBoard
                replaceInMatrix(TempBoard, RowInd, ColumnInd, NewTower, NewBoard),

                % Verifique a condição de vitória
                (winning_condition(PlayerColor, NewTower) ->
                    true  % Vitória alcançada, o jogo termina
                ;
                    % Vitória não alcançada, continue o jogo
                    write('Valid move. Continue playing.\n')
                )
            ; 
                write('Invalid move for tower size. Please try again.'), nl,
                % Recursão para tentar novamente
                playerTurn(Board, NewBoard, PlayerColor, PlayerName)
            )
        ;
            write('Invalid tower color. Please try again.'), nl,
            % Recursão para tentar novamente
            playerTurn(Board, NewBoard, PlayerColor, PlayerName)
        )
    ;
        write('The chosen cell does not contain a valid tower. Please try again.'), nl,
        % Recursão para tentar novamente
        playerTurn(Board, NewBoard, PlayerColor, PlayerName)
    ).


% Condição de vitória
winning_condition(PlayerColor, NewTower) :-
    length(NewTower, Size),
    (Size =:= 6 ->
        write('Congratulations! Player '), write(PlayerColor), write(' wins the game!'), nl, nl
    ; true).

% Função principal para o turno do jogador
playerTurn(Board, NewBoard, PlayerColor, PlayerName) :-
    write('\n------------------ '), write(PlayerColor), write(' -------------------\n\n'),
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
