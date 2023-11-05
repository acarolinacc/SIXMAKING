startGameBot(Player1, Player2) :-
      initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
      addPiecesPC(InitialBoard, PiecesBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
      gameLoopBot(PiecesBoard, Player1, Player2).  % Inicia o loop do jogo.

startGameBotBot(Player1, Player2) :-
      initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
      addPiecesCC(InitialBoard, PiecesBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
      gameLoopBotBot(PiecesBoard, Player1, Player2).  % Inicia o loop do jogo.

addPiecesPC(InitialBoard, PiecesBoard, 'P', 'C') :-
      printBoard(InitialBoard),
      write('\n------------------ PLAYER X -------------------\n\n'),
      write('1. Choose a cell to add a new piece.\n'),
      askCoords(InitialBoard, [black], Worker1Board, empty),
      printBoard(Worker1Board),
      write('\n----------------- COMPUTER O ------------------\n\n'),
      askCoordsRandom(Worker1Board, [white], PiecesBoard, empty),
      printBoard(PiecesBoard).

addPiecesCC(InitialBoard, PiecesBoard, 'C', 'C') :-
      printBoard(InitialBoard),
      write('\n----------------- COMPUTER X ------------------\n\n'),
      askCoordsRandom(InitialBoard, [black], Worker1Board, empty),
      printBoard(Worker1Board),
      write('\n----------------- COMPUTER O ------------------\n\n'),
      askCoordsRandom(Worker1Board, [white], PiecesBoard, empty),
      printBoard(PiecesBoard).

askCoordsRandom(Board, Player, NewBoard, Expected) :-
    repeat,
    random(1, 6, NewRow),     % Gera um número aleatório de 1 a 5 para a linha.
    random(1, 6, NewColumn),  % Gera um número aleatório de 1 a 5 para a coluna.
    write('\n'),
    ColumnIndex is NewColumn - 1,  % Converte o número da coluna para o índice da matriz.
    RowIndex is NewRow - 1,        % Converte o número da linha para o índice da matriz,
    
    % Verifica se o movimento é válido com checkMove
    (checkMove(Board, Player, NewBoard, Expected, ColumnIndex, RowIndex) ->
        % Movimento válido, saia do loop
        !
    ;
        % Movimento inválido, informe e chame playerTurnRandom
        write('Invalid move. Please try again.'), nl,
        playerTurnRandom(Board, NewBoard, Player, PlayerName)
    ).


playerTurnRandom(Board, NewBoard, PlayerColor, PlayerName) :-
    write('\n------------------ '), write(PlayerColor), write(' -------------------\n\n'),
    write('1. Do you want to move a tower or add a new disk? [0(Add Disk)/1(Move Tower)/2(Move Part of Tower)]\n'),
    random(0, 1, MoveWorkerBool), 
    (
        MoveWorkerBool =:= 0 ->
            addNewDiskRandom(Board, NewBoard, PlayerColor)  % O jogador escolhe adicionar uma nova peça.
        ; MoveWorkerBool =:= 1 ->
            moveTowerRandom(Board, NewBoard, PlayerColor)   % O jogador escolhe mover uma torre.
    ),
    printBoard(NewBoard).  % Imprime o tabuleiro após a jogada.


addNewDiskRandom(Board, NewBoard, PlayerColor) :-
    write('Choose a cell to add a new piece.\n'),
    askCoordsRandom(Board, [PlayerColor], NewBoard, empty),
    printBoard(PiecesBoard).


moveTowerRandom(Board, NewBoard, PlayerColor) :-
    write('Choose any tower to move.\n'),
    random(1, 6, Row),
    random(1, 6, Column),
    validateColumn(Column, NewColumn),
    validateRow(Row, NewRow),
    write('\n'),
    
    % Obtenha o índice da linha e da coluna
    ColumnIndex is NewColumn - 1,
    RowIndex is NewRow - 1,
    
    % Acesse o elemento da matriz usando nth0/4
    nth0(RowIndex, Board, RowList),
    nth0(ColumnIndex, RowList, Piece),
    
    % Verifique se a torre não está vazia
    (is_valid_tower(Piece) ->
        % Verifique se a torre tem a cor certa
        (hasCorrectColor(Piece, PlayerColor) ->
            write('Choose the destination cell for the tower (must not be empty and must be of your color).\n'),
            random(1, 6, Row2),
            random(1, 6, Column2),
            validateColumn(Column2, NewColumn2),
            validateRow(Row2, NewRow2),
            write('\n'),
            % Obtenha o índice da linha e da coluna da célula de destino
            ColumnInd is NewColumn2 - 1,
            RowInd is NewRow2 - 1,
    
            % Acesse o elemento da matriz usando nth0/4 para a célula de destino
            nth0(RowInd, Board, NewRowList),
            nth0(ColumnInd, NewRowList, SelectedTower),
    
            length(Piece, Size),
            % Valide o movimento
            (check_move(RowIndex, ColumnIndex, RowInd, ColumnInd, Size) ->
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
                playerTurnRandom(Board, NewBoard, PlayerColor, PlayerName)
            )
        ;
            write('Invalid tower color. Please try again.'), nl,
            % Recursão para tentar novamente
            playerTurnRandom(Board, NewBoard, PlayerColor, PlayerName)
        )
    ;
        write('The chosen cell does not contain a valid tower. Please try again.'), nl,
        % Recursão para tentar novamente
        playerTurnRandom(Board, NewBoard, PlayerColor, PlayerName)
    ).
      
whitePlayerTurnC(Board, NewBoard, 'C') :-
    playerTurnRandom(Board, NewBoard, 'white', 'COMPUTER O').

blackPlayerTurnC(Board, NewBoard, 'C') :-
    playerTurnRandom(Board, NewBoard, 'black', 'COMPUTER X').

gameLoopBot(Board, 'P', 'C') :-
      blackPlayerTurn(Board, NewBoard, Player1),
      (
            (whitePlayerTurnC(Board, NewBoard, 'C'),
                  (
                        (gameLoop(FinalBoard, 'P', 'C'))  % Continua o loop do jogo.
                  )
            )
      ).

gameLoopBotBot(Board, 'C', 'C') :-
      blackPlayerTurnC(Board, NewBoard, 'C'),
      (
            (whitePlayerTurnC(Board, NewBoard, 'C'),
                  (
                        (gameLoop(FinalBoard, 'P', 'C'))  % Continua o loop do jogo.
                  )
            )
      ).

