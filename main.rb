# frozen_string_literal: true

require 'curses'
require_relative 'classes/game_board'
require_relative 'curses_setup'

Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

# WINDOWS LAYOUT
begin
  setup_colors
  setup_main_window
  border_windows
  content = content_windows
  display_controls

  content[:tetris_window].keypad true
  content[:tetris_window].nodelay = true

  game_board = GameBoard.new(content[:tetris_window])
  game_board.fall(content)

  main_window.getch
ensure
  Curses.close_screen
end
