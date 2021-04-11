# frozen_string_literal: true

require_relative '../modules/draw'
require_relative 'i_piece'
require_relative 'j_piece'
require_relative 'l_piece'
require_relative 'o_piece'
require_relative 's_piece'
require_relative 't_piece'
require_relative 'z_piece'

class GameBoard
  # Draw module displays a given array to the tetris window
  include Draw
  attr_reader :object_array, :current_piece, :next_piece, :window, :score
  attr_accessor :deleted_indexes, :level, :lines_cleared

  def initialize(window, game_board_width = 20, game_board_height = 40)
    @window = window
    @game_board_width = game_board_width
    @object_array = Array.new(game_board_height) { [0] * @game_board_width }
    @position = {
      x: 0,
      y: 0
    }
    @score = 0
    @level = 0
    @lines_cleared = 0
    @pieces = [IPiece, JPiece, LPiece, OPiece, SPiece, TPiece, ZPiece]

    # Initially call assign_next_piece twice so a current and next piece is generated
    assign_next_piece
    assign_next_piece
  end

  # Method to generate and calculate the position of the ghost piece
  def calculate_ghost_piece
    # Duplicate the oiece that is in play
    @ghost_piece = @in_play.class.new(@object_array, @window)
    @ghost_piece.position[:x] = @in_play.position[:x]
    @ghost_piece.position[:y] = @in_play.position[:y]

    # Change the values of the ghost piece array so that the opacity color can be applied
    @ghost_piece.object_array = @in_play.object_array.map do |row|
      row.map { |cell| cell.zero? ? 0 : cell + 10 }
    end

    # Move the ghost piece down as far as it can go
    @ghost_piece.hard_drop(main_piece: false)
  end

  # Method to randomly select another piece
  def assign_next_piece
    # Remove the current next_piece from the 'bag' so that it canot be selected again
    @pieces -= [@next_piece]

    # Re-populate the pieces array if it becones empty
    @pieces = [IPiece, JPiece, LPiece, OPiece, SPiece, TPiece, ZPiece] if @pieces.length.zero?

    # Assign new current piece and randomly select next piece from pieces array
    @current_piece = @next_piece
    @next_piece = @pieces.sample
  end

  # Method to create the game piece that will be in play
  def create_piece
    @in_play = @current_piece.new(@object_array, @window)

    # Create the ghost piece give the piece in play
    calculate_ghost_piece
  end

  # Method to determine actions given user input
  def user_input
    key = @window.getch
    case key
    when Curses::KEY_LEFT
      @in_play.move_left
    when Curses::KEY_RIGHT
      @in_play.move_right
    when Curses::KEY_UP
      @in_play.rotate_r
    when 'z'
      @in_play.rotate_l
    when Curses::KEY_DOWN
      @in_play.position = @ghost_piece.position
      @in_play.add_to_board
    end
    # calculate ghost piece after piece movement
    calculate_ghost_piece
  end

  # Method to remove solid lines from the board
  def remove_lines
    @deleted_indexes = []

    # Loop though each line of the board array
    @object_array.each_with_index do |line, i|
      # if the line has a 0 in it, its not solid and should be ignored
      next if line.include?(0)

      # Add 0.5 to the lines_cleared tally (one line is two array rows thick)
      @lines_cleared += 0.5

      # Add the index of the solid line to the deleted_indexes array
      @deleted_indexes << i
    end

    # Delete rows from the board array at the index values in the deleted_indexes array
    @deleted_indexes.reverse.each { |i| @object_array.delete_at(i) }

    # Add rows of zeros to the top of the board array to replace the deleted lines
    @object_array = Array.new(@deleted_indexes.length) { [0] * @game_board_width } + @object_array

    @deleted_indexes
  end

  # Method to calculate the current game level
  def calculate_level
    # Increase level for every 10 lines cleared
    @level = (@lines_cleared / 10).floor
  end

  # Method to calculate the current game score
  def calculate_score
    # Calculate score given the number of lines cleared at once
    case (@deleted_indexes.length / 2)
    when 1
      @score += 40 * (@level + 1)
    when 2
      @score += 100 * (@level + 1)
    when 3
      @score += 300 * (@level + 1)
    when 4
      @score += 1200 * (@level + 1)
    end
    @score
  end

  # Method to display the game stats to their respective windows
  def stats(window, stat)
    # Change stat to an integer and then into a string
    stat = stat.to_i.to_s
    window.erase

    # Position stat number in the middle of its window
    window.setpos((window.maxy / 2), (window.maxx / 2) - (stat.length / 2))

    # Display stat in window
    window.addstr(stat)
    window.noutrefresh
  end

  # Method to display the next piece in the next window
  def display_next_piece(next_window)
    # Remove current contents of next window
    next_window.erase

    # Generate the next piece to display
    piece = @next_piece.new([[0] * next_window.maxx] * next_window.maxy, next_window)

    # Position piece suitably within the next window
    piece.position[:y] = (piece.board.length / 2) - (piece.object_array.length / 2)
    piece.position[:x] = (piece.board[0].length / 2) - (piece.object_array[0].length / 2)

    # Draw piece to the window
    piece.draw
    next_window.noutrefresh
  end

  def calculate_speed
    @speed = (0.8 - ((@level - 1) * 0.007))**(@level - 1)
  end

  def fall(content)
    create_piece
    display_next_piece(content[:next_window])
    loop do
      start_time = Time.now
      @window.erase
      @ghost_piece.draw
      @in_play.draw
      draw
      @window.noutrefresh

      calculate_speed

      unless @in_play.move_down((Time.now - start_time) / @speed)
        assign_next_piece
        create_piece
        display_next_piece(content[:next_window])
        @game_over = !@object_array[0].all?(&:zero?)
        return @score if @game_over
      end

      user_input
      remove_lines
      calculate_level
      calculate_score
      stats(content[:lines_window], @lines_cleared)
      stats(content[:lvl_window], @level)
      stats(content[:score_window], @score)

      Curses.doupdate

      sleep([0, (1 / 60) - (Time.now - start_time)].max)
    end
  end
end
