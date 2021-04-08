# frozen_string_literal: true

require 'curses'
require_relative 'classes/game_board'
require_relative 'curses_setup'
require_relative 'highscores'
require 'json'

Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

# Identify json file and parse contents
file = './highscores.json'
highscores = JSON.parse(File.read(file))

begin
  # functions from curses_setup to initialize the curses display windows
  setup_colors
  main_window = setup_main_window
  border_windows
  content = content_windows
  display_controls
  display_highscores(highscores)

  # Setup curses values for the tetris window
  tetris_window = content[:tetris_window]
  tetris_window.keypad true
  tetris_window.nodelay = true

  # Create GameBoard instance
  game_board = GameBoard.new(tetris_window)
  final_score = game_board.fall(content)

  message = 'GAME OVER :('
  high_score_message = 'NEW HIGH SCORE!'
  tetris_window.clear
  tetris_window.setpos(tetris_window.maxy / 2 - 1, tetris_window.maxx / 2 - message.length / 2)
  tetris_window.addstr(message)
  if places?(final_score, highscores)
    tetris_window.setpos(tetris_window.maxy / 2 + 2, tetris_window.maxx / 2 - high_score_message.length / 2)
    tetris_window.addstr(high_score_message)
  end

  tetris_window.refresh

  if places?(final_score, highscores)
    insert_score(final_score, file, highscores)
  end

  Curses.doupdate

  main_window.getch
ensure
  Curses.close_screen
end
