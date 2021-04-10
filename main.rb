# frozen_string_literal: true

# Import gems
require 'curses'
require 'json'
require 'ordinal'

# Import supporting files
require_relative 'classes/game_board'
require_relative 'helpers/curses_setup'
require_relative 'helpers/highscores'
require_relative 'helpers/welcome_and_over'

# Apply curses settings
Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

# Identify json file and parse contents
file = './highscores.json'
highscores = JSON.parse(File.read(file))

begin
  # functions from curses_setup to initialize the curses display windows
  reset_json(file, highscores)
  setup_colors
  main_window = setup_main_window
  border_windows
  content = content_windows
  display_controls
  display_highscores(highscores)

 

  # Setup curses values for the tetris window
  tetris_window = content[:tetris_window]
  tetris_window.keypad true

  # Display the welcome screen
  welcome_screen(tetris_window)

  # Create a loop to play the game and start a new game on game over
  while tetris_window.nodelay = true

    # Create GameBoard instance
    game_board = GameBoard.new(tetris_window)
    final_score = game_board.fall(content)

    # Interrupt flow and wait for user input
    tetris_window.nodelay = false

    # Display game over logic
    new_high_score_message(tetris_window, final_score, file, highscores)

    # Display welcome screen
    welcome_screen(tetris_window)

    tetris_window.refresh

    Curses.doupdate
  end

  main_window.getch
ensure
  Curses.close_screen
end
