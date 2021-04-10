# frozen_string_literal: true

# variable functions
def color_pallette
  # key: number assigned to color, value: rgb values of colors
  {
    1 => [128, 232, 221], # Turquoise: i_piece
    2 => [124, 194, 246], # Blue: j_piece
    3 => [249, 193, 160], # Orange: l_piece
    4 => [246, 246, 175], # Yellow: o_piece
    5 => [183, 246, 175], # Green: s_piece
    6 => [175, 129, 228], # Purple: t_piece
    7 => [231, 132, 186], # Pink: z_piece
    8 => [0,   0,   0],   # Black: background
    9 => [255, 255, 255]  # White: main text and borders
  }
end

def controls
  # key: action, value: keyboard control
  {
    'ROTATE R' => '↑',
    'ROTATE L' => 'z',
    'LEFT' => '    ←',
    'RIGHT' => '   →',
    'DROP' => '    ↓'
  }
end

# Initialize colors
def setup_colors
  color_pallette.each do |num, color|
    # Curses colors work off fractions of 1000 so conversion of rgbv alues is required
    Curses.init_color(num, *color.map { |c| (c / 255.0 * 1000).to_i })
    # Do this for the first 7 colors (game pieces)
    next unless num < 8

    Curses.init_pair(num, num, num)

    setup_ghost_colors(num, color)
  end
  # Set black background and white foreground color pair
  Curses.init_pair(8, 9, 8)
end

# Method to initilise colors for ghost pieces
def setup_ghost_colors(num, color)
  # Add 10 to each num to create a new number and assign the opacity-altered color values
  opacity = 0.5
  num += 10

  Curses.init_color(num, *color.map { |c| ((c * opacity) / 255.0 * 1000).to_i })
  Curses.init_pair(num, num, num)
end

# Method to setup main outline window
def setup_main_window
  main_window = Curses::Window.new(48, 60, 0, 0)
  main_window.attron(Curses.color_pair(8))
  main_window.box('|', '-')
  main_window.noutrefresh
  main_window
end

# Method to initialize borders for all windows
def border_windows
  borders = {
    score: Curses::Window.new(6, 16, 3, 2),
    lvl: Curses::Window.new(5, 7, 10, 2),
    lines: Curses::Window.new(5, 9, 10, 9),
    highscores: Curses::Window.new(26, 16, 16, 2),
    tetris: Curses::Window.new(42, 22, 3, 19),
    next: Curses::Window.new(12, 16, 3, 42),
    controls: Curses::Window.new(26, 16, 16, 42)
  }

  # For each window in the hash, setup borders
  borders.each do |name, window|
    setup_border_windows(name, window)
  end
  borders
end

# Method to setup borders on border windows
def setup_border_windows(name, window)
  # Set black and white color pair
  window.attron(Curses.color_pair(8))
  name = name.to_s

  # Apply box border to window with pipe and dash symbols
  window.box('|', '-')

  # Set curser position to the middle of the top border and add name of box
  window.setpos(0, (window.maxx / 2.0).ceil - (name.length / 2.0).ceil)
  window.addstr(name.upcase)

  window.noutrefresh
end

# Method to initialize windows for content
def content_windows
  content = {
    score_window: Curses::Window.new(4, 14, 4, 3),
    lvl_window: Curses::Window.new(3, 5, 11, 3),
    lines_window: Curses::Window.new(3, 7, 11, 10),
    highscores_window: Curses::Window.new(24, 14, 17, 3),
    tetris_window: Curses::Window.new(40, 20, 4, 20),
    next_window: Curses::Window.new(10, 14, 4, 43)
  }

  content.each do |_name, window|
    window.noutrefresh
  end
  content
end

# Method to display the user controls for the game within the contorls window
def display_controls
  control_window = border_windows[:controls]
  # Loop through each action/key pair in the controls hash given by the controls function
  controls.each_with_index do |(action, key), i|
    # Set the position of the pair and add them to the window
    control_window.setpos(2 + i * 2, 2)
    control_window.addstr("#{action}:  #{key}")
  end
  control_window.noutrefresh
end

# Method to dsiplay the top 10 highest scores withing the highscores window
def display_highscores(highscores_array)
  highscores_window = content_windows[:highscores_window]
  # Set the color of the text to be white
  highscores_window.attron(Curses.color_pair(8))
  # Set headings for scores
  highscores_window.setpos(1, 1)
  highscores_window.addstr('# NAME SCORE')

  # Loop through each hash in the highscores array
  highscores_array.each_with_index do |hash, i|
    highscores_window.setpos(4 + i * 2, 1)
    # For the tenth ranking, move the curser one to the left so that the numbers line up on screen
    highscores_window.setpos(4 + i * 2, 0) if i > 8
    # Add name and score for each hash to the window
    highscores_window.addstr("#{i + 1} #{hash['name']} #{hash['score'].rjust(6, ' ')}")
  end
  highscores_window.noutrefresh
end
