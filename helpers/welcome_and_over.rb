# frozen_string_literal: true

# Method to display game over message
def game_over(tetris_window, final_score, highscores)
  # This message will display regardless of if player places on highscores board
  game_over_message = ['GAME OVER']

  # If customer doesnt place, provide instructions
  unless places?(final_score, highscores)
    game_over_message = [
      'GAME OVER',
      '',
      'PRESS ENTER',
      'TO CONTINUE'
    ]
  end

  tetris_window.clear

  # Draw messages to the window
  draw_messages(tetris_window, game_over_message, tetris_window.maxy / 2 - 6, 2)
end

# Method to display screen if player's score places on the highscores board
def new_high_score_message(tetris_window, final_score, file, highscores)
  # Inherit position from the game over function
  position = game_over(tetris_window, final_score, highscores)

  # If player, doesnt place, listen for the enter key to continue
  unless places?(final_score, highscores)
    listen_for_enter(tetris_window)
    return
  end

  # Set the curser to visible in the window
  Curses.curs_set(2)
  messages = [
    'NEW HIGH SCORE!',
    final_score,
    "#{(find_position(final_score, highscores) + 1).to_ordinal} PLACE",
    '___',
    'ENTER YOUR', 'INITIALS &', 'PRESS ENTER'
  ]

  # Draw messages to the window
  draw_messages(tetris_window, messages, position[:y] + 2, 2)

  # Execute the user_initials function after the messages have been displayed
  user_initials(tetris_window, final_score, file, highscores)

  # Update the highscores board
  display_highscores(highscores)
end

# Function to get user initials input and store in an array
def user_initials(tetris_window, final_score, file, highscores)
  # Set the position of the curser to the first entry position ('_ _ _')
  tetris_window.setpos(24, tetris_window.maxx / 2 - 3 / 2)
  initials = ''

  # Loop 3 times asking for user input
  3.times do
    initial = tetris_window.getch

    # Ensure the input is alphanumeric
    initial = tetris_window.getch until initial.is_a?(String)

    # Display initial to screen and add to the initial string variable
    tetris_window.addstr(initial)
    initials += initial
    tetris_window.refresh
  end

  # Listen for player to press enter
  listen_for_enter(tetris_window)

  # Add score to highscores
  insert_score(final_score, file, highscores, initials)

  # Hide curser again
  Curses.curs_set(0)
end

# Method to display logo on the welcome screen
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

  # draw logo to window
  draw_messages(tetris_window, logo, tetris_window.maxy / 5, 1)
end

# Method to display the welcome screen
def welcome_screen(tetris_window)
  # Clear the window
  tetris_window.clear

  # Display the logo
  position = display_logo(tetris_window)

  messages = [
    '*** TETRIS! ***',
    'PRESS ENTER',
    'TO START'
  ]

  # Draw the welcome messages to the screen
  draw_messages(tetris_window, messages, position[:y] + 2, 2)

  # listen for player to press enter
  listen_for_enter(tetris_window)
end

# Method to listen for player to press enter and return true
def listen_for_enter(tetris_window)
  # Interrupt window flow and wait for user input
  tetris_window.nodelay = false
  key = tetris_window.getch

  # numerical vlue of the enter key is 10
  key = tetris_window.getch until key == 10

  # After user input, set window to no longer wait for input
  tetris_window.nodelay = true
  true
end

# Method to draw messages stored in arrays to the window
def draw_messages(tetris_window, messages, y_pos, increment)
  position = { x: nil, y: y_pos }

  # Loop through each message in array
  messages.each do |message|
    message = message.to_s
    # Set x position so the message will be centered in the window
    position[:x] = tetris_window.maxx / 2 - message.length / 2
    tetris_window.setpos(position[:y], position[:x])

    # display the message in the window and change the y position ready for the next message
    tetris_window.addstr(message)
    position[:y] += increment
  end
  tetris_window.noutrefresh
  Curses.doupdate
  position
end
