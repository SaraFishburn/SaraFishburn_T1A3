# Sara Fishburn T1A3 - Terminal Application: Tetris

## Links

### GitHub repository:

https://github.com/SaraFishburn/SaraFishburn_T1A3

### Trello board

https://trello.com/b/0rRkjcBZ

### Control flow diagram

https://lucid.app/documents/view/7dde32da-d5ab-430a-9f96-cac6aaa7cd59

## Software Development Plan

### Application description and function

The terminal application to be created will be a Tetris game. Tetris is a game that allows users to interact with falling blocks so that they may be orientated and positioned to align with gaps created by previous blocks when they land. If the falling block lands in a gap and subsequently completes a solid line or lines of blocks from one side of the game board to the other, the solid line or lines will be removed from the game board and any blocks above will fall to fill their place.

The game ends when the game board is filled and there is no more room for incoming blocks to fall.

### Problems solved

There are two main problems that may be addressed by Tetris.

1. **Boredom**

   With the current state of the world, a lot of people are stuck indoors day in and day out. Tetris is one of many activities that may be offered to provide distraction and occupy time.

2. **Mitigating the effects of trauma**

   In October of 2017, the European Journal of Psychotraumatology published an article regarding a study conducted on individuals who had recently been exposed to trauma. The study concluded that playing Tetris soon after experiencing a traumatic event reduced the occurrence of intrusive trauma memories which are a key symptom of posttraumatic stress disorder (PTSD). While the implementation of a Tetris game may not completely solve the problem of PTSD, it may certainly help reduce the symptoms of the disorder which are problematic in their own right.

### Reason for development

There are several reasons to develop a tetris clone.
In addition to the long held admiration of this game and the pure enjoyment of solving the complex problems presented in the development of a terminal Tetris app, this app is also developed as a mechanism to alleviate the boredom of others and assist those in need of distraction.

### Target audience

The target audience of this app may be described as the individuals who are subject to the problems identified above.

The app covers a large demographic, namely those who enjoy puzzle games, are currently isolating, or who are simply bored. Furthermore, recent sufferers of trauma may benefit from this game.

### Use

As explained above, the main mechanic of Tetris is the manipulation of game pieces (officially named 'Tetrominos') that will be controlled by the user. When opened, the application will initially display a welcome page that will prompt the user to press enter to start.

Once the game starts, the game blocks will begin to fall and users can rotate and move pieces left and right as they fall so that they stack as desired.

Another feature of the game that may be controlled by the user is the leaderboard entry. If a user scores enough points to place on the top 10 leaderboard, they will be prompted to enter a maximum of 3 characters to represent themselves (such as their initials) which will be associated with their score when displayed on the leaderboard.

## Features

#### Leaderboard

At the end of a game, if a player achieves a high enough score to place in the top 10 high scores, they will be prompted to enter their initials. A list of the top 10 scores will display beside the main game board with the corresponding initials of players that achieved those scores. If a player completely closes the game and re-starts, these scores will be saved as they are stored in a hash in a json file.

#### Stats

The stats feature encompasses the implementation of 3 separate windows in the game that contain statistics on the player's current game.Namely the score, level, and number of lines cleared. These windows allow a player to observe their improvement throughout a game. The Score and Level figures are calculated given the number of lines a player has cleared. The equations to do so are sourced from the tetris wiki.

#### Hard Drop

If a player is satisfied with the current position and orientation of the falling tetromino, they may decide to activate the 'hard drop' feature. This will instantly drop the tetromino down as far as it can go on the game board so that the player can move on to the next piece in the game.

#### Position Projection

While a tetromino is falling, a duplicate of itself with a transparent version of its own color will display on the game board in the position the piece would land in the case of a hard drop. This 'ghost piece' provides the player with a reference of where the piece will land and therefore helps the player decide the horizontal position and orientation of the game piece.

#### Next Piece Display

While the current tetromino is falling, an image of the next piece is displayed in a window to the right of the game board.
This allows the player to know ahead of time what the next tetromino will be and therefore plan the positioning and orientation of the current falling piece accordingly.

## User Interaction and Experience

### Controls

When the player opens the game, a screen with several windows will appear along with a welcome message. One of these windows will display a list of actions and their corresponding keyboard controls to inform the user how to play the game.

### How each feature is used

The entire tetris app will rely on user input. Pieces will be controlled via the arrow keys where the up arrow will be for rotation, left and right for sideways movements, and the down arrow for hard drops.

At the end of the game, if the user has achieved a high enough score, a message will display on screen prompting the user to enter their initials via the keyboard so that their initials may display next to their score on the high score board.

In addition to the manipulation of game pieces and the entering of user initials, players will also be prompted to press the enter key at different points either to continue after game over or start the game.

### Error Handling

While a game is in progress, the only keys needed to play are the arrow keys. Therefore if a user presses any other key on the keyboard, nothing will happen.

Similarly, when players are inputting their initials, if they do not press and alphanumeric key, nothing will happen as well as when they try to enter more than 3 characters.

If a player starts a game and the code is unable to locate the highscores json file, the file will be created and populated with an empty array of hashes with placeholder values.

If the operating system that the application is being run on is not windows, the application will attempt to play audio via the other os commands.

If the program runs and fails for any reason, the curses screen closes so that errors can be viewed in the terminal.

## Implementation Plan

The implementation of this app will be separated into the different windows within the game.

The first thing to do will be to create eight windows with borders. The first will be the main window which will border all subsequent windows.

Within the borders of the main window the following windows should be made and labelled. (5 mins)

- Tetris (game board window)
- Lines (lines cleared)
- Level
- Score
- Next (next piece)
- Controls
- Highscores (leaderboard)

All the above windows should be created within a helper file labeled 'curses_setup'. This file should also initialize the curses color pairs

In terms of feature implementation, the level, score, and lines should be seen as one feature that may be described as the 'stats' feature as they are all interconnected.

### MVP

Features should be implemented in the following priority order.

#### Tetris window (game board)

- Game Pieces (3 hrs)

  - Create a parent class to contain common logic across all game pieces

  - Create a class for each game piece

  - In the game piece classes, provide an array that represents the shape of the piece.

  - In the game piece classes, provide a y position for each piece so that it generates at the right location at the top of the game board (to be created) given any rows of 0's the piece array may have for centering purposes.

  The following methods should be added to the parent game piece class:

  - Clockwise rotation - handles clockwise rotation of a game piece via manipulating the game piece array.

  - Anticlockwise rotation - handles anticlockwise rotation of a game piece via manipulating the game piece array.

  - Test rotation in both directions by writing test cases to check resulting arrays against expected arrays.

  - Left horizontal movement - handles the left movement of a game piece by changing its x coordinate in relation to a game board array (to be created)

  - Right horizontal movement - handles the right movement of a game piece by changing its x coordinate in relation to a game board array (to be created)


  - Downward movement - handles the downward movement of a game piece by changing its y coordinate in relation to a game board array (to be created). Takes speed (to be calculated) as an argument.


  - Collision logic - check if a position a game piece is moved into is out of the bounds of a game board array (to be created) or collides with another game piece that has previously landed.


  - Add to board - Logic to add the piece to a game board array (to be created) by adding a piece to an array upon the piece landing, the position of the landed piece may be saved, displayed, and used for collision logic.


- Game Board (3 hrs)

  - Create a game board class that will handle the logic for generating, moving and saving the position of game pieces.

  The following methods should be added to the game board class:

  - Next piece - randomly selects a game piece and assigns it as the next piece while making the previous 'next piece' the current piece.

  - Create piece - takes the current piece assigned by the next piece method and creates a new instance of the piece which will be stored in a variable in_play.

  - User input - listens to user input and calls movement and rotation functions within the game piece class depending on the key pressed by the player.

  - Remove lines - detects solid rows on the game board and removes them. Replaces them with rows of 0's at the top of the board array.

  - Calculate speed - calculates the speed at which pieces will move down the board. Determined by an equation that takes level (to be calculated) as a variable. Speed equation sourced from the tetris wiki.

#### Lines / Level / Score (Stats Feature) (1 hr)

- Determine the number of lines cleared at once by identifying how many rows are deleted in the remove lines method.

The following methods should be implemented. They will be located in the game board class due to their dependence on many of the class variables:

- Calculate level - level is calculated given the lines cleared which may be determined within the remove lines function in game board. For every 10 lines cleared, the level is increased by 1.

- Calculate score - a score equation is applied given the number of rows cleared at once and the player's current level. The calculated score is then added to a running total score variable.

  - Determine the number of rows cleared at once using a variable gained from the remove lines function in game board

  - Determine the current player level gained from the calculate level function in game board

  - calculate the score in an equation given these variables. Original nintendo tetris scoring system equations sourced from the Tetris wiki page.

- Stats - stats method takes a figure and a window and displays the given figure centered in the given window. This method is used to draw the lines cleared, score, and level figures to their respective windows.

- level test - checks that given the number of lines cleared, the level method produces the correct result.

- Score test - checks that given a players level and the number of lines cleared at once, the correct figure is produced.

#### Next window (30 mins)

The 'next piece' feature should display the piece that has been determined to be generated next in the next window. This function is handled in the game board class due to its dependence on many of the class variables.

- Ensure the window is empty for the next piece to be drawn

- Create an instance of the next piece

- Place the piece in the center of the next window by setting the piece's position

- call a draw function (stored in the draw module) that displays the next piece to the next window.

- refresh the window to update changes

#### Controls window (30 mins)

The controls window will display to the user the actions required to play the game and their corresponding keyboard controls. The controls window display will be handled within a helper file labeled 'curses_setup'

- create a hash containing the names of the actions as the keys and the keyboard control as the value.

- loop through each action/control pair in the hash and display them in the controls window

- refresh the controls window to update contents

### Non-MVP

#### Hard drop (5 mins)

The hard drop feature allows a player to press the down arrow and drop a tetromino down as far as it can go on the game board before colliding with another piece. Hard drop function will be located within game piece.

Hard drop is almost completely made within the implementation of the above methods but the steps will be re-iterated below:

- Create a valid position method that contains collision logic

- Create a move down function that moves a piece down at a given speed

- Create a hard drop function that calls the move down function but provides a speed value of 1.

- In game board's user input method, include an option for a down arrow key press.

- Call the hard drop function on the piece in play when a player presses the down arrow.

#### Wall kick (1 hr)

The wall kick feature allows a user to rotate a piece when that piece is in a position that would not usually allow for rotation. It achieves this by moving the final position of the piece vertically and horizontally by given amounts and checking if the new position is valid.

- Add wall kick data that applies to the majority of game pieces into the game piece class. (data sourced from tetris wiki)

- In the i piece class, override this data with the i piece's specific data. (data sourced from tetris wiki)

- In the o piece class, set wall kick data to none as an o piece should not wall kick.

- Wall kick method - loop through piece wall kick data and check given altered piece positions for if they are valid.

- Include a wall kick method check in the existing rotate functions

#### Position projection (30 mins)

Position projection will display a transparent 'ghost' version of the current falling piece in the position the current piece is projected to land in.

- Create a copy of the tetromino in play

- change the numbers in the tetromino hash that represent the game piece shape so that the appropriate color with a transparent value will apply.

- apply hard drop to this piece so that it is positioned as far down the board as possible.

- in the create piece method, call the calculate piece function so the ghost piece is also generated

- in user input, after a player has moved the game piece, recalculate the ghost piece by calling the calculate ghost piece method

#### Welcome and game over messages (1 hr)

Welcome and game over screens allow the player to control when they would like to start the game as well as what initials will represent their high score. The messages also provide information about what place in the top 10 a user ranked or simply states 'game over' if the user didn't place. 

The methods that handle these messages will be in a helper file named 'welcome and over'.

##### Game over

- Game over
  - If a user places, messages array will be just game over
  - If a user doesn't place, the array will also include 'press enter to continue'
  - Draw the message to the tetris window

- New high score - function calls game over to inherit position of the curser and display 'game over' message to screen. The method then displays a further message that includes player's final score, the rank they placed in the top 10, and the prompt to enter their initials and press enter.

- Display logo - declares an array containing the characters to make an ascii art logo depicting the letter 't' and displays the 'logo' to the tetris window.

- Welcome screen - calls display logo first followed by a prompt for the user to press enter to start. The method then calls the listen for enter method.

- Draw messages - method to take an array of strings and displays them to a window given line spacing and a starting y position.


#### Highscores window (4 hrs)
*NOTE this feature will take longer due to learning how to use json

The highscores window will display the top 10 scores and their corresponding user initials.

##### Main logic

The logic to check if a player's score places on the highscores board and the logic to update the highscores json file will be handled within a helper file named highscores.

- create an array of hashes stored in a json file. Each hash should contain a name and score key/value pair.

The following methods should be implemented:

- Places? - check if a player's score places in the top 10.

- Find position - find the position within the top 10 that the player's score ranks. This determines the position at which a new hash should be added to the highscores array.

- Insert score - insert a new hash at the found position within the array with the user's initials as the name value and their score as the score value.

##### User input initials

The user initials function will be found in a helper file called 'welcome and over' which contains logic for the welcome and game over screens. This is due to the fact that the user is prompted for their initials in the game over screen when they place in the highscores board.

The methods in 'welcome and over' relevant to the highscores board are:

Listen for enter - listens for user to press enter and will do nothing until user does. This method is useful in other areas of the code as well.

User initials - this method will listen for user input, display the input to the screen if alphanumeric and otherwise do nothing. It will at the same time store the user input as a string. Once the user has entered 3 characters, it will call a 'listen for enter' function. once the user has pressed enter, this function will call the insert score function passing the user initial string as a parameter.

##### Display highscores

The display highscores method will be located in the 'curses setup' helper file.

Display highscores - takes the highscores hash generated from the json file and displays the contents in a list numbered 1 to 10 within the highscores window.

## Help Documentation

### To install the application

Please follow the below steps to successfully install the tetris application:

1. Download the folder SaraFishburn_T1A3 and unzip

2. In order for the game to have the correct proportions, the terminal must use a square font. Download the square font here: http://strlen.com/files/square.ttf

3. In the terminal, go to settings and change the terminal font to be the downloaded square font.

### To play the game

4. In the command line, change directories into src

```
cd (path to src file)
for example:
cd Documents/games/tetris/src
```

5. Once in the source file directory, in the command line, run the 'run_tetris.sh' script file.

```
$ ./run_tetris.sh
```

### Dependencies

- **Curses gem**

  GitHub link: https://github.com/ruby/curses

  A gem to manipulate the terminal curser in order to write things to the terminal window at any position.

- **Ordinal gem**

  GitHub link: https://github.com/davidlumley/ordinal/

  Converts numbers to ordinal numbers e.g. 1 = 1st, 2 = 2nd etc

- **Tty-file gem**

  GitHub link: https://github.com/piotrmurach/tty-file

  Gem to manipulate files in directories, used in this application to create a json file.

- **OS gem**

  GitHub link: https://github.com/rdp/os/

  Gem to detect what operating system a user is running. Used in this app to configure the playing of music.

- **Win32/sound gem**

  GitHub link: https://github.com/chef-boneyard/win32-sound

  Gem to play sound on Microsoft Windows operating systems.




### System/Hardware requirements

This tetris terminal application DOES NOT work on M1 Apple Macbooks without heavy modification due to gem incompatibility.

## Tests

There are two tests for this application, one for the game pieces class, and one for the game board class.

### Game piece class tests

To run game the game piece test file, while in the src directory in the terminal, run the following:
```
$ ruby test/game_piece_test.rb
```
There are three test cases in the game piece test:

- test_new_game_piece_instance

    Tests that when created, game piece exists and is not nil.

- test_rotate_r

    Tests the rotate_r method re-arranges the piece array as expected.

- test_rotate_l

    Tests the rotate_l method re-arranges the piece array as expected.

### Game board class tests

To run game the game board test file, while in the src directory in the terminal, run the following:
```
$ ruby test/game_board_test.rb
```

There are three test cases in the game piece test:

- test_new_game_board_instance

    Tests that when created, game board exists and is not nil.

- test_calculate_score

    Test that the score calculation method produces the correct figure.

- test_calculate_level

    Test that the score calculation method produces the correct figure.

To run both tests at once, while in the src directory in the terminal, run the following:
```
$ ruby test/test_all.rb
```

# References

Hagenaars, M.A., Holmes, E.A., Klaassen, F. and Elzinga, B. (2017). Tetris and Word games lead to fewer intrusive memories when applied several days after analogue trauma. European Journal of Psychotraumatology, 8(sup1), p.1386959.

tetris.wiki. (n.d.). Super Rotation System - TetrisWiki. [online] Available at: https://tetris.wiki/Super_Rotation_System.

‌
tetris.wiki. (n.d.). Scoring - TetrisWiki. [online] Available at: https://tetris.wiki/Scoring.

‌strlen.com. (n.d.). Square — Wouter van Oortmerssen. [online] Available at: http://strlen.com/square/ [Accessed 11 Apr. 2021].

‌