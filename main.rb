# frozen_string_literal: true

def main
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

    welcome_screen(tetris_window)

    while
      tetris_window.nodelay = true

      # Create GameBoard instance
      game_board = GameBoard.new(tetris_window)
      final_score = game_board.fall(content)

      tetris_window.nodelay = false
      new_high_score_message(tetris_window, final_score, file, highscores)

      welcome_screen(tetris_window)

      tetris_window.refresh

      Curses.doupdate
    end

    main_window.getch
  ensure
    Curses.close_screen
  end
end

def game_over(tetris_window, final_score, highscores)
  game_over_message = ['GAME OVER']

  unless places?(final_score, highscores)
    game_over_message = [
      'GAME OVER',
      '',
      'PRESS ENTER',
      'TO CONTINUE'
    ]
  end

  position = {
    x: nil,
    y: tetris_window.maxy / 2 - 6
  }

  tetris_window.clear
  game_over_message.each do |message|
    position[:x] = tetris_window.maxx / 2 - message.length / 2
    tetris_window.setpos(position[:y], position[:x])
    tetris_window.addstr(message)
    position[:y] += 2
  end
  position
end

def new_high_score_message(tetris_window, final_score, file, highscores)
  position = game_over(tetris_window, final_score, highscores)
  unless places?(final_score, highscores)
    start_game(tetris_window)
    return
  end

  Curses.curs_set(2)
  messages = [
    'NEW HIGH SCORE!',
    final_score,
    "#{ranking(find_position(final_score, highscores) + 1)} PLACE",
    '___',
    'ENTER YOUR', 'INITIALS &', 'PRESS ENTER'
  ]
  messages.each do |message|
    message.to_s unless message.instance_of?(String)
    position[:x] = tetris_window.maxx / 2 - message.to_s.length / 2
    position[:y] += 2
    tetris_window.setpos(position[:y], position[:x])
    tetris_window.addstr(message.to_s)
  end
  user_initials(tetris_window, final_score, file, highscores)
  display_highscores(highscores)
end

def user_initials(tetris_window, final_score, file, highscores)
  tetris_window.setpos(24, tetris_window.maxx / 2 - 3 / 2)
  initials = ''
  3.times do
    initial = tetris_window.getch
    initial = tetris_window.getch until initial.is_a?(String)
    tetris_window.addstr(initial)
    initials += initial
    tetris_window.refresh
  end

  key = tetris_window.getch
  key = tetris_window.getch until key == 10

  insert_score(final_score, file, highscores, initials)
  Curses.curs_set(0)
end

def ranking(num)
  case num
  when 1
    '1ST'
  when 2
    '2ND'
  when 3
    '3RD'
  else
    "#{num}TH"
  end
end

def display_logo(tetris_window)
  logo = [
    '    ___      ',
    '   /\  \     ',
    '   \:\  \    ',
    '    \:\  \   ',
    '    /::\  \  ',
    '   /:/\:\__\ ',
    '  /:/  \/__/ ',
    ' /:/  /      ',
    ' \/__/       '
  ]

  position = {
    x: tetris_window.maxx / 2 - logo[0].length / 2,
    y: tetris_window.maxy / 5
  }

  logo.each do |line|
    tetris_window.setpos(position[:y], position[:x])
    tetris_window.addstr(line)
    position[:y] += 1
  end
  tetris_window.noutrefresh
  position
end

def welcome_screen(tetris_window)
  tetris_window.clear
  position = display_logo(tetris_window)

  messages = [
    '*** TETRIS! ***',
    'PRESS ENTER',
    'TO START'
  ]

  messages.each do |message|
    position[:x] = tetris_window.maxx / 2 - message.length / 2
    position[:y] += 2
    tetris_window.setpos(position[:y], position[:x])
    tetris_window.addstr(message)
  end
  tetris_window.noutrefresh
  Curses.doupdate
  start_game(tetris_window)
end

def start_game(tetris_window)
  tetris_window.nodelay = false
  key = tetris_window.getch
  key = tetris_window.getch until key == 10
  tetris_window.nodelay = true
  true
end
main
