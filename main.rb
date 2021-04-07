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
  content[:tetris_window].keypad true
  content[:tetris_window].nodelay = true

  # Create GameBoard instance
  game_board = GameBoard.new(content[:tetris_window])
  final_score = game_board.fall(content)
  
  message = 'game over :('
  @window.clear
  @window.setpos(@window.maxy / 2 - 1, @window.maxx / 2 - message.length / 2)
  @window.addstr(message)
  @window.refresh

  if places?(final_score, highscores)
    insert_score(final_score, file, highscores)
  end

  main_window.getch
ensure
  Curses.close_screen
end
