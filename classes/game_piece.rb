require_relative '../modules/draw'

class GamePiece
  attr_accessor :position, :board, :object_array

  include Draw
  def initialize(board, window)
    @board = board
    @window = window
    @position = {
      x: (@board[0].length / 2) - (((@object_array[0].length - 4) / 2 / 2.0).floor * 2),
      y: 0
    }
  end

  def rotate
    @object_array = @object_array.transpose.map(&:reverse)
    @object_array = @object_array.transpose.reverse unless is_valid_position?
  end

  def move_left
    @position[:x] -= 2
    @position[:x] += 2 unless is_valid_position?
  end

  def move_right
    @position[:x] += 2
    @position[:x] -= 2 unless is_valid_position?
  end

  def move_down(speed)
    @position[:y] += speed * 2
    return true if is_valid_position?

    @position[:y] -= speed * 2
    add_to_board
    false
  end

  def hard_drop
    while move_down(1)
    end
  end

  def is_valid_position?
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero?

        if (position_y + y).negative? || position_y + y >= @board.length ||
           (@position[:x] + x).negative? || @position[:x] + x >= @board[0].length ||
           !@board[position_y + y][@position[:x] + x].zero?
          return false
        end
      end
    end
    true
  end

  def add_to_board
    @object_array.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        next if cell.zero?

        @board[position_y + y][@position[:x] + x] = cell
      end
    end
  end
end
