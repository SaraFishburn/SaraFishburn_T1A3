# frozen_string_literal: true

# Import gems
require 'curses'
require 'json'
require 'ordinal'
require 'tty-file'
require 'os'

# Import supporting files
require_relative 'classes/game_board'
require_relative 'helpers/curses_setup'
require_relative 'helpers/highscores'
require_relative 'helpers/welcome_and_over'

# If highscores array does not exist, create file
begin
  # Identify json file and parse contents
  file = './highscores.json'
rescue Errno::ENOENT
  TTY::File.create_file 'highscores.json', nil
end

# If the file cant be read, populate the file with an empty highscores array
begin
  JSON.parse(File.read(file))
rescue Errno::ENOENT
  create_json('highscores.json')
end

highscores = JSON.parse(File.read(file))

# Apply curses settings
Curses.curs_set(0)
Curses.init_screen
Curses.start_color
Curses.noecho

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

  # Display the welcome screen
  welcome_screen(tetris_window)

  if OS.mac?
    spawn('afplay ./tetris_theme.mp3')
  elsif OS.posix?
    spawn('mpg123 ./tetris_theme.mp3')
  elsif OS.windows?
    require 'win32/sound'
    Win32.Sound.play('./tetris_theme.mp3')
  end

  # Create a loop to play the game and start a new game on game over
  while tetris_window.nodelay = true

    # Create GameBoard instance
    game_board = GameBoard.new(tetris_window, [0, ARGV[0].to_i].max, ARGV[1].to_i)

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
