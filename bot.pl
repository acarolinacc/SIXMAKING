% Inclui a biblioteca de tempo para possíveis atrasos.
:- use_module(library(time)).

% Inicializa o jogo com um jogador humano (Player1) e um jogador controlado por computador (Player2).
startGameBot(Player1, Player2) :-
    initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
    addPiecesPC(InitialBoard, PiecesBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
    gameLoopBot(PiecesBoard, Player1, Player2).  % Inicia o loop do jogo.

% Inicializa o jogo com dois jogadores controlados por computador (Player1 e Player2).
startGameBotBot(Player1, Player2) :-
    initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
    addPiecesCC(InitialBoard, PiecesBoard, Player1, Player2),  % Adiciona trabalhadores aos tabuleiros.
    gameLoopBotBot(PiecesBoard, Player1, Player2).  % Inicia o loop do jogo.

% Função para adicionar peças de jogadores em sequência (Player1 e Player2) alternadamente.
addPiecesPC(InitialBoard, PiecesBoard, 'P', 'C') :-
    printBoard(InitialBoard),  % Exibe o tabuleiro.
    write('\n------------------ PLAYER X -------------------\n\n'),
    write('1. Choose a cell to add a new piece.\n'),
    askCoords(InitialBoard, [black], Worker1Board, empty),  % Solicita ao jogador humano para escolher uma célula para adicionar uma peça.
    printBoard(Worker1Board),  % Exibe o tabuleiro após a escolha do jogador humano.
    write('\n----------------- COMPUTER O ------------------\n\n'),
    askCoordsRandom(Worker1Board, [white], PiecesBoard, empty),  % O computador escolhe aleatoriamente uma célula para adicionar uma peça.
    printBoard(PiecesBoard).  % Exibe o tabuleiro após a escolha do computador.

% Função para adicionar peças de jogadores controlados por computador (Player1 e Player2) alternadamente.
addPiecesCC(InitialBoard, PiecesBoard, 'C', 'C') :-
    printBoard(InitialBoard),  % Exibe o tabuleiro.
    write('\n----------------- COMPUTER X ------------------\n\n'),
    askCoordsRandom(InitialBoard, [black], Worker1Board, empty),  % O computador escolhe aleatoriamente uma célula para adicionar uma peça.
    printBoard(Worker1Board),  % Exibe o tabuleiro após a escolha do computador.
    write('\n----------------- COMPUTER O ------------------\n\n'),
    askCoordsRandom(Worker1Board, [white], PiecesBoard, empty),  % O computador escolhe aleatoriamente uma célula para adicionar uma peça.
    printBoard(PiecesBoard).  % Exibe o tabuleiro após a escolha do computador.

% Função que escolhe aleatoriamente uma célula para adicionar uma peça.
askCoordsRandom(Board, Player, NewBoard, Expected) :-
    repeat,
    random(1, 6, NewRow),  % Gera um número aleatório de 1 a 5 para a linha.
    random(1, 6, NewColumn),  % Gera um número aleatório de 1 a 5 para a coluna.
    write('\n'),
    ColumnIndex is NewColumn - 1,  % Converte o número da coluna para o índice da matriz.
    RowIndex is NewRow - 1,  % Converte o número da linha para o índice da matriz.

    % Verifica se o movimento é válido com checkMove
    (checkMove(Board, Player, NewBoard, Expected, ColumnIndex, RowIndex) ->
        !  % Movimento válido, saia do loop
    ;
        write('Invalid move. Please try again.'), nl,  % Movimento inválido, informa e chama playerTurnRandom
        playerTurnRandom(Board, NewBoard, Player, PlayerName)
    ).

% Função que permite ao jogador controlado por computador escolher sua jogada.
playerTurnRandom(Board, NewBoard, PlayerColor, PlayerName) :-
    write('\n------------------ '), write(PlayerColor), write(' -------------------\n\n'),
    write('1. Do you want to move a tower or add a new disk? [0(Add Disk)/1(Move Tower)/2(Move Part of Tower)]\n'),
    random(0, 1, MoveWorkerBool),
    (
        MoveWorkerBool =:= 0 ->
            addNewDiskRandom(Board, NewBoard, PlayerColor)  % O jogador escolhe adicionar uma nova peça.
        ; MoveWorkerBool =:= 1 ->
            moveTowerRandom(Board, NewBoard, PlayerColor)  % O jogador escolhe mover uma torre.
    ),
    printBoard(NewBoard). % Exibe o tabuleiro após a jogada.

% Função que permite ao jogador controlado por computador escolher adicionar uma nova peça.
addNewDiskRandom(Board, NewBoard, PlayerColor) :-
    write('Choose a cell to add a new piece.\n'),
    askCoordsRandom(Board, [PlayerColor], NewBoard, empty),  % O jogador controlado por computador escolhe aleatoriamente uma célula para adicionar uma peça.
    printBoard(PiecesBoard).  % Exibe o tabuleiro após a jogada.

% Função que permite ao jogador controlado por computador escolher mover uma torre.
moveTowerRandom(Board, NewBoard, PlayerColor) :-
    write('Choose any tower to move.\n'),
    random(1, 6, Row),
    random(1, 6, Column),
    validateColumn(Column, NewColumn),
    validateRow(Row, NewRow),
    write('\n'),

    ColumnIndex is NewColumn - 1,  % Obtenha o índice da coluna.
    RowIndex is NewRow - 1,  % Obtenha o índice da linha.

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
            ColumnInd is NewColumn2 - 1,  % Obtenha o índice da coluna de destino.
            RowInd is NewRow2 - 1,  % Obtenha o índice da linha de destino.

            % Acesse o elemento da matriz usando nth0/4 para a célula de destino
            nth0(RowInd, Board, NewRowList),
            nth0(ColumnInd, NewRowList, SelectedTower),

            length(Piece, Size),

            % Valide o movimento
            (valid_moves(RowIndex, ColumnIndex, RowInd, ColumnInd, Size) ->
                append(Piece, SelectedTower, NewTower),

                % Substitua a torre original na posição inicial pelo NewTower
                replaceInMatrix(Board, RowIndex, ColumnIndex, [], TempBoard),

                % Substitua a torre de destino pela lista vazia na matriz TempBoard
                replaceInMatrix(TempBoard, RowInd, ColumnInd, NewTower, NewBoard),

                % Verifique a condição de vitória
                (winning_condition(PlayerColor, NewTower) ->
                    true  % Vitória alcançada, o jogo termina
                ;
                    write('Valid move. Continue playing.\n')  % Vitória não alcançada, continue o jogo
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

% Função que controla a jogada do jogador branco (computador).
whitePlayerTurnC(Board, NewBoard, 'C') :-
    playerTurnRandom(Board, NewBoard, 'white', 'COMPUTER O').

% Função que controla a jogada do jogador preto (computador).
blackPlayerTurnC(Board, NewBoard, 'C') :-
    playerTurnRandom(Board, NewBoard, 'black', 'COMPUTER X').

% Função do loop principal do jogo para um jogador humano (Player1) e um jogador controlado por computador (Player2).
gameLoopBot(Board, 'P', 'C') :-
    blackPlayerTurn(Board, NewBoard, Player1),  % Vez do jogador humano.
    (
        (whitePlayerTurnC(Board, NewBoard, 'C'),  % Vez do jogador controlado por computador.
            (
                (gameLoop(FinalBoard, 'P', 'C'))  % Continua o loop do jogo.
            )
        )
    ).

% Função do loop principal do jogo para dois jogadores controlados por computador (Player1 e Player2).
gameLoopBotBot(Board, 'C', 'C') :-
    blackPlayerTurnC(Board, NewBoard, 'C'),  % Vez do jogador controlado por computador.
    (
        (whitePlayerTurnC(Board, NewBoard, 'C'),  % Vez do jogador controlado por computador.
            (
                (gameLoop(FinalBoard, 'P', 'C'))  % Continua o loop do jogo.
            )
        )
    ).
