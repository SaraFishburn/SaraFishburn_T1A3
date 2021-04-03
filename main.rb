# frozen_string_literal: true

require 'curses'
require_relative 'classes/game_board'

Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

controls = {
  rotate: '  ↑',
  left: '    ←',
  right: '   →',
  drop: '    ↓'
}

def setup_colors
  color_pallette = {
    1 => [128, 232, 221],
    2 => [124, 194, 246],
    3 => [249, 193, 160],
    4 => [246, 246, 175],
    5 => [183, 246, 175],
    6 => [175, 129, 228],
    7 => [231, 132, 186],
    8 => [0,   0,   0],
    9 => [255, 255, 255]
  }

  color_pallette.each do |num, color|
    Curses.init_color(num, *color.map { |c| (c / 255.0 * 1000).to_i })
    Curses.init_pair(num, num, num) if num < 8
  end
  Curses.init_pair(8, 9, 8)
end

def display_controls(control_window, controls)
  controls.each_with_index do |(action, key), i|
    control_window.setpos(2 + i * 2, 2)
    control_window.addstr("#{action}:  #{key}")
  end
  control_window.refresh
end

# WINDOWS LAYOUT
begin
  setup_colors
  main_window = Curses::Window.new(48, 60, 0, 0)
  main_window.attron(Curses.color_pair(8))
  main_window.box('|', '-')
  main_window.refresh
  # win.getch

  windows = {
    score_window: Curses::Window.new(4, 14, 4, 3),
    score: Curses::Window.new(6, 16, 3, 2),

    lines_window: Curses::Window.new(4, 14, 11, 3),
    lines: Curses::Window.new(6, 16, 10, 2),

    scoreboard_window: Curses::Window.new(22, 14, 18, 3),
    scoreboard: Curses::Window.new(24, 16, 17, 2),

    tetris_window: Curses::Window.new(40, 20, 4, 20),
    tetris: Curses::Window.new(42, 22, 3, 19),

    next_window: Curses::Window.new(11, 14, 4, 43),
    next: Curses::Window.new(13, 16, 3, 42),

    controls: Curses::Window.new(24, 16, 17, 42)
  }

  windows.each do |name, window|
    window.attron(Curses.color_pair(8))
    name = name.to_s
    window.box('|', '-')
    window.setpos(0, (window.maxx / 2).ceil - (name.length / 2.0).ceil)
    window.addstr(name.upcase)
    window.refresh
  end
  windows[:tetris_window].keypad true
  windows[:tetris_window].nodelay = true
  display_controls(windows[:controls], controls)

  game_board = GameBoard.new(windows[:tetris_window])
  game_board.fall(windows[:next_window], windows[:lines_window])

  main_window.getch
ensure
  Curses.close_screen
end
