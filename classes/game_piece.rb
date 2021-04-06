# frozen_string_literal: true

require_relative '../modules/draw'

# Class that handles the common logic for all game pieces
class GamePiece
  attr_accessor :position, :board, :object_array

  # Draw module displays a given array to the tetris window
  include Draw
  def initialize(board, window)
    @board = board
    @window = window

    # Starting position of game piece in relation to the tetris board array
    @position = {
      x: (@board[0].length / 2) - ((@object_array[0].length / 2 / 2.0).floor * 2),
      y: 0
    }

    # Keeps track of the previous and current rotation position for wall kick logic
    @rotation_state = [0, 0]
  end

  # Method to rotate a game piece clockwise (right)
  def rotate_r
    # Save original rotation state in case reset is required
    original_state = @rotation_state.dup

    # Rearrange the array values into the next clockwise rotation position
    @object_array = @object_array.transpose.map(&:reverse)

    # Set the rotation state
    @rotation_state[0] = @rotation_state[1]
    @rotation_state[1] = (@rotation_state[1] + 1) % 4

    return if check_wall_kick

    # If check_wall_kick (which also checks valid position) is false:
    # - rearrange the array to its original orientation
    # - reset the rotation state
    @object_array = @object_array.transpose.reverse
    @rotation_state = original_state
  end

  # Method to rotate a game piece anti-clockwise (left)
  def rotate_l
    # Save original rotation state in case reset is required
    original_state = @rotation_state.dup

    # Rearrange the array values into the next anti-clockwise rotation position
    @object_array = @object_array.transpose.reverse

    # Set the rotation state
    @rotation_state[0] = @rotation_state[1]
    @rotation_state[1] = (@rotation_state[1] - 1) % 4

    return if check_wall_kick

    # If check_wall_kick (which also checks valid position) is false:
    # - rearrange the array to its original orientation
    # - reset the rotation state
    @object_array = @object_array.transpose.map(&:reverse)
    @rotation_state = original_state
  end

  # Method to move game piece left
  def move_left
    # Shift x position left by 2 (each square on game board is 2x2 array elements)
    @position[:x] -= 2

    # Reset x position if the new position isnt valid
    @position[:x] += 2 unless is_valid_position?
  end

  # Method to move game piece right
  def move_right
    # Shift x position right by 2
    @position[:x] += 2

    # Reset x position if the new position isnt valid
    @position[:x] -= 2 unless is_valid_position?
  end

  # Method to move game piece down at a given speed
  def move_down(speed, main_piece: true)
    # Speed is determined by formula with game level variable and doubled due to size of board
    # Add speed * 2 to y position
    @position[:y] += speed * 2
    return true if is_valid_position?

    # Reset y position if new position isnt valid
    @position[:y] -= speed * 2

    # main_piece because if its a ghost piece it shouldnt be added
    add_to_board if main_piece
    false
  end

  # Method to (seemingly) instantly move game piece down as far as it can go
  def hard_drop(main_piece: true)
    while move_down(1, main_piece: main_piece)
    end
  end

  # Method to check if the position of a piece is valid
  def is_valid_position?
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        # Next if:
        # - The cell of the game piece array is 0 (not part of the 'physical' piece)
        # - The cell of the game piece array is 'above' the first row of the tetris board array
        next if cell.zero? || (position_y + y).negative?

        # Check if:
        # - Part of the game piece is 'lower' that the bottom of the board
        # - Part of the game piece is outside of the left or right bounds of the tetris board array
        # - Part of the game piece is overlapping another landed piece on the tetris game board
        if position_y + y >= @board.length ||
           (@position[:x] + x).negative? || @position[:x] + x >= @board[0].length ||
           !@board[position_y + y][@position[:x] + x].zero?
          return false
        end
      end
    end
    true
  end

  # Method to check if a wall kick is possible given a rotation attempt
  def check_wall_kick
    # if the position of the game piece after rotation is valid, no wall kick is required
    return true if is_valid_position?

    # Change the position of the game piece given the piece's wall kick data
    wall_kick_data[@rotation_state[0]][@rotation_state[1]].each do |pair|
      @position[:x] += pair[:x] * 2
      @position[:y] += pair[:y] * 2
      return true if is_valid_position?

      # Reset to original position if the new position isnt valid
      @position[:x] -= pair[:x] * 2
      @position[:y] -= pair[:y] * 2
    end
    false
  end

  # Method to add game piece to the tetris board array one piece has landed in the window
  def add_to_board
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        # Dont change value of the board cell of the value of the game piece array is 0
        next if cell.zero?
        
        #replace current game board cell with the corresponding game piece number
        @board[position_y + y][@position[:x] + x] = cell
      end
    end
  end
end
