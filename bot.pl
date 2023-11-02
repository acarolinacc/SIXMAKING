verifyRandomMove(Board, Row, Column, Res):-
    ((isValidPosLines(Board, Row, Column, ResIsValidPosLines), ResIsValidPosLines =:= 1, !, 
    Res is 1);
    Res is 0).

/*Gera um linha e coluna aleatória, verifica se é uma jogada válida, ou seja, 
se é uma célula que está nas linhas de visão de algum Piece e se a célula está 
atualmente vazia. Caso seja válida, ele devolve essa linha e coluna, caso 
contrário este predicado chama-se a si própria para tentar gerar uma nova posição.*/
generatePlayerMove(Board, Row, Column):-
    random(0,11,RandomRow),
    random(0,11,RandomColumn),
    ((verifyRandomMove(Board, RandomRow, RandomColumn, ResVerifyRandomMove),ResVerifyRandomMove=:=1, 
    isEmptyCell(Board, RandomRow, RandomColumn, ResIsEmptyCell), ResIsEmptyCell=:=1,
        Row is RandomRow, Column is RandomColumn);
        generatePlayerMove(Board, Row, Column)).

/*Escolhe aleatoriamente se vai mover ou não o Piece. Se escolher mover o Piece,
 chama o predicado choosePiece para escolher aleatoriamente o Piece a mover e 
 seguidamente chama a função generatePieceMove para saber a posição para qual 
 mover.*/
movePiece(Board, PieceRow, PieceColumn, PieceNewRow, PieceNewColumn, Res) :-
    random(0,2, Bool),
    ((Bool =:= 1, 
    choosePiece(Board, PieceRow, PieceColumn), generatePieceMove(Board, PieceNewRow, PieceNewColumn), Res = 1);
    Res is 0).

%Escolhe aleatoriamente o Piece a mover. 
choosePiece(Board, PieceRow, PieceColumn) :-
    getPiecesPos(Board, PieceRow1, PieceColumn1, PieceRow2, PieceColumn2),
    random(1,3, Bool),
    ((Bool =:= 1, PieceRow is PieceRow1, PieceColumn is PieceColumn1);
    (Bool =:= 2, PieceRow is PieceRow2, PieceColumn is PieceColumn2)).


/*Gera um linha e coluna aleatória, verifica se é uma jogada válida, ou seja, 
se é uma célula que está nas linhas de visão de algum Piece e se a célula 
está atualmente vazia. Caso seja válida, ele devolve essa linha e coluna, 
caso contrário este predicado chama-se a si própria para tentar gerar uma 
nova posição.*/
generatePieceMove(Board,PieceNewRow, PieceNewColumn) :-
    random(0,11,RandomPieceNewRow),
    random(0,11,RandomPieceNewColumn),
    ((isEmptyCell(Board, RandomPieceNewRow, RandomPieceNewColumn, ResIsEmptyCell), ResIsEmptyCell=:=1,
        PieceNewRow is RandomPieceNewRow, PieceNewColumn is RandomPieceNewColumn);
        generatePieceMove(Board, PieceNewRow, PieceNewColumn)).


