def color_pallette
  {
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
end

def setup_colors
  color_pallette.each do |num, color|
    Curses.init_color(num, *color.map { |c| (c / 255.0 * 1000).to_i })
    next unless num < 8

    Curses.init_pair(num, num, num)

    opacity = 0.5
    Curses.init_color(num + 10, *color.map { |c| ((c * opacity) / 255.0 * 1000).to_i })
    Curses.init_pair(num + 10, num + 10, num + 10)
  end
  Curses.init_pair(8, 9, 8)
end

def setup_main_window
  main_window = Curses::Window.new(48, 60, 0, 0)
  main_window.attron(Curses.color_pair(8))
  main_window.box('|', '-')
  main_window.refresh
end

def border_windows
  borders = {
    score: Curses::Window.new(6, 16, 3, 2),
    lvl: Curses::Window.new(5, 7, 10, 2),
    lines: Curses::Window.new(5, 9, 10, 9),
    scoreboard: Curses::Window.new(24, 16, 16, 2),
    tetris: Curses::Window.new(42, 22, 3, 19),
    next: Curses::Window.new(12, 16, 3, 42),
    controls: Curses::Window.new(24, 16, 16, 42)
  }

  borders.each do |name, window|
    setup_border_windows(name, window)
  end
  borders
end

def setup_border_windows(name, window)
  window.attron(Curses.color_pair(8))
  name = name.to_s
  window.box('|', '-')
  window.setpos(0, (window.maxx / 2.0).ceil - (name.length / 2.0).ceil)
  window.addstr(name.upcase)
  window.refresh
end

def content_windows
  content = {
    score_window: Curses::Window.new(4, 14, 4, 3),
    lvl_window: Curses::Window.new(3, 5, 11, 3),
    lines_window: Curses::Window.new(3, 7, 11, 10),
    scoreboard_window: Curses::Window.new(22, 14, 17, 3),
    tetris_window: Curses::Window.new(40, 20, 4, 20),
    next_window: Curses::Window.new(10, 14, 4, 43)
  }

  content.each do |_name, window|
    window.refresh
  end
  content
end

def controls
  {
    'rotate r' => '↑',
    'rotate l' => 'z',
    'left' => '    ←',
    'right' => '   →',
    'drop' => '    ↓'
  }
end

def display_controls
  control_window = border_windows[:controls]
  controls.each_with_index do |(action, key), i|
    control_window.setpos(2 + i * 2, 2)
    control_window.addstr("#{action}:  #{key}")
  end
  control_window.refresh
end
