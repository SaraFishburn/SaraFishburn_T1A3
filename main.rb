# frozen_string_literal: true

require 'curses'
require_relative 'classes/game_board'
require_relative 'curses_setup'

Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

begin
  # functions from curses_setup to initialize the curses display windows
  setup_colors
  setup_main_window
  border_windows
  content = content_windows
  display_controls

  # Setup curses values for the tetris window
  content[:tetris_window].keypad true
  content[:tetris_window].nodelay = true

  # Create GameBoard instance
  game_board = GameBoard.new(content[:tetris_window])
  game_board.fall(content)

  main_window.getch
ensure
  Curses.close_screen
end
