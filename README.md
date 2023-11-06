# PFL TP1: Six Making Game
**Group Designation**
- Ana Carolina da Costa Coutinho 	(up202108685)
- Tomás Pacheco Pires 	(up202008319)

Turma 5 - SixMaKING 3

Trabalho Prático 1
Programação Funcional e em Lógica

**Contribution**

- Ana Carolina da Costa Coutinho 	(up202108685) Contribution: 90%
- Tomás Pacheco Pires 	(up202008319) Contribution: 10%

## Installation and Execution

Para instalar o jogo Six MaKING, primeiro é necessário fazer o download dos ficheiros
presentes em PFL_TP1_T03_SixMaking_3.zip e descompactá-los. Dentro do diretório src
consulte o ficheiro sixmaking.pl através da linha de comandos ou pela própria UI do Sicstus
Prolog 4.8.0. O jogo está disponível em ambientes Windows e Linux.

O jogo inicia-se com o predicado play/0:
```prolog
? - play.
```


## Description of the Game

O jogo SixMaKING é uma experiência emocionante de estratégia que envolve um conjunto de componentes cuidadosamente projetados. Ele inclui um tabuleiro de jogo com dimensões de 5x5, proporcionando opções de jogo variadas. Os jogadores têm à disposição um total de 32 discos de madeira, dos quais 16 pertencem a cada jogador.

O objetivo central do jogo é a construção de uma torre denominada "Rei", que deve conter seis ou mais discos da mesma cor no topo. O tabuleiro inicia vazio, proporcionando um campo amplo para desenvolver estratégias e táticas.

Durante cada jogada, os participantes têm duas opções principais. A primeira alternativa é "Colocar um Novo Disco (Peão) no Tabuleiro", o que permite que um jogador posicione um único disco, conhecido como Peão, em qualquer espaço vazio do tabuleiro. Essa opção proporciona uma oportunidade para expandir a sua presença no jogo.

A segunda escolha é "Mover a Torre Inteira ou uma Parte da Torre". Nesse caso, os jogadores podem mover as suas torres no tabuleiro de acordo com os movimentos das peças de xadrez correspondentes. Essas torres são compostas por discos empilhados num número específico e só podem ser movidas sobre outra torre, não em espaços vazios.

As regras de movimento variam de acordo com o tipo de disco. Os Peões, por exemplo, podem mover-se em um único quadrado em todas as quatro direções, enquanto as Rainhas têm a capacidade de movimentar-se em qualquer direção e em qualquer número de quadrados.

**Regras de Movimento:**

- Um disco, designado como Peão, tem a capacidade de mover-se um único quadrado em todas as quatro direções, desde que esteja em cima de uma torre adjacente.

- As Torres, compostas por dois discos, podem deslocar-se em linha reta, cobrindo qualquer número de quadrados nas direções ortogonais.

- Os Cavalos, constituídos por três discos, movem-se em forma de "L", permitindo movimentos específicos sobre outras torres.

- Os Bispos, constituídos por quatro discos, possuem a habilidade de movimentar-se em qualquer direção diagonal, abrangendo diversos quadrados.

- As Rainhas, formadas por cinco discos, têm uma ampla capacidade de movimento, podendo deslocar-se por qualquer número de quadrados em todas as oito direções possíveis.


O jogo SixMaKING atinge o seu desfecho assim que a primeira torre com seis ou mais discos (o "Rei") é construída no tabuleiro. O jogador cuja cor está no topo da torre é declarado o vencedor do jogo.

As regras e funcionamento do jogo foram consultadas de dois sites:

[Original Rulebook](https://www.boardspace.net/sixmaking/english/Six-MaKING-rules-Eng-Ger-Fra-Ro-Hu.pdf)

[BoardSpace](https://www.boardspace.net/english/about_sixmaking.html)


## Game Logic

### **Internal Game State Representation**

A representação do estado interno do jogo SixMaking é de extrema importância para garantir que todas as funcionalidades do jogo sejam executadas com precisão e que as regras do jogo sejam aplicadas corretamente. Nesta seção, exploramos em detalhes como o estado do jogo é representado em Prolog, incluindo o tabuleiro do jogo, informações do jogador e condições de vitória.

#### **Tabuleiro de Jogo**

O tabuleiro de jogo é o núcleo da representação do estado interno do SixMaking. É representado como uma matriz 5x5, onde cada célula contém informações sobre a peça posicionada naquela célula. Para representar o tabuleiro, utilizamos uma lista de listas, onde cada elemento pode ser um dos seguintes:

[]: Indica que a célula está vazia, ou seja, não contém uma torre.

[white]: Indica que a célula contém uma torre do jogador branco.

[black]: Indica que a célula contém uma torre do jogador preto.

Vamos examinar um exemplo do tabuleiro de jogo nas diferentes fases:

**Tabuleiro Inicial:**

```prolog
initialBoard = [
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []]
]
```

**Tabuleiro Intermediário:**

```prolog
IntermediateBoard = [
    [[], [white, white], [], [black], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []],
    [[], [], [], [], []]
]
```

```prolog
FinalBoard = [
    [[], [white, white], [], [black], []],
    [[black,black], [], [], [], []],
    [[], [white, white,white, white, white, white], [], [black,black,black], []],
    [[], [], [], [], []],
    [[black,black], [], [white,white], [], [black]]
]
```

**Informações Adicionais:**

Jogador Atual: Uma variável que indica qual jogador tem a vez de fazer a próxima jogada. Essa variável pode conter white (branco) ou black (preto).

Peças Capturadas e Peças a Serem Jogadas: No jogo SixMaking, não há captura de peças ou peças a serem jogadas, uma vez que o jogo se baseia na movimentação das torres existentes no tabuleiro.

**Condições de Vitória:**

A representação do estado interno também inclui condições de vitória. O jogo SixMaking termina quando uma torre atinge a altura máxima de 6 peças. Essa condição é monitorada dentro das regras do jogo.

```prolog
winning_condition(PlayerColor, NewTower) :-
    length(NewTower, Size),
    (Size =:= 6 ->
        write('Congratulations! Player '), write(PlayerColor), write(' wins the game!'), nl, nl
    ; true).
```


### **Game State Visualization**

A visualização do estado de jogo envolve a configuração inicial do jogo e a apresentação do tabuleiro atual durante a partida. Os jogadores têm a oportunidade de definir vários parâmetros, como o modo de jogo e a dificuldade do jogador Bot. Vou detalhar cada parte da visualização do estado de jogo:

- Seleção do Modo de Jogo:

  Os jogadores são convidados a selecionar o modo de jogo, que pode ser um dos seguintes:
  
  Player vs. Player
  Player vs. Computer
  Computer vs. Computer
  
  A validação do input garante que apenas números de 1 a 3 sejam aceitos.

- Configuração do Bot:
  
  No caso de um jogador Bot, os jogadores podem escolher entre diferentes níveis de dificuldade, como "Lazy" ou "MasterMind".

- Instruções para os jogadores

A validação das opções do menu, pode ser realizada para garantir que as escolhas dos jogadores estejam dentro dos limites permitidos e que o jogo continue de maneira adequada com o predicado manageInput/1.

```prolog
manageInput(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askMenuOption,
    read(Input),
    manageInput(Input).
```

Após a inicialização do GameState, a fase de configurações é concluída. Em seguida, a ação de mostrar o tabuleiro de jogo é desencadeada pelo predicado startGame/2 da seguinte forma:

```prolog
startGame(Player1, Player2) :-
    initialBoard(InitialBoard),  % Obtém um tabuleiro inicial.
    addPieces(InitialBoard, PiecesBoard, Player1, Player2),  % Adiciona peças aos tabuleiros.
    gameLoop(PiecesBoard, Player1, Player2).  % Inicia o loop do jogo.
```


No jogo SixMaking, a função printBoard é responsável por imprimir o tabuleiro na tela. Para tornar a impressão mais generalizada e independente do número de peças em cada torre, é necessário criar regras adicionais para representar diferentes tipos de peças e seus estados no tabuleiro.

A função printBoard é encarregada de imprimir o tabuleiro, percorrendo cada linha e célula do tabuleiro de forma independente do número de peças em cada torre.

```prolog
printBoard(X) :-
    nl,
    write('   |    1    |    2    |    3    |    4    |    5    |\n'),
    write('---|---------|---------|---------|---------|---------|\n'),
    printMatrix(X, 1).
```

Para realizar essa tarefa, o código inclui as regras printLine e printMatrix. A primeira é responsável por imprimir as linhas do tabuleiro, enquanto a segunda é a principal regra para imprimir o tabuleiro completo.

```prolog
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
```
Além disso, a função piece/1 é responsável por imprimir a representação visual de uma combinação específica de peças, seja para o jogador preto (black) ou branco (white). As peças são representadas por letras (símbolos) no tabuleiro.

```prolog
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

% Print the winner
piece([black, black, black, black, black, black]) :- write('X Wins'). % Torre preta
piece([white, white, white, white, white, white]) :- write('O Wins'). % Torre branca
```

O tabuleiro é impresso linha por linha, usando as regras definidas, resultando em uma visualização clara e intuitiva do jogo.


**Move Validation and Execution**

O jogo funciona com base num ciclo cujo único caso de paragem é a vitória de um
dos jogadores:

```prolog
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
```

Em addPieces/4 o tabuleiro é configurado, e as peças dos jogadores são adicionadas. Este processo estabelece as condições iniciais para a partida e assegura que ambos os jogadores tenham suas peças no tabuleiro. 

O'Jogador X' escolhe uma célula onde deseja posicionar sua peça, representada por 'X.' As coordenadas da célula escolhida por 'Jogador X' são obtidas através da função askCoords/4.

Em seguida, 'Jogador O' escolhe uma célula para posicionar sua peça 'O' da mesma maneira.

```prolog
addPieces(InitialBoard, PiecesBoard, 'P', 'P') :-
      printBoard(InitialBoard),  % Imprime o tabuleiro inicial.
      write('\n------------------ PLAYER X -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(InitialBoard, [black], Worker1Board, empty),
      printBoard(Worker1Board),  % Imprime o tabuleiro após o jogador X escolher uma célula.
      write('\n------------------ PLAYER O -------------------\n\n'),
      write('1. Choose pawn cell.\n'),
      askCoords(Worker1Board, [white], PiecesBoard, empty),
      printBoard(PiecesBoard).  % Imprime o tabuleiro após o jogador O escolher uma célula.
```

A função moveTower/3 permite que o jogador mova uma torre no tabuleiro do jogo. O processo envolve a seleção de uma torre, a escolha de uma célula de destino e a validação do movimento.

```prolog
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

```

  **Considera-se um movimento válido quando:**
  
 -  As coordenadas escolhidas para colocar um novo disco estão dentro dos limites do tabuleiro escolhido, ou seja, a linha e a coluna selecionadas estão dentro dos limites aceitáveis.
  
  - Ao colocar um novo disco, a célula escolhida deve estar vazia, ou seja, não deve conter já um disco.
  
  - Ao mover uma torre, o destino deve ser uma célula que não esteja vazia, ou seja, deve conter outra torre. Portanto, o movimento não pode ser realizado para uma célula vazia.

A regra addNewDisk(Board, NewBoard, PlayerColor) permite que o jogador escolha uma célula vazia no tabuleiro para adicionar uma nova peça da sua cor no tabuleiro.

```prolog
addNewDisk(Board, NewBoard, PlayerColor) :-
    write('Choose a cell to add a new piece.\n'),
    askCoords(Board, [PlayerColor], NewBoard, empty)."

```

**List of Valid Moves**

A lista de jogadas válidas é obtida através da funçõo valid_moves/5, que é responsável por validar se um movimento específico de uma peça é válido, considerando sua posição inicial (Row, Column), a sua posição final (NewRow, NewColumn) e o tipo da peça (PieceType). Caso o movimento seja válido de acordo com as regras definidas em chess_moves, a validação é considerada bem-sucedida; caso contrário, uma mensagem de erro é exibida e o movimento é considerado inválido.

Essas regras são utilizadas para garantir que os movimentos das peças no xadrez estejam em conformidade com as regras do jogo e para fornecer feedback aos jogadores quando um movimento inválido é tentado.

```prolog
% Validate all moves
valid_moves(Row, Column, NewRow, NewColumn, PieceType) :-
    piece(Piece, PieceType),
    (chess_moves(Piece, Row, NewRow, Column, NewColumn) ->
        true
    ;
        format('Invalid move. ~w can only make the specified move. Try again.~n', [Piece]),
        false
    ).
```

Estas regras chess_moves definem as possibilidades de movimento para diferentes peças de xadrez, como o peão, a torre, o cavalo e o bispo.

```prolog
% Define regras de movimento de xadrez
chess_moves(pawn, Row, NewRow, Column, NewColumn) :-
    (Row =:= NewRow, abs(NewColumn - Column) =:= 1) ; (Column =:= NewColumn, abs(NewRow - Row) =:= 1).

chess_moves(rook, Row, NewRow, Column, NewColumn) :-
    (Row =:= NewRow, NewRow >= 0, NewRow < 5) ; (Column =:= NewColumn, NewColumn >= 0, NewColumn < 5).

chess_moves(knight, Row, NewRow, Column, NewColumn) :-
    (abs(NewColumn - Column) =:= 2, abs(NewRow - Row) =:= 1) ; (abs(NewColumn - Column) =:= 1, abs(NewRow - Row) =:= 2).

chess_moves(bishop, Row, NewRow, Column, NewColumn) :-
    abs(NewRow - Row) =:= abs(NewColumn - Column).
```

**End of Game**

A função game_over/2 encerra o jogo e exibe "Game Over" na tela quando uma condição de término é atendida, verificando o estado atual do jogo e se um jogador venceu com base na torre construída.

```prolog
game_over(Board, PlayerColor) :-
    checkGameStatus(Board, PlayerColor),
    winning_condition(PlayerColor, NewTower)
    nl,
    write('Game Over.'),
    halt.
```



**Game State Evaluation**

-------------------------------------------------------------------

**Computer Plays**

Para os bots decidirem qual movimento realizar, foram realizados dois métodos: lazy e mastermind.

O método random, como o nome indica, apenas escolhe de forma aleatória um movimento da lista de movimentos válidos.

```prolog
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
```

(Dentre outras funções.)


## Conclusions

O jogo SixMaking foi com sucesso implementado em Prolog, oferecendo modos de jogo Player vs Player e Player vs Bot e Bot vs Bot. As interações foram cuidadosamente desenvolvidas para garantir a validade do estado do jogo em todos os momentos. Uma das tarefas mais desafiadoras do projeto foi a implementação das estruturas de "stacks" e a lógica por trás dos movimentos das peças, exigindo um cuidadoso planejamento e execução para garantir um funcionamento preciso e eficiente. Esta parte do desenvolvimento implicou a criação de uma estrutura de dados sólida para representar as pilhas de peças e, ao mesmo tempo, elaborar um sistema de movimentos que respeitasse as regras do jogo SixMaking, tornando-se um ponto crucial na implementação bem-sucedida do projeto.


Concluindo, o projeto do jogo SixMaking foi bem-sucedido na implementação. No entanto, existem algumas limitações e possíveis melhorias a considerar.
Uma limitação é que o jogo não incluiu uma implementação do "Bot Mastermind," um nível de dificuldade adicional que poderia tornar o jogo mais desafiador. Além disso, atualmente, na minha implementação, a escolha das torres é restrita, ao passo que no jogo real, os jogadores têm a liberdade de escolher qual torre mover.

## Bibliography

As regras e funcionamento do jogo foram consultadas de dois sites:

[Original Rulebook](https://www.boardspace.net/sixmaking/english/Six-MaKING-rules-Eng-Ger-Fra-Ro-Hu.pdf)

[BoardSpace](https://www.boardspace.net/english/about_sixmaking.html)
