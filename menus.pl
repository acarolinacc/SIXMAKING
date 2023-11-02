mainMenu :-
    printMainMenu,
    askMenuOption,
    read(Input),
    manageInput(Input).

printMainMenu :-
    nl,nl,
    write(' _______________________________________________________________________ '),nl,
    write('|                                                                       |'),nl,
    write('|         ___|  _)              \\  |         |    _)                    |'), nl,
    write('|       \\___ \\   | \\ \\  /      |\\/ |   _` |  |  /  |  __ \\    _` |      |'), nl,
    write('|             |  |  `  <       |   |  (   |    <   |  |   |  (   |      |'), nl,
    write('|       _____/  _|  _/\\_\\     _|  _| \\__,_| _|\\_\\ _| _|  _| \\__, |      |'), nl,
    write('|                                                           |___/       |'), nl, 
    write('|                                                                       |'),nl,
    write('|                                                                       |'),nl,
    write('|                          Ana Carolina Coutinho                        |'),nl,
    write('|                              *************                            |'),nl,
    write('|               -----------------------------------------               |'),nl,
    write('|                                                                       |'),nl,
    write('|                                                                       |'),nl,
    write('|                          1. Player vs Player                          |'),nl,
    write('|                                                                       |'),nl,
    write('|                          2. Player vs Computer                        |'),nl,
    write('|                                                                       |'),nl,
    write('|                          3. Computer vs Computer                      |'),nl,
    write('|                                                                       |'),nl,
    write('|                          4. Instructions                              |'),nl,  % Add this line
    write('|                                                                       |'),nl,  % Add this line
    write('|                          0. Exit                                      |'),nl,
    write('|                                                                       |'),nl,
    write('|                                                                       |'),nl,
    write(' _______________________________________________________________________ '),nl,nl,nl.

askMenuOption :-
    write('> Insert your option ').

% Updated manageInput to handle the "Instructions" option
manageInput(1) :-
    startGame('P','P'),
    mainMenu.

manageInput(2) :-
    startGame('P','C'),
    mainMenu.

manageInput(3) :-
    startGame('C','C'),
    mainMenu.

manageInput(4) :- % This is for "Instructions"
    printInstructions,  % Add this line to print instructions
    mainMenu.

manageInput(0) :-
    write('\nExiting...\n\n').

manageInput(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askMenuOption,
    read(Input),
    manageInput(Input).

% Updated printInstructions predicate to wait for Enter and return to the main menu
printInstructions :-
    nl,nl,
    write(' _______________________________________________________________________ '),nl,
    write('|                                                                       |'),nl,
    write('|                            INSTRUCTIONS                               |'),nl,
    write('|                                                                       |'),nl,
    write('| - Welcome to the game!                                                |'),nl,
    write('| - Here are the instructions for playing:                              |'),nl,
    write('|   1. Choose the game mode:                                            |'),nl,
    write('|      - Player vs Player: Two players take turns.                      |'),nl,
    write('|      - Player vs Computer: Play against the computer.                 |'),nl,
    write('|      - Computer vs Computer: Watch the computer play itself.          |'),nl,
    write('|   2. During the game, you can either:                                 |'),nl,
    write('|      - Move a tower: Select a tower to move to a different location.|'),nl,
    write('|      - Add a new piece: Place a new piece on the board.               |'),nl,
    write('|   3. Try to win the game or enjoy watching the computer play!         |'),nl,
    write('| - Have fun and enjoy the game!                                        |'),nl,
    write('|                                                                       |'),nl,
    write(' _______________________________________________________________________ '),nl,
    get_char(_), % Wait for a single character (Enter key)
    mainMenu.  % Return to the main menu


